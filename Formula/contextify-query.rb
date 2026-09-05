class ContextifyQuery < Formula
  desc "CLI for querying Contextify database - enables Claude Code/Codex skills"
  homepage "https://contextify.sh"
  version "1.8.0"
  license :cannot_represent

  # Download pre-built binary from GitHub releases
  if Hardware::CPU.arm?
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-arm64.tar.gz"
    sha256 "a37462fab95b63b63625d5152f8368bef1d98c1112519d924866cd745c42fdca"
  else
    url "https://github.com/PeterPym/contextify/releases/download/v#{version}/contextify-x86_64.tar.gz"
    sha256 "ba67c814ef4d54fe9903935735a6821502e0f4a4b5e3e523376139b0d8fc6d13"
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
      unless File.directory?(companion)
        odie <<~MSG
          Can't finish installing contextify-query: '#{companion}/' is missing from the release tarball.
          This is a packaging bug on our side, not anything you did, and it means the CLI would not be
          able to install one of its integrations (the Codex researcher agent or a Claude Code skill).

          Please report it so we can ship a fix quickly:
            email:  rob@contextify.sh
            issue:  https://github.com/PeterPym/contextify/issues/new?template=bug_report.md

          Include the version above and this message. Thanks for flagging it.
        MSG
      end
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
