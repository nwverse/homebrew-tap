# Homebrew formula for the disklessly CLI.
# Generated from packaging/homebrew/disklessly-cli.rb in nwverse/disklessly for 0.3.0.
class DisklesslyCli < Formula
  desc "Offload rarely used Mac apps to a repo and launch them on demand"
  homepage "https://github.com/nwverse/disklessly"
  version "0.3.0"
  license :cannot_represent

  on_macos do
    url "https://github.com/nwverse/disklessly/releases/download/v#{version}/disklessly-#{version}-macos-universal.tar.gz"
    sha256 "4874282b06883c6640135e88bb1c3bd1f524f7971d7d049449fdc97e278bd4d4"
  end

  on_linux do
    on_arm do
      url "https://github.com/nwverse/disklessly/releases/download/v#{version}/disklessly-#{version}-linux-aarch64.tar.gz"
      sha256 "37a438b51b5dbf3eed263cbd6674b997377f3b33472e370f0263807cc86f6beb"
    end
    on_intel do
      url "https://github.com/nwverse/disklessly/releases/download/v#{version}/disklessly-#{version}-linux-x86_64.tar.gz"
      sha256 "838ee938d98333fbb8d451ddada6075bc9086a2b8a1b2386be2e667005b4fbf8"
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
    <<~EOS
      The macOS build in this release is not signed with an Apple Developer ID and is
      not notarized, so Gatekeeper blocks it the first time it runs. Clear the
      quarantine flag Homebrew sets:
        xattr -dr com.apple.quarantine "#{opt_bin}/disklessly" "#{opt_bin}/disklessly-stub"

      Stubs exec a stable copy of the engine under
        ~/Library/Application Support/Disklessly/bin/disklessly
      After installing or upgrading, refresh that copy and your stubs:
        disklessly install-engine
        disklessly stub refresh --app <bundle id>   # once per packed app; see `disklessly list`

      Replacing apps in /Applications needs App Management permission for your
      terminal (System Settings > Privacy & Security > App Management).

      On Linux the binary needs glibc 2.34 or newer, plus libsqlite3, libcurl, and
      libxml2. Offloading apps (pack, launch, unpack, stubs) is macOS only.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/disklessly version")
    output = shell_output("#{bin}/disklessly 2>&1", 64)
    assert_match "disklessly help", output
  end
end
