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

echo "==> zen: policies (policies.json + extensions.txt)"
ext=$(grep -v -e '^#' -e '^$' "$REPO/extensions.txt" | jq -R -n '[inputs | split(" ") | {key: .[0], value: {
	install_url: "https://addons.mozilla.org/firefox/downloads/latest/\(.[1])/latest.xpi",
	installation_mode: "normal_installed"}}] | from_entries')
policies=$(jq --argjson ext "$ext" '.ExtensionSettings = $ext' "$REPO/policies.json")
if [ "$(uname)" = Darwin ]; then
	# policy prefs (domain = bundle id), one key per policy, so the signed app bundle is never touched
	defaults write app.zen-browser.zen EnterprisePoliciesEnabled -bool true
	for key in $(jq -r 'keys[]' <<<"$policies"); do
		defaults write app.zen-browser.zen "$key" "$(jq --arg k "$key" '.[$k]' <<<"$policies" |
			plutil -convert xml1 -o - - | sed -n '/^<dict>/,/^<\/dict>/p')"
	done
else
	# package updates reset this file; installed extensions stay, re-run to restore the rest
	file=/opt/zen-browser-bin/distribution/policies.json
	jq --argjson p "$policies" '.policies += $p' "$file" >/tmp/zen-policies.json
	sudo install -m644 /tmp/zen-policies.json "$file"
	rm /tmp/zen-policies.json
fi

echo "==> zen: profiles"
if [ ! -f "$PROFILES/profiles.ini" ]; then
	# fresh install: start Zen once without a window so it makes its own default profiles (the same ones a first
	# launch would, so it opens them later and Firefox Sync can be signed into as usual), then stop it
	echo "  no profile yet, creating it"
	if [ "$(uname)" = Darwin ]; then zen=/Applications/Zen.app/Contents/MacOS/zen; else zen=zen-browser; fi
	MOZ_NO_REMOTE=1 "$zen" --headless --no-remote >/dev/null 2>&1 &
	pid=$!
	for _ in $(seq 60); do [ -f "$PROFILES/installs.ini" ] && break; sleep 0.5; done
	sleep 2
	kill $pid 2>/dev/null || true
	wait $pid 2>/dev/null || true
	if [ ! -f "$PROFILES/profiles.ini" ]; then
		echo "  Zen didn't create a profile - open it once, quit it and re-run this"
		exit 0
	fi
fi
running && echo "  Zen is running: skipping the mods list and Library button (quit Zen and re-run for those)"
sed -n 's/^Path=//p' "$PROFILES/profiles.ini" | while read -r p; do
	dir="$PROFILES/$p"
	[ -d "$dir" ] || continue
	if [ -e "$dir/chrome" ] && [ ! -L "$dir/chrome" ]; then rm -rf "$dir/chrome.bak" && mv "$dir/chrome" "$dir/chrome.bak"; fi
	ln -sfn "$REPO/chrome" "$dir/chrome"
	ln -sf "$REPO/user.js" "$dir/user.js"
	# merged, not linked: Zen rewrites customKeys.json when shortcuts are changed in settings
	keys="$dir/customKeys.json"
	[ -f "$keys" ] || echo '{}' >"$keys"
	jq -s '.[0] * .[1]' "$keys" "$REPO/customKeys.json" >"$keys.tmp" && mv "$keys.tmp" "$keys"
	if ! running; then
		cp "$REPO/zen-themes.json" "$dir/zen-themes.json"
		# Library button -> Downloads button (zen.library.enabled=false only changes the default for new profiles)
		if [ -f "$dir/prefs.js" ]; then
			sed -i.bak 's/\\"zen-library-button\\"/\\"downloads-button\\"/' "$dir/prefs.js" && rm "$dir/prefs.js.bak"
		fi
	fi
done
echo "==> zen: done, restart Zen to apply"
