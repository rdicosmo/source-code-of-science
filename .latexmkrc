# Build against the vendored biblatex-software in ./style (bltx-v1.2-8, crossref support),
# so the concise crossrefexpansion bibliography renders even where the system package is
# older (Debian 13 ships pre-crossref v1.2-5). See style/README.txt.
$ENV{'TEXINPUTS'} = './style//:' . ($ENV{'TEXINPUTS'} // '');

# Capture the git state at build time and expose it to the footer as \gitinfo.
# Runs on every latexmk invocation (so `make` and a bare `latexmk` agree).
# gitinfo.tex is generated and git-ignored; the preamble has an "unknown" fallback.
{
    my $hash = `git rev-parse --short=8 HEAD 2>/dev/null`;
    chomp $hash;
    $hash = 'unknown' unless $hash =~ /\S/;
    my $dirty = `git status --porcelain 2>/dev/null`;
    $hash .= '-dirty' if $dirty =~ /\S/;
    if (open(my $fh, '>', 'gitinfo.tex')) {
        print $fh "\\def\\gitinfo{$hash}\n";
        close($fh);
    }
}
