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
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.3/disklessly-0.3.3-macos-universal.tar.gz"
      sha256 "8ea830c1b7ace35b7d54762f1a6df333c9331ad141fb17a1950de7b31bf8bdcd"
    end
    on_intel do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.3/disklessly-0.3.3-macos-universal.tar.gz"
      sha256 "8ea830c1b7ace35b7d54762f1a6df333c9331ad141fb17a1950de7b31bf8bdcd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.3/disklessly-0.3.3-linux-aarch64.tar.gz"
      sha256 "2e540cbf8c285c20a516c657195610b39b1911bfae364980f8f5ded74f28e1d3"
    end
    on_intel do
      url "https://github.com/nwverse/disklessly/releases/download/v0.3.3/disklessly-0.3.3-linux-x86_64.tar.gz"
      sha256 "9ea97bdf39c967a3ceb5f47a371f094ede7d69469b25a5501f2cd3406136da3f"
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
