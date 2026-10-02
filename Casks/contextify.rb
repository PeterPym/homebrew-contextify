cask "contextify" do
  version "1.8.2"
  sha256 "67ab28f68fc3fd32113a5d1ad1c56369e1bf02dbd222df0cdd3618bcaa46d2e6"

  url "https://github.com/PeterPym/contextify/releases/download/v#{version}/Contextify.dmg"
  name "Contextify"
  desc "Keeps your Claude Code and Codex history in a searchable archive"
  homepage "https://contextify.sh/"

  livecheck do
    url "https://contextify.sh/appcast.xml"
    strategy :sparkle, &:short_version
  end

  auto_updates true
  depends_on macos: :sequoia

  app "Contextify.app"

  uninstall quit: "sh.contextify.Contextify"

  # The app can install a command-line shim outside its bundle (Settings > CLI), with
  # contextify-query and contextify-ingest links to it. It is left on plain uninstall and on
  # upgrade (an upgrade must not drop a working CLI); without the app it says so and how to fix it.
  # Zap removes it. Remove a `contextify` only when it is a regular file (never a symlink, so never
  # a Homebrew formula's link) carrying both the shim marker and the shim's own help text, which the
  # full CLI lacks. Remove an alias only when it links to exactly `contextify`. A shim the app
  # installed with administrator rights (root-owned /usr/local/bin) needs sudo; if that is refused,
  # print the exact command (bash's printf %q quotes any path) instead.
  zap script: {
        executable:   "/bin/bash",
        args:         [
          "-c",
          'for d in /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin" "$HOME/bin"; do ' \
          'f="$d/contextify"; ' \
          '[ -f "$f" ] && [ ! -L "$f" ] && grep -aq dev.contextify.contextify-query-shim.v1 "$f" ' \
          '&& grep -aq "This shim locates Contextify" "$f" || continue; ' \
          'set -- "$f"; ' \
          "for a in contextify-query contextify-ingest; do " \
          '[ -L "$d/$a" ] && [ "$(readlink "$d/$a")" = contextify ] && set -- "$@" "$d/$a"; done; ' \
          'if [ -w "$d" ]; then rm -f -- "$@"; ' \
          'elif /usr/bin/sudo rm -f -- "$@"; then :; ' \
          'else printf "Contextify left its CLI shim behind. Remove it with: sudo rm -f"; ' \
          'printf " %q" "$@"; echo; fi; done',
        ],
        must_succeed: false,
      },
      trash:  [
        "~/Library/Application Support/Contextify",
        "~/Library/Application Support/dev.contextify",
        "~/Library/Caches/sh.contextify.Contextify",
        "~/Library/HTTPStorages/sh.contextify.Contextify",
        "~/Library/HTTPStorages/sh.contextify.Contextify.binarycookies",
        "~/Library/Preferences/dev.contextify.plist",
        "~/Library/Preferences/sh.contextify.Contextify.plist",
        "~/Library/Saved Application State/sh.contextify.Contextify.savedState",
      ]

  caveats <<~EOS
    Contextify keeps your session archive in ~/Library/Application Support/Contextify
    unless you chose another location in Settings. `brew uninstall --zap` deletes it,
    and also removes the command-line shim the app may have installed.
  EOS
end
