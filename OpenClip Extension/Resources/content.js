const url = new URL(location.href);

chrome.runtime.sendMessage({ type: "getVersion" }, version => {
    localStorage.setItem("OpenClip-currentVersion", version);
});

(async () => {
    const isInstagramPurchased = await checkInstagramPurchaseStatus();
    const wasInstagramPurchased = localStorage.getItem('instagramPurchaseStatus') === 'true';
    if (isInstagramPurchased !== wasInstagramPurchased) {
        localStorage.setItem('instagramPurchaseStatus', String(isInstagramPurchased));
        window.location.reload();
    }
})();

async function checkInstagramPurchaseStatus() {
    const response = await new Promise(resolve => {
        chrome.runtime.sendMessage({ type: 'checkInstagramPurchaseStatus' }, response => resolve(response));
    });
    return Boolean(response?.instagramPurchaseStatus);
}

if (url.hostname.includes('tiktok.com')) {
    if (/^\/@[^/]*\/(video|photo)\/\d+/.test(url.pathname)) {
        // Player: Redirect TikTok videos and photo slideshows to playable links
        const newUrl = url.href.split('?')[0] + '?_r=1'; // _r=1 embeds comments below video
        
        if (newUrl !== url.href) {
            // Redirect!
            location.replace(newUrl);
        } else {
            // URL has been redirected. We can now modify the DOM.
            initTikTok();
        }
    } else if (/^\/@[^/]+\/?$/.test(url.pathname) || /^\/discover\//.test(url.pathname)) {
        // Channel: Modify TikTok channel and discover pages
        initTikTok();
    }
    
} else if (url.hostname.includes('instagram.com')) {
    if (/^\/(reel|p)\/[^/]+/.test(url.pathname)) {
        const newUrl = url.href.split('?')[0] + `?l=1`;
        
        if (newUrl !== url.href) {
            // Redirect!
            location.replace(newUrl);
        } else {
            // URL has been redirected. We can now modify the DOM.
            initInstagram(true);
        }
    } else if (/\/(posts|feed|reels|saved|tagged)\/?$/.test(url.pathname)) {
        // Profile: Modify logged out profile page
        initInstagram(false);
        
    } else {
        redirectEmptyProfilePaths();
    }
}

function initTikTok() {
    onDomReady(() => {
        injectCss('openclip-tiktok-css', 'tiktok.css');
        injectJs('openclip-tiktok-js', 'tiktok.js');
    });
    
    // Inject OpenClip banner at bottom of page
    const observer = new MutationObserver(() => {
        appendOpenClipFooter(observer);
    });
    observer.observe(document, { childList: true, subtree: true });
}

function appendOpenClipFooter(observer) {
    const messageId = "openclip-message";
    if (document.getElementById(messageId)) return;
    
//    localStorage.setItem("OpenClip-footerValue", String(0)); // testing
    
    var footerValue = Number(localStorage.getItem("OpenClip-footerValue") || 0);
    const wasInstagramPurchased = localStorage.getItem('instagramPurchaseStatus') === 'true';
    if (wasInstagramPurchased && (footerValue == 0 || footerValue == 1)) {
        footerValue = 2;
    }
    
    // 0 - not purchased (default)
    // 1 - not purchased, dismissed
    // 2 - purchased
    // 3 - purchased, dismissed
    const messages = {
        0: `
            OpenClip now supports
            <b class="medium">Instagram Reels</b>!
            <a href="openclip://instagram">Activate it in the app today.</a>
        `,
        2: `Thank you for supporting development! ❤️`
    };
    
    const messageHTML = messages[footerValue];
    if (!messageHTML) return;
    
    const comments = document.querySelector('div[class*="DivCommentListContainer"]');
    const parent = comments.parentNode;
    const iconURL = browser.runtime.getURL("images/app-icon.png");
    
    if (!comments || !parent || !iconURL) return;
    
    const footer = document.createElement("div");
    footer.id = messageId;
    footer.innerHTML = `
        <img src="${iconURL}" alt="OpenClip Icon">
        <p>${messageHTML}</p>
        <button aria-label="Dismiss">✕</button>
    `;
    
    footer.querySelector("button").addEventListener("click", () => {
        footer.style.display = "none";
        localStorage.setItem("OpenClip-footerValue", String(footerValue + 1));
    });
    
    parent.append(footer);
    observer.disconnect();
}

function initInstagram(isReel) {
    if (localStorage.getItem('instagramPurchaseStatus') !== 'true') return;
    
    onDomReady(() => {
        if (isReel) {
            injectCss('openclip-instagram-css', 'instagram.css');
            injectJs('openclip-instagram-js', 'instagram.js');
        } else {
            injectCss('openclip-instagram-css', 'instagram-profile.css');
            injectJs('openclip-instagram-js', 'instagram-profile.js');
        }
    });
    
    // If the user is logged into Instagram, remove CSS/JS to not interfere
    const observer = new MutationObserver(() => {
        const nav = document.querySelector('nav');
        if (nav) {
            removeCss('openclip-instagram-css');
            removeJs('openclip-instagram-js');
            observer.disconnect();
        }
    });
    
    observer.observe(document, { childList: true, subtree: true });
}

function redirectEmptyProfilePaths() {
    const headObserver = new MutationObserver(() => {
        const titleEl = document.querySelector("title");
        if (!titleEl || !document.title) return;

        const match = document.title.match(/@([a-z0-9._]+)/i);
        if (!match) return;

        const username = match[1];
        const newPath = `/${username}/posts/`;
        
        headObserver.disconnect();

        if (location.pathname !== newPath) {
            location.replace(newPath);
        }
    });

    headObserver.observe(document.documentElement, {
        childList: true,
        subtree: true
    });
}

function onDomReady(callback) {
    if (document.readyState === 'loading') {
        window.addEventListener('DOMContentLoaded', callback);
    } else {
        callback();
    }
}

function injectCss(id, filename) {
    if (document.getElementById(id)) return;

    const url = chrome.runtime.getURL(filename);
    const link = document.createElement('link');
    link.id = id;
    link.rel = 'stylesheet';
    link.href = url;
    
    document.head.appendChild(link);
}

function injectJs(id, filename) {
    if (document.getElementById(id)) return;

    const url = chrome.runtime.getURL(filename);
    const script = document.createElement('script');
    script.id = id;
    script.src = url;
    script.type = 'text/javascript';
    script.defer = true;
    
    document.head.appendChild(script);
}

function removeCss(id) {
    const link = document.getElementById(id);
    if (link && link.tagName === 'LINK') {
        link.remove();
    }
}

function removeJs(id) {
    const script = document.getElementById(id);
    if (script && script.tagName === 'SCRIPT') {
        script.remove();
    }
}
