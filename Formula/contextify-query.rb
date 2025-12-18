class ContextifyQuery < Formula
  desc "CLI for querying Contextify database - enables Claude Code/Codex skills"
  homepage "https://contextify.sh"
  version "1.0.2"
  license "Proprietary"

  # Download pre-built binary from GitHub releases
  if Hardware::CPU.arm?
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-query-arm64.tar.gz"
    sha256 "PLACEHOLDER_ARM64_SHA256"
  else
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-query-x86_64.tar.gz"
    sha256 "PLACEHOLDER_X86_64_SHA256"
  end

  depends_on :macos

  def install
    bin.install "contextify-query"
  end

  def caveats
    <<~EOS
      contextify-query has been installed.

      This CLI enables Contextify skills in Claude Code and Codex.
      Requires Contextify.app to be running for database access.

      Verify installation:
        contextify-query status

      If you see "database not found":
        1. Install Contextify from the Mac App Store
        2. Open Contextify once to initialize the database
        3. Run: contextify-query status

      For more information:
        https://contextify.sh/docs/cli
    EOS
  end

  test do
    # Just check it runs and shows version
    assert_match "contextify-query", shell_output("#{bin}/contextify-query --version")
  end
end
