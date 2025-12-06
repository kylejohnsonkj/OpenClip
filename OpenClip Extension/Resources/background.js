chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    if (request.type === 'checkInstagramPurchaseStatus') {
        chrome.runtime.sendNativeMessage('com.kylejohnson.OpenTok', {
            action: 'checkInstagramPurchaseStatus'
        }, response => sendResponse({
            instagramPurchaseStatus: Boolean(response?.instagramPurchaseStatus)
        }));
        return true;
    }
});
