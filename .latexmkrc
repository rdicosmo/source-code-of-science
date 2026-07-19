# Build against the vendored biblatex-software in ./style (bltx-v1.2-8, crossref support),
# so the concise crossrefexpansion bibliography renders even where the system package is
# older (Debian 13 ships pre-crossref v1.2-5). See style/README.txt.
$ENV{'TEXINPUTS'} = './style//:' . ($ENV{'TEXINPUTS'} // '');
