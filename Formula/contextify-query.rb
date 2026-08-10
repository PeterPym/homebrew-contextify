class ContextifyQuery < Formula
  desc "CLI for querying Contextify database - enables Claude Code/Codex skills"
  homepage "https://contextify.sh"
  version "1.7.7"
  license :cannot_represent

  # Download pre-built binary from GitHub releases
  if Hardware::CPU.arm?
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-arm64.tar.gz"
    sha256 "c3851c519081549ed5ded79f1fad223351a53d3d6ef07418a7ef1eefee075868"
  else
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-x86_64.tar.gz"
    sha256 "71db7730d2ae8bed45e0ce871dcb9d51ac5476a3ba0d6af708b1989d65f8b334"
  end

  depends_on :macos

  def install
    # Install unified binary as 'contextify' (primary)
    bin.install "contextify"
    # Create backwards-compatible symlinks
    bin.install_symlink "contextify" => "contextify-query"
    bin.install_symlink "contextify" => "contextify-ingest"

    # Companion payload consumed by `contextify install-plugin` (ct-3803).
    # The CLI resolves each at <prefix>/share/<name>; a tarball missing one of
    # these dirs is a broken release artifact, so fail the install loudly
    # instead of pouring a bottle that silently cannot install the Codex
    # researcher agent (PeterPym/contextify#4). FNM_DOTMATCH keeps hidden
    # entries like claude-plugin/.claude-plugin/plugin.json.
    # codex-plugin is deliberately NOT installed: no macOS marketplace flow
    # exists (declared exception `no-macos-marketplace-flow` in
    # scripts/release/lib/cli-companions.manifest in the main repo).
    %w[claude-plugin user-skill codex-agent].each do |companion|
      odie "#{companion}/ missing from CLI tarball (ct-3803 bug class)" unless File.directory?(companion)
      (share/companion).install Dir.glob("#{companion}/*", File::FNM_DOTMATCH).grep_v(%r{/\.\.?$})
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
    # Installed companion layout: every path the CLI resolver reads from the
    # Cellar must exist, or install-plugin silently skips that payload (ct-3803).
    assert_path_exists share/"claude-plugin/agents/contextify-researcher.md"
    assert_path_exists share/"claude-plugin/.claude-plugin/plugin.json"
    assert_path_exists share/"user-skill/total-recall/SKILL.md"
    assert_path_exists share/"codex-agent/contextify-researcher.toml"
  end
end
