#!/usr/bin/env bash
# Sets up Zen the same way on macOS (run from hypr-mac) and Linux (run from dotfiles).
# Safe to re-run. Quit Zen first for the mods list and the Library -> Downloads button swap.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(uname)" = Darwin ]; then
	command -v brew >/dev/null && brew install --cask zen 2>/dev/null || true
	PROFILES="$HOME/Library/Application Support/zen"
	running() { pgrep -f "Zen.app/Contents/MacOS/zen" >/dev/null; }
else
	command -v zen-browser >/dev/null || yay -S --needed zen-browser-bin
	command -v jq >/dev/null || sudo pacman -S --needed jq
	PROFILES="$HOME/.config/zen"
	[ -f "$PROFILES/profiles.ini" ] || PROFILES="$HOME/.zen"
	running() { pgrep -x zen-bin >/dev/null; }
fi

echo "==> zen: extensions"
ext=$(grep -v -e '^#' -e '^$' "$REPO/extensions.txt" | jq -R -n '[inputs | split(" ") | {key: .[0], value: {
	install_url: "https://addons.mozilla.org/firefox/downloads/latest/\(.[1])/latest.xpi",
	installation_mode: "normal_installed"}}] | from_entries')
if [ "$(uname)" = Darwin ]; then
	# policy prefs (domain = bundle id), so the signed app bundle is never touched
	defaults write app.zen-browser.zen EnterprisePoliciesEnabled -bool true
	defaults write app.zen-browser.zen ExtensionSettings "$(jq -n --argjson ext "$ext" '$ext' |
		plutil -convert xml1 -o - - | sed -n '/^<dict>/,/^<\/dict>/p')"
else
	# package updates reset this file; installed extensions stay, re-run to pick up new ones
	policies=/opt/zen-browser-bin/distribution/policies.json
	jq --argjson ext "$ext" '.policies.ExtensionSettings = ((.policies.ExtensionSettings // {}) + $ext)' "$policies" >/tmp/zen-policies.json
	sudo install -m644 /tmp/zen-policies.json "$policies"
	rm /tmp/zen-policies.json
fi

echo "==> zen: profiles"
if [ ! -f "$PROFILES/profiles.ini" ]; then
	echo "  no profile yet - open Zen once, quit it and re-run this"
	exit 0
fi
running && echo "  Zen is running: skipping the mods list and Library button (quit Zen and re-run for those)"
sed -n 's/^Path=//p' "$PROFILES/profiles.ini" | while read -r p; do
	dir="$PROFILES/$p"
	[ -d "$dir" ] || continue
	[ -e "$dir/chrome" ] && [ ! -L "$dir/chrome" ] && rm -rf "$dir/chrome.bak" && mv "$dir/chrome" "$dir/chrome.bak"
	ln -sfn "$REPO/chrome" "$dir/chrome"
	ln -sf "$REPO/user.js" "$dir/user.js"
	# merged, not linked: Zen rewrites customKeys.json when shortcuts are changed in settings
	keys="$dir/customKeys.json"
	[ -f "$keys" ] || echo '{}' >"$keys"
	jq -s '.[0] * .[1]' "$keys" "$REPO/customKeys.json" >"$keys.tmp" && mv "$keys.tmp" "$keys"
	if ! running; then
		cp "$REPO/zen-themes.json" "$dir/zen-themes.json"
		# Library button -> Downloads button (zen.library.enabled=false only changes the default for new profiles)
		[ -f "$dir/prefs.js" ] && sed -i.bak 's/\\"zen-library-button\\"/\\"downloads-button\\"/' "$dir/prefs.js" && rm "$dir/prefs.js.bak"
	fi
done
echo "==> zen: done, restart Zen to apply"
