// Zen prefs shared by macOS and Linux (linked into every profile by setup.sh), from the Zen profile on omarchy-desktop.
// user.js is reapplied on every start, so change settings here rather than in about:preferences.

// no Library: the sidebar keeps the plain Downloads button
user_pref("zen.library.enabled", false);
// windows don't share tabs/spaces (Zen 1.17+ window sync), so a new window opens blank like it used to
user_pref("zen.window-sync.enabled", false);

user_pref("zen.view.compact.enable-at-startup", false);
user_pref("zen.splitView.enable-tab-drop", false);
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
