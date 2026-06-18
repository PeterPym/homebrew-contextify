class ContextifyQuery < Formula
  desc "CLI for querying Contextify database - enables Claude Code/Codex skills"
  homepage "https://contextify.sh"
  version "1.6.2"
  license "Proprietary"

  # Download pre-built binary from GitHub releases
  if Hardware::CPU.arm?
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-arm64.tar.gz"
    sha256 "58e4a327ec6c1f6af886dc7f112647df484a22f37b77966a049146f0bb8d6a35"
  else
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-x86_64.tar.gz"
    sha256 "0a8fde24fdf12b91d5b848785ad485da7594e18f583198a82703c07050afd5ba"
  end

  depends_on :macos

  def install
    # Install unified binary as 'contextify' (primary)
    bin.install "contextify"
    # Create backwards-compatible symlinks
    bin.install_symlink "contextify" => "contextify-query"
    bin.install_symlink "contextify" => "contextify-ingest"

    # Install plugin files for `contextify install-plugin` command
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
      contextify has been installed.

      To enable Contextify skills in Claude Code and Codex CLI, run:
        contextify install-plugin

      This installs the Total Recall skill to:
        - ~/.claude/skills/total-recall/  (Claude Code)
        - ~/.codex/skills/total-recall/   (Codex CLI)

      Requires Contextify.app for database access.

      Verify installation:
        contextify status

      If you see "database not found":
        1. Install Contextify from the Mac App Store
        2. Open Contextify once to initialize the database
        3. Run: contextify status

      Note: 'contextify-query' still works for backwards compatibility.

      For more information:
        https://contextify.sh/docs/cli
    EOS
  end

  test do
    # Check unified binary runs and shows version
    assert_match "contextify", shell_output("#{bin}/contextify --version")
    # Check symlink works
    assert_match "contextify", shell_output("#{bin}/contextify-query --version")
  end
end
