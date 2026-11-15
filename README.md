# nwverse Homebrew tap

Homebrew formulae for [nwverse](https://github.com/nwverse) projects.

## Install the Disklessly CLI

```sh
brew tap nwverse/tap
brew install disklessly-cli
```

`nwverse/tap` is this repository (`nwverse/homebrew-tap`); Homebrew shortens
`homebrew-` tap names, so `brew tap nwverse/tap` is the command to use.

This installs the `disklessly` command and the `dkl` alias. On macOS it also
installs `disklessly-stub`, the launcher that packed apps run through.

The macOS binary in the 0.3.0 release is **not signed with an Apple Developer ID
and is not notarized**, so Gatekeeper blocks the first run. `brew install` prints
the `xattr` command that clears the quarantine flag; run it once after installing.

On Linux, Homebrew installs the matching build (x86_64 or aarch64). It needs
glibc 2.34 or newer, plus `libsqlite3`, `libcurl`, and `libxml2`. Offloading apps
is macOS only; the Linux build covers files and folders, container images, remote
machines, and coding-agent sessions. See
[docs/linux.md](https://github.com/nwverse/disklessly/blob/main/docs/linux.md).

The menu-bar app (the `disklessly` cask) is not published yet. It waits for an
Apple Developer ID certificate.

## Verify a download

Release assets and their checksums are on the
[Disklessly releases](https://github.com/nwverse/disklessly/releases) page
(`SHA256SUMS`).
