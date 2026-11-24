# nwverse Homebrew tap

Homebrew formulae for [nwverse](https://github.com/nwverse) projects.

## Install Disklessly

```sh
brew install --cask nwverse/tap/disklessly    # menu-bar app; also links disklessly and dkl
brew install nwverse/tap/disklessly-cli       # or only the CLI (macOS and Linux)
```

Install one or the other, not both.

`nwverse/tap` is this repository (`nwverse/homebrew-tap`); Homebrew shortens
`homebrew-` tap names, so `brew tap nwverse/tap` is the command to use.

The cask installs the signed, notarized **Disklessly.app** and links the CLI inside it.
The formula installs the `disklessly` command and the `dkl` alias; on macOS it also
installs `disklessly-stub`, the launcher that packed apps run through. Since 0.3.2 the
macOS binaries are signed with an Apple Developer ID and notarized, so no `xattr`
step is needed.

On Linux, Homebrew installs the matching build (x86_64 or aarch64). It needs
glibc 2.34 or newer, plus `libsqlite3`, `libcurl`, and `libxml2`. Offloading apps
is macOS only; the Linux build covers files and folders, container images, remote
machines, and coding-agent sessions. See
[docs/linux.md](https://github.com/nwverse/disklessly/blob/main/docs/linux.md).

## Verify a download

Release assets and their checksums are on the
[Disklessly releases](https://github.com/nwverse/disklessly/releases) page
(`SHA256SUMS`).
