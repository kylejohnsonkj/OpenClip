attachProfileHandler();
attachUsernameHandler();

const observer = new MutationObserver(() => {
    attachShareHandler();
    changeWatchAgainLabel();
    createWatchAgainButton();
});

// Observe the whole document
observer.observe(document, { childList: true, subtree: true });

function attachProfileHandler() {
    document.addEventListener('click', e => {
        const authorButton = e.target.closest('span:has(img[alt*="profile picture"])');
        if (!authorButton) return;
        
        e.preventDefault();
        e.stopPropagation();
        
        const metaTag = document.querySelector('meta[property="og:url"]');
        let url = metaTag?.getAttribute('content') || window.location.href;
        url = url.replace(/\/reel\/.*$/, '/reels/');
        
        window.location.href = url;
    }, true);
}

function attachUsernameHandler() {
    document.addEventListener("click", e => {
        const usernameRow = e.target.closest(
            'div[class*="html-div"] > a[href*="/reels/"]'
        );

        if (!usernameRow) return;

        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();

        const href = usernameRow.getAttribute("href");
        if (href) {
            window.location.href = href;
        }
    });
}

function attachShareHandler() {
    const actionRow = document.querySelector(`div[aria-label="Video player"] > div > div > div + div`);
    
    if (!actionRow || actionRow.dataset.listenerAttached) return;
    actionRow.dataset.listenerAttached = 'true';
    
    actionRow.addEventListener('click', e => {
        const label = e.target.closest('div[role="button"]')?.querySelector('svg[aria-label]')?.getAttribute('aria-label');
        if (!label) return;
        
        e.preventDefault();
        e.stopPropagation();
        
        const title = document.querySelector('meta[property="og:title"]');
        
        if (label === 'Share') {
            navigator.share?.({
                title: title?.content || document.title,
                url: window.location.href
            }) || alert("Sharing not supported");
        }
    }, true);
}

function changeWatchAgainLabel() {
    const twitterMeta = document.querySelector('meta[name="twitter:title"]');
    if (!twitterMeta) return;
    
    const fullTitle = twitterMeta.content;
    if (!fullTitle) return;
    
    const username = fullTitle.split(' • ')[0].trim();
    
    const element = [...document.querySelectorAll('h3')]
        .find(el => el.textContent.trim() === "Sign up to keep watching");
    if (!element) return;
    
    element.textContent = username;
    
    if (element.parentElement) {
        element.parentElement.style.pointerEvents = 'none';
    }
    
    if (element.parentElement?.parentElement) {
        element.parentElement.parentElement.style.pointerEvents = 'auto';
    }
}

function createWatchAgainButton() {
    const endButtons = document.querySelectorAll('a[href*="/accounts/signup/phone"]');
    
    endButtons.forEach(link => {
        if (link.firstChild.textContent !== "Watch again") {
            link.firstChild.textContent = "Watch again";
            
            link.addEventListener("click", function(e) {
                e.preventDefault();
                e.stopPropagation();
                location.reload();
            });
        }
    });
}
