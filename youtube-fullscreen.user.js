// ==UserScript==
// @name        YouTube: m toggles fullscreen
// @namespace   https://github.com/RyanAHayden/zen
// @match       https://www.youtube.com/*
// @run-at      document-start
// @grant       none
// @downloadURL https://raw.githubusercontent.com/RyanAHayden/zen/main/youtube-fullscreen.user.js
// ==/UserScript==

// Vimium has f for link hints, so m (passed through by Vimium's YouTube exclusion rule) stands in for
// YouTube's f. Caught on window in the capture phase so YouTube's own m (mute) never sees it.
window.addEventListener("keydown", (e) => {
	if (e.key !== "m" || e.ctrlKey || e.metaKey || e.altKey) return;
	const el = e.composedPath()[0];
	if (el instanceof Element && (el.isContentEditable || /^(INPUT|TEXTAREA|SELECT)$/.test(el.tagName))) return;
	const button = document.querySelector(".ytp-fullscreen-button");
	if (!button) return;
	e.preventDefault();
	e.stopImmediatePropagation();
	button.click();
}, true);
