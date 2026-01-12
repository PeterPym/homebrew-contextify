class ContextifyQuery < Formula
  desc "CLI for querying Contextify database - enables Claude Code/Codex skills"
  homepage "https://contextify.sh"
  version "1.1.0"
  license "Proprietary"

  # Download pre-built binary from GitHub releases
  if Hardware::CPU.arm?
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-linux-arm64.tar.gz"
    sha256 "cb3541193dd4fea3bb88b188f6d7c779942bd1a70d9a3bb86e2f4c6c85b82623"
  else
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-linux-x86_64.tar.gz"
    sha256 "464c6f53ef7755c54a867974fd49a78377548eb7fee882b4298eec43cb5c1732"
  end

  depends_on :macos

  def install
    bin.install "contextify-query"
    # Install plugin files for `contextify-query install-plugin` command
    # Use Dir.glob with File::FNM_DOTMATCH to include hidden directories like .claude-plugin
    if File.directory?("claude-plugin")
      (share/"claude-plugin").install Dir.glob("claude-plugin/*", File::FNM_DOTMATCH).reject { |f| f =~ /\/\.\.?$/ }
    end
    # Install user skill for Total Recall feature
    if File.directory?("user-skill")
      (share/"user-skill").install Dir.glob("user-skill/*")
    end
  end

  def caveats
    <<~EOS
      contextify-query has been installed.

      To enable Contextify skills in Claude Code and Codex CLI, run:
        contextify-query install-plugin

      This installs the Total Recall skill to:
        - ~/.claude/skills/total-recall/  (Claude Code)
        - ~/.codex/skills/total-recall/   (Codex CLI)

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
