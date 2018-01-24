clean:
    rm -f tags
    sn c .

name:
    github-release edit -s $(cat .git-token) -u vmchale -r project-init -n "$(madlang run ~/programming/madlang/releases/releases.mad)" -t "$(grep -P -o '\d+\.\d+\.\d+' Cargo.toml | head -n1)"

test:
    @tomlcheck --file rustfmt.toml
    @tomlcheck --file Cargo.toml
    @yamllint .travis.yml
    @yamllint appveyor.yml
    rm -rf project/
    cargo run -- new miso project
    rm -rf project/
    cargo run -- new haskell project
    cd project/ && cabal new-build && hlint .
    rm -rf project/
    cargo run -- new idris project
    cd project/ && idris --testpkg test.ipkg
    rm -rf project/
    cargo run -- new elm project
    cd project/ && elm-make --yes src/main.elm
    rm -rf project/
    cargo run -- new rust project
    cd project/ && cargo bench
    rm -rf project/
    cargo run -- new reco project
    cd project && reco check
    rm -rf project
    cargo run -- new mad story
    cd story && madlang run src/story.mad
    rm -rf story
    cargo run -- new ats sample
    cd sample && atspkg build target/sample && ./target/sample
    rm -rf sample
    cargo run -- git vmchale/madlang-miso project
    rm -rf project
    cargo run -- git vmchale/haskell-ats project
    cd project && ./shake.hs && cabal new-build
    rm -rf project

# cd project && just script && ./build
manpages:
    pandoc man/MANPAGE.md -s -t man -o man/pi.1

diff:
    git diff master origin/master

patch:
    @rm -f tags
    cargo release -l patch --no-dev-version
