# Homebrew formula template for the disklessly CLI.
# Copy the result into a tap (for example nwverse/homebrew-tap/Formula/disklessly-cli.rb)
# and fill in the sha256 of each release archive. `brew audit` rejects `url` and
# `sha256` directly inside `on_macos` or `on_linux`, so each one is nested under
# `on_arm` and `on_intel`. The macOS archive is universal, so both architectures
# point at the same file.
class DisklesslyCli < Formula
  desc "Offload rarely used Mac apps to a repo and launch them on demand"
  homepage "https://github.com/nwverse/disklessly"
  license :cannot_represent

  on_macos do
    on_arm do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.2/disklessly-0.3.2-macos-universal.tar.gz"
      sha256 "9e04f39bdef6a1ed5fae85520086ccb004c6943e76dbc4a14c9831149c13f56c"
    end
    on_intel do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.2/disklessly-0.3.2-macos-universal.tar.gz"
      sha256 "9e04f39bdef6a1ed5fae85520086ccb004c6943e76dbc4a14c9831149c13f56c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.2/disklessly-0.3.2-linux-aarch64.tar.gz"
      sha256 "4f9862f317c4a352fe3acd09cb79f5150f539c49a06ff089c654a94327e758f1"
    end
    on_intel do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.2/disklessly-0.3.2-linux-x86_64.tar.gz"
      sha256 "b47b3f09d2a48829cc92995623cb24a1a84382656e141f6f0cb74b34aba3a26b"
    end
  end

  def install
    # disklessly looks for the dashboard page at ../share/disklessly/web.
    bin.install "bin/disklessly"
    bin.install_symlink "disklessly" => "dkl"
    (share/"disklessly").install "share/disklessly/web"
    # The stub launcher is macOS only; the Linux build has no disklessly-stub.
    bin.install "bin/disklessly-stub" if OS.mac?
    if OS.mac?
      doc.install "README.md", "CHANGELOG.md", "PRIVACY.md", "THIRD_PARTY_NOTICES.md"
    else
      doc.install Dir["share/doc/disklessly/*"]
    end
  end

  def caveats
    on_macos do
      <<~EOS
        Stubs exec a stable copy of the engine under
          ~/Library/Application Support/Disklessly/bin/disklessly
        After installing or upgrading, refresh that copy and your stubs:
          disklessly install-engine
          disklessly stub refresh --app <bundle id>   # once per packed app; see `disklessly list`

        Replacing apps in /Applications needs App Management permission for your
        terminal (System Settings > Privacy & Security > App Management).
      EOS
    end
    on_linux do
      <<~EOS
        The binary needs glibc 2.34 or newer, plus libsqlite3, libcurl, and libxml2.
        Offloading apps (pack, launch, unpack, stubs) is macOS only.
      EOS
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/disklessly version")
    output = shell_output("#{bin}/disklessly 2>&1", 64)
    assert_match "disklessly help", output
  end
end
