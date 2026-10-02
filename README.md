# Homebrew Tap for Contextify

This tap contains Homebrew formulae for [Contextify](https://contextify.sh) tools.

## Installation

```bash
brew install PeterPym/contextify/contextify-cli
```

After installation, enable Claude Code skills:

```bash
contextify install-plugin
```

Then restart Claude Code to activate the plugin.

## Available Formulae

### contextify-cli

CLI tool for querying the Contextify database. Enables Contextify skills in Claude Code.

**Requirements:**
- macOS 14.0 (Sonoma) or later
- [Contextify.app](https://apps.apple.com/app/contextify) installed and initialized

**Setup:**

```bash
# 1. Install the CLI
brew install PeterPym/contextify/contextify-cli

# 2. Install the Claude Code plugin
contextify install-plugin

# 3. Restart Claude Code

# 4. Verify installation
contextify status
```

**Usage:**

```bash
# Check database status
contextify status

# Search entries
contextify search "error handling"

# List projects
contextify projects

# Get help
contextify --help
```

**Plugin Management:**

```bash
# Install/update Claude Code plugin
contextify install-plugin

# Remove Claude Code plugin
contextify uninstall-plugin
```

## Why a Separate CLI?

App Store apps run in a sandbox that prevents them from installing CLI tools to system paths. This Homebrew tap provides the CLI as a separately-installed tool that works alongside the App Store version of Contextify.

If you use the DMG version of Contextify (from contextify.sh/download), the CLI and plugin are automatically installed and you don't need this tap.

## Formula Rename

This formula was named `contextify-query` before 1.8.3. If you installed it under that name, run
this once:

```bash
brew upgrade peterpym/contextify/contextify-cli
```

That moves your install to `contextify-cli` and upgrades it. The `contextify` command is unchanged,
and `contextify-query` keeps working until at least April 1, 2027.

## Upgrading

```bash
brew upgrade peterpym/contextify/contextify-cli
contextify install-plugin  # Re-run to update plugin
```

## Troubleshooting

**"database not found" error:**
1. Install Contextify from the Mac App Store
2. Open Contextify once to initialize the database
3. Run: `contextify status`

**Plugin not working in Claude Code:**
1. Run: `contextify install-plugin`
2. Restart Claude Code completely (quit and reopen)
3. Check plugin is registered: `cat ~/.claude/plugins/installed_plugins.json`

## Support

- Documentation: https://contextify.sh/docs/cli
- Issues: https://github.com/PeterPym/contextify/issues

## License

Contextify CLI is proprietary software. See https://contextify.sh/terms for details.
