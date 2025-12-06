//
//  PurchaseManager.swift
//  OpenClip
//
//  Created by Kyle Johnson on 12/9/25.
//

import StoreKit

enum ProductID: String {
    case instagram
}

@MainActor
final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    @Published var isPurchased = false
    @Published var product: Product?
    
    private init() {
        Task {
            await loadProduct()
            await updateStatus()
            listenForTransactions()
        }
    }
    
    func loadProduct() async {
        do {
            product = try await Product.products(for: [ProductID.instagram.rawValue]).first
        } catch {
            print("Error loading product:", error)
        }
    }
    
    private func updateStatus() async {
        for await result in Transaction.currentEntitlements {
            if case .verified(let transaction) = result, transaction.productID == ProductID.instagram.rawValue {
                isPurchased = true
                return
            }
        }
        isPurchased = false
    }
    
    private func listenForTransactions() {
        Task {
            for await _ in Transaction.updates {
                await updateStatus()
            }
        }
    }
    
    func purchase() async throws {
        guard let product else { throw PurchaseError.productNotFound }
        
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            switch verification {
            case .verified(let transaction):
                if transaction.productID == ProductID.instagram.rawValue {
                    isPurchased = true
                }
                await transaction.finish()
            case .unverified(_, let error):
                throw error
            }
        case .userCancelled:
            throw PurchaseError.userCancelled
        case .pending:
            throw PurchaseError.pending
        @unknown default:
            throw PurchaseError.unknown
        }
    }
    
    func restorePurchases() async throws {
        try await AppStore.sync()
        await updateStatus()
    }
}

enum PurchaseError: LocalizedError {
    case productNotFound
    case unverifiedTransaction
    case userCancelled
    case pending
    case unknown
}
