# zen

One Zen setup shared by macOS ([hypr-mac](https://github.com/RyanAHayden/hypr-mac)) and Linux ([dotfiles](https://github.com/RyanAHayden/dotfiles)), both of which clone this to `~/zen` and run `setup.sh`. Taken from the Zen profile on omarchy-desktop.

`setup.sh`:
- installs Zen (Homebrew cask `zen` / `zen-browser-bin` from the AUR)
- applies `policies.json` (search engines: DuckDuckGo default, YouTube, Brave, Google, with shortcuts `d`, `y`, `b`, `g` in the address bar; Bing/Perplexity/Wikipedia/eBay removed, and the built-in DuckDuckGo/Google swapped for policy ones, since only those can have a shortcut) and installs everything in `extensions.txt` (`<addon id> <addons.mozilla.org slug>`) through enterprise policy: macOS `app.zen-browser.zen` prefs, Linux the package's `distribution/policies.json` (reset by updates - installed extensions stay, re-run for new ones)
- links `user.js` (prefs, reapplied every start - change them here) and `chrome/` (Catppuccin Mocha userChrome/userContent, the Ghost Tabs and No Top Sites mods) into every profile
- copies `zen-themes.json` (the mods list) and merges `customKeys.json` (Cmd/Ctrl+1-5 workspaces, Alt+A/D previous/next workspace, Cmd/Ctrl+J downloads, Cmd/Ctrl+Shift+A add-ons)
- merges `vimium.json` into Vimium's settings (its `storage.sync` row in the profile's `storage-sync-v2.sqlite`; other settings stay): smooth scrolling off, and on YouTube `m` passed through to the page instead of making a mark. Zen must be closed, and the database only exists once Zen has run with add-ons, so on a fresh install re-run after first opening it
- turns off the Library (`zen.library.enabled`) and puts the plain Downloads button back in the sidebar
- turns off split view (drag/click splitting prefs, its shortcuts unbound, menu entries hidden)
- turns off the macOS window blur (`zen.widget.macos.window-vibrancy`)
- keeps window sync on (`zen.window-sync.enabled`): with it off, links that open Zen can come up in a blank window

On a fresh install it starts Zen once without a window to create the profile, so it all applies in one run. Quit Zen before running it, otherwise the mods list and the Library button are skipped. Bookmarks, history and tabs come from Firefox Sync (sign in once per machine, after setup). Sync can carry add-ons too; `extensions.txt` is the set every new machine starts with. Prefs in `user.js` win over synced settings every start.

`youtube-fullscreen.user.js` makes `m` toggle fullscreen on YouTube (Vimium keeps `f` for link hints; YouTube's own `m` mute is swallowed). Violentmonkey can't be filled in by setup, so open https://raw.githubusercontent.com/RyanAHayden/zen/main/youtube-fullscreen.user.js once per machine and install it; it updates from there.
