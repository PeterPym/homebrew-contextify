# Homebrew Tap for Contextify

This tap contains Homebrew formulae for [Contextify](https://contextify.sh) tools.

## Installation

```bash
brew install PeterPym/contextify/contextify-query
```

After installation, enable Claude Code skills:

```bash
contextify-query install-plugin
```

Then restart Claude Code to activate the plugin.

## Available Formulae

### contextify-query

CLI tool for querying the Contextify database. Enables Contextify skills in Claude Code.

**Requirements:**
- macOS 14.0 (Sonoma) or later
- [Contextify.app](https://apps.apple.com/app/contextify) installed and initialized

**Setup:**

```bash
# 1. Install the CLI
brew install PeterPym/contextify/contextify-query

# 2. Install the Claude Code plugin
contextify-query install-plugin

# 3. Restart Claude Code

# 4. Verify installation
contextify-query status
```

**Usage:**

```bash
# Check database status
contextify-query status

# Search entries
contextify-query search "error handling"

# List projects
contextify-query projects

# Get help
contextify-query --help
```

**Plugin Management:**

```bash
# Install/update Claude Code plugin
contextify-query install-plugin

# Remove Claude Code plugin
contextify-query uninstall-plugin
```

## Why a Separate CLI?

App Store apps run in a sandbox that prevents them from installing CLI tools to system paths. This Homebrew tap provides the CLI as a separately-installed tool that works alongside the App Store version of Contextify.

If you use the DMG version of Contextify (from contextify.sh/download), the CLI and plugin are automatically installed and you don't need this tap.

## Upgrading

```bash
brew upgrade contextify-query
contextify-query install-plugin  # Re-run to update plugin
```

## Troubleshooting

**"database not found" error:**
1. Install Contextify from the Mac App Store
2. Open Contextify once to initialize the database
3. Run: `contextify-query status`

**Plugin not working in Claude Code:**
1. Run: `contextify-query install-plugin`
2. Restart Claude Code completely (quit and reopen)
3. Check plugin is registered: `cat ~/.claude/plugins/installed_plugins.json`

## Support

- Documentation: https://contextify.sh/docs/cli
- Issues: https://github.com/PeterPym/contextify/issues

## License

Contextify CLI is proprietary software. See https://contextify.sh/terms for details.
