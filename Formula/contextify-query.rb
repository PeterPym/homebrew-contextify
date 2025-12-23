class ContextifyQuery < Formula
  desc "CLI for querying Contextify database - enables Claude Code/Codex skills"
  homepage "https://contextify.sh"
  version "1.0.6"
  license "Proprietary"

  # Download pre-built binary from GitHub releases
  # Note: Currently arm64 only. x86_64 build will be added when needed.
  if Hardware::CPU.arm?
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-query-arm64.tar.gz"
    sha256 "631a249f36c1ef3500848233b664b59ad513a7219383efed66ddc01e7ee28089"
  else
    # x86_64 binary not yet available - using arm64 for now (runs via Rosetta)
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-query-arm64.tar.gz"
    sha256 "631a249f36c1ef3500848233b664b59ad513a7219383efed66ddc01e7ee28089"
  end

  depends_on :macos

  def install
    bin.install "contextify-query"
    # Install plugin files for `contextify-query install-plugin` command
    # Use Dir.glob with File::FNM_DOTMATCH to include hidden directories like .claude-plugin
    if File.directory?("claude-plugin")
      (share/"claude-plugin").install Dir.glob("claude-plugin/*", File::FNM_DOTMATCH).reject { |f| f =~ /\/\.\.?$/ }
    end
  end

  def caveats
    <<~EOS
      contextify-query has been installed.

      To enable Contextify skills in Claude Code, run:
        contextify-query install-plugin

      Requires Contextify.app for database access.

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
