# Homebrew Tap for Contextify

This tap contains Homebrew formulae for [Contextify](https://contextify.sh) tools.

## Installation

```bash
brew tap PeterPym/contextify
brew install contextify-query
```

Or install directly:

```bash
brew install PeterPym/contextify/contextify-query
```

## Available Formulae

### contextify-query

CLI tool for querying the Contextify database. Enables Contextify skills in Claude Code and Codex.

**Requirements:**
- macOS 14.0 (Sonoma) or later
- [Contextify.app](https://apps.apple.com/app/contextify) installed and initialized

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

## Why a Separate CLI?

App Store apps run in a sandbox that prevents them from installing CLI tools to system paths. This Homebrew tap provides the CLI as a separately-installed tool that works alongside the App Store version of Contextify.

If you use the DMG version of Contextify (from contextify.sh/download), the CLI is automatically installed and you don't need this tap.

## Support

- Documentation: https://contextify.sh/docs/cli
- Issues: https://github.com/PeterPym/contextify/issues

## License

Contextify CLI is proprietary software. See https://contextify.sh/terms for details.
