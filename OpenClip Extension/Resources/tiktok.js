// Player - Force "Watch again" button to always reload the video
fixWatchAgainButton();

// Player - Allow navigation to commenter profiles
attachCommentHandlers();

// Player - Add channel button support
attachChannelHandler();

// Player - Add share button support
attachShareHandler("play-side-share");

// Channel - Add share button support
attachShareHandler("share-btn");

// Channel - Allow taps on suggested videos
addRecommendationHandlers();

const observer = new MutationObserver(() => {
    // All - Remove smart app banner and automatically close popups
    document.querySelector('meta[name="apple-itunes-app"]')?.remove();
    document.querySelector('button[class*="close-button"]')?.click();
    document.querySelector('span[data-e2e*="launch-popup-close"]')?.click();
    
    // Discover - Redirect to hero video
    redirectToHeroVideo();
});

observer.observe(document, { childList: true, subtree: true });

function fixWatchAgainButton() {
    let didWatchAgain = false;
    
    document.addEventListener("click", function(event) {
        if (!event.target.closest('div[class*="DivFinishCoverOverlay"]')) return;
        
        if (didWatchAgain) {
            // e.preventDefault(); // breaks capture
            event.stopPropagation();
            location.reload();
        } else {
            didWatchAgain = true;
        }
    }, true);
}

function attachCommentHandlers() {
  document.addEventListener("click", e => {
      const link = e.target.closest(
        'a[class*="StyledUserLinkAvatar"], a[class*="StyledUserLinkName"]'
      );
      if (!link) return;

      e.preventDefault();
      e.stopPropagation();

      const href = link.getAttribute("href");
      if (!href) return;

      location.assign(href);
    }, true);
}

function attachChannelHandler() {
    document.addEventListener("click", e => {
        const authorButton = e.target.closest('div[data-e2e="play-side-author"]');
        if (!authorButton) return;

        e.preventDefault();
        e.stopPropagation();

        const link = authorButton.querySelector("a");
        if (!link) return;

        window.location.href = link.href;
    }, true); // capture phase to match original behavior
}

function attachShareHandler(identifier) {
    document.addEventListener("click", e => {
        const shareButton = e.target.closest(`div[data-e2e="${identifier}"]`);
        if (!shareButton) return;

        e.preventDefault();
        e.stopPropagation();

        navigator.share?.({
            title: document.title,
            url: window.location.href
        }) || alert("Sharing not supported");
    }, true);
}

function addRecommendationHandlers() {
    document.addEventListener("click", e => {
        const item = e.target.closest('div[class*="DivMultiColumnItemContainer"]');
        if (!item) return;

        const link = item.querySelector("a");
        if (!link) return;

        e.preventDefault();
        e.stopPropagation();

        window.location.href = link.href + "?_r=1";
    }, true);
}

function redirectToHeroVideo() {
    const link = document.querySelector('div[class*="DivVideoCard"][style*="grid-column"] div[class*="DivVideoPlayer"] a');
    if (link) {
        const newUrl = link.href.split('?')[0] + '?_r=1';
        location.replace(newUrl);
    }
}
