// Zen prefs shared by macOS and Linux (linked into every profile by setup.sh), from the Zen profile on omarchy-desktop.
// user.js is reapplied on every start, so change settings here rather than in about:preferences.

// no Library: the sidebar keeps the plain Downloads button
user_pref("zen.library.enabled", false);
// window sync stays on (Zen 1.17+: windows share tabs/spaces). With it off, Zen sometimes builds a window in no space,
// which shows nothing, and rebuilds that broken window from the last closed one every time a link opens Zen
user_pref("zen.window-sync.enabled", true);

// a new window opens on the macOS Space you're on: with no window open, Zen builds it from the last closed one,
// Space included, and session restore would move it back there
user_pref("browser.sessionstore.restore_windows_to_virtual_desktop", false);

user_pref("zen.view.compact.enable-at-startup", false);
// no macOS blur: the window background is solid, not the frosted wallpaper behind it (any see-through is the window
// manager's opacity, like every other window)
user_pref("zen.widget.macos.window-vibrancy", false);
// no split view: dragging/clicking tabs never splits (its shortcuts are unbound in customKeys.json, menus hidden in userChrome.css)
user_pref("zen.splitView.enable-tab-drop", false);
user_pref("zen.splitView.enable-drag-over-split", false);
user_pref("zen.splitView.enable-tab-click-split", false);
user_pref("zen.splitView.min-resize-width", 0);
user_pref("zen.splitView.rearrange-hover-size", 0);
user_pref("zen.tabs.close-on-back-with-no-history", false);
// "No Top Sites" mod: hide all suggestions when opening the URL bar
user_pref("mod.ivaon.urlbar.hide_results", "0");

user_pref("browser.startup.homepage", "chrome://browser/content/blanktab.html");
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.toolbars.bookmarks.visibility", "always");
user_pref("browser.bookmarks.defaultLocation", "toolbar_____");
user_pref("browser.bookmarks.showMobileBookmarks", false);
user_pref("browser.urlbar.suggest.engines", false);
user_pref("general.autoScroll", true);

// passwords live in KeePassXC, not the browser
user_pref("signon.rememberSignons", false);
user_pref("signon.autofillForms", false);
user_pref("signon.generation.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);
user_pref("dom.forms.autocomplete.formautofill", true);
user_pref("privacy.clearOnShutdown_v2.formdata", true);

user_pref("network.dns.disablePrefetch", true);
user_pref("network.prefetch-next", false);
user_pref("network.http.speculative-parallel-limit", 0);

user_pref("accessibility.typeaheadfind.flashBar", 0);
user_pref("media.videocontrols.picture-in-picture.display-text-tracks.size", "small");
user_pref("media.webspeech.synth.dont_notify_on_error", true);

// chrome/userChrome.css + userContent.css (Catppuccin Mocha)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
