# zen

One Zen setup shared by macOS ([hypr-mac](https://github.com/RyanAHayden/hypr-mac)) and Linux ([dotfiles](https://github.com/RyanAHayden/dotfiles)), both of which clone this to `~/zen` and run `setup.sh`. Taken from the Zen profile on omarchy-desktop.

`setup.sh`:
- installs Zen (Homebrew cask `zen` / `zen-browser-bin` from the AUR)
- applies `policies.json` (search engines: DuckDuckGo default, YouTube, Brave, Google; Bing/Perplexity/Wikipedia/eBay removed) and installs everything in `extensions.txt` (`<addon id> <addons.mozilla.org slug>`) through enterprise policy: macOS `app.zen-browser.zen` prefs, Linux the package's `distribution/policies.json` (reset by updates - installed extensions stay, re-run for new ones)
- links `user.js` (prefs, reapplied every start - change them here) and `chrome/` (Catppuccin Mocha userChrome/userContent, the Ghost Tabs and No Top Sites mods) into every profile
- copies `zen-themes.json` (the mods list) and merges `customKeys.json` (Cmd/Ctrl+1-5 workspaces, Alt+A/D previous/next workspace, Cmd/Ctrl+J downloads, Cmd/Ctrl+Shift+A add-ons)
- turns off the Library (`zen.library.enabled`) and puts the plain Downloads button back in the sidebar
- turns off window sync (`zen.window-sync.enabled`), so new windows open blank instead of mirroring your spaces

On a fresh install it starts Zen once without a window to create the profile, so it all applies in one run. Quit Zen before running it, otherwise the mods list and the Library button are skipped. Bookmarks, history and tabs come from Firefox Sync (sign in once per machine, after setup). Sync can carry add-ons too; `extensions.txt` is the set every new machine starts with. Prefs in `user.js` win over synced settings every start.
