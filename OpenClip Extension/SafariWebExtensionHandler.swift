//
//  SafariWebExtensionHandler.swift
//  OpenClip Extension
//
//  Created by Kyle Johnson on 9/13/24.
//

import StoreKit
import SafariServices

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    func beginRequest(with context: NSExtensionContext) {
        Task {
            let request = context.inputItems.first as? NSExtensionItem
            let requestMessage = request?.userInfo?[SFExtensionMessageKey] as? [String: Any]
            let action = requestMessage?["action"] as? String
            
            var responseMessage: [String: Any] = [:]
            
            if action == "checkInstagramPurchaseStatus" {
                let isPurchased = await checkInstagramPurchaseStatus()
                responseMessage["instagramPurchaseStatus"] = isPurchased
            }
            
            let response = NSExtensionItem()
            response.userInfo = [SFExtensionMessageKey: responseMessage]
            context.completeRequest(returningItems: [response], completionHandler: nil)
        }
    }
    
    func checkInstagramPurchaseStatus() async -> Bool {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == ProductID.instagram.rawValue {
                return true
            }
        }
        return false
    }
}
