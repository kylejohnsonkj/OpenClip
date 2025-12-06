makeInstagramLogoTappable();
showThumbnailAlert();

const observer = new MutationObserver(() => {
    hideChannelFooter();
    attachInstagramTabs();
});

// Observe the whole document
observer.observe(document, { childList: true, subtree: true });

function makeInstagramLogoTappable() {
    document.addEventListener('click', (e) => {
        const target = e.target.closest('svg[aria-label="Instagram"]');
        if (target) {
            e.preventDefault();
            e.stopPropagation();
            e.stopImmediatePropagation();
            
            const url = 'https://' + window.location.host;
            window.location.href = url;
        }
    });
}

function showThumbnailAlert() {
    const selector = `
      header:has(~ :last-child)
      ~ :last-child
      header ~ :last-child
    `;
    
    document.addEventListener("click", e => {
        const target = e.target.closest(selector);
        if (!target) return;
        
        e.preventDefault();
        e.stopPropagation();
        e.stopImmediatePropagation();
        
        alert("Unfortunately, Instagram makes it impossible to navigate to the posts behind these thumbnails without an account.");
    });
}

function hideChannelFooter() {
    const footer = Array.from(document.querySelectorAll('div.html-div')).find(
        d => getComputedStyle(d).paddingTop === '100px'
    );
    if (footer) {
        footer.style.display = 'none';
    }
}

function attachInstagramTabs() {
    const username = window.location.pathname.split('/')[1];
    if (!username) return;
    
    const tabMap = {
      'Posts': `/${username}/`,
      'Feed': `/${username}/feed/`,
      'Reels': `/${username}/reels/`,
      'Saved': `/${username}/saved/`,
      'Tagged': `/${username}/tagged/`
    };
    
    document.querySelectorAll('div[role="tablist"] > div').forEach(tabDiv => {
        if (tabDiv.dataset.handlerAttached) return;
        
        const titleEl = tabDiv.querySelector('title');
        if (!titleEl) return;
        
        const tabName = titleEl.textContent.trim();
        if (!tabMap[tabName]) return;
        
        tabDiv.dataset.handlerAttached = 'true';
        
        tabDiv.addEventListener('click', e => {
          e.preventDefault();
          e.stopPropagation();
          window.location.href = tabMap[tabName];
        }, true);
    });
}
