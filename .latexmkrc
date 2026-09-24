# Build against the vendored biblatex-software in ./style (bltx-v1.2-8, crossref support),
# so the concise crossrefexpansion bibliography renders even where the system package is
# older (Debian 13 ships pre-crossref v1.2-5). See style/README.txt.
$ENV{'TEXINPUTS'} = './style//:' . ($ENV{'TEXINPUTS'} // '');

# Capture the git state at build time and expose it to the footer as \gitinfo,
# and the date of the commit being built as \builddate.
# Runs on every latexmk invocation (so `make` and a bare `latexmk` agree).
# gitinfo.tex is generated and git-ignored; the preamble has fallbacks for both.
#
# \builddate is the COMMIT date, not today's date: it is a property of the
# sources, so two people building the same revision get the same title page.
# A tree with uncommitted changes falls back to today, which is honest -- such a
# build does not correspond to any commit.
{
    my $hash = `git rev-parse --short=8 HEAD 2>/dev/null`;
    chomp $hash;
    $hash = 'unknown' unless $hash =~ /\S/;
    my $dirty = `git status --porcelain 2>/dev/null`;
    my $is_dirty = ($dirty =~ /\S/) ? 1 : 0;
    $hash .= '-dirty' if $is_dirty;

    my $date = '';
    unless ($is_dirty) {
        $date = `LC_ALL=C git log -1 --format=%cd --date=format:'%B %-d, %Y' 2>/dev/null`;
        chomp $date;
    }

    # The release version comes from the annotated tag, so the tag is the single
    # source of truth and nothing has to be kept in sync by hand. On a tagged,
    # clean tree this is "1.6"; between releases it is "1.5-3-g0a1b2c3d"; with
    # uncommitted changes it gains a trailing "+".
    my $ver = `git describe --tags --dirty=+ 2>/dev/null`;
    chomp $ver;
    $ver =~ s/^v//;

    if (open(my $fh, '>', 'gitinfo.tex')) {
        print $fh "\\def\\gitinfo{$hash}\n";
        print $fh "\\def\\builddate{$date}\n" if $date =~ /\S/;
        print $fh "\\def\\noteversion{$ver}\n" if $ver =~ /\S/;
        close($fh);
    }
}

# Compute the intrinsic identifier of the sources this build comes from, and
# expose it to the note as \thisswhid.  This is the mechanism Appendix J
# describes, running on itself.
#
# Two properties make it work, and they are the whole point:
#   - a SWHID is computed from the content, so the build can DERIVE it offline
#     rather than be told it; anyone checking out this revision gets the same
#     number, and therefore the same PDF;
#   - swhid.tex is generated and git-ignored, so stamping the document does not
#     change the tree the identifier names.
#
# Computed only when the tree is CLEAN: a dirty tree is not what gets archived,
# so stamping it would print an identifier naming something that was never
# published.  Cached on the HEAD hash, so the cost is paid once per commit.
# Requires the `swh` CLI (pip install swh.model); without it the note builds
# unstamped and says so.
{
    my $stamp = 'swhid.tex';
    my $origin = 'https://github.com/rdicosmo/source-code-of-science';

    my $head = `git rev-parse HEAD 2>/dev/null`; chomp $head;
    my $dirty = `git status --porcelain 2>/dev/null`;
    my $clean = ($head =~ /^[0-9a-f]{40}$/ && $dirty !~ /\S/) ? 1 : 0;

    my $cached = '';
    if (open(my $fh, '<', $stamp)) {
        local $/; my $c = <$fh>; close($fh);
        $cached = $1 if $c =~ /^% built-from ([0-9a-f]{40})/m;
    }

    if (!$clean) {
        unlink $stamp if -e $stamp;          # never stamp a tree that is not the archived one
    } elsif ($head ne $cached) {
        my $tmp = `mktemp -d`; chomp $tmp;
        my $core = '';
        if ($tmp =~ /\S/) {
            system("git archive HEAD | tar -x -C '$tmp' 2>/dev/null");
            my $out = `swh identify --type directory '$tmp' 2>/dev/null`;
            ($core) = $out =~ /(swh:1:dir:[0-9a-f]{40})/;
            system("rm -rf '$tmp'");
        }
        if ($core && open(my $fh, '>', $stamp)) {
            print $fh "% built-from $head\n";
            print $fh "\\def\\thisswhidcore{$core}\n";
            print $fh "\\def\\thisswhidorigin{$origin}\n";
            print $fh "\\def\\thisswhidanchor{swh:1:rev:$head}\n";
            print $fh "\\def\\thisswhid{$core;origin=$origin;anchor=swh:1:rev:$head}\n";
            close($fh);
        } else {
            unlink $stamp if -e $stamp;      # swh CLI missing: build unstamped
        }
    }
}
