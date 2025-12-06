//
//  PurchaseView.swift
//  OpenClip
//
//  Created by Kyle Johnson on 12/6/25.
//

import SwiftUI

struct PurchaseView: View {
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var isPurchasing = false
    
    @State private var showError: Bool = false
    @State private var showInterruptedAlert: Bool = false
    @State private var showAskToBuyAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if purchaseManager.isPurchased {
                PurchasedView()
            } else {
                NonPurchasedView(
                    product: purchaseManager.product,
                    isPurchasing: $isPurchasing,
                    showError: $showError,
                    showInterruptedAlert: $showInterruptedAlert,
                    showAskToBuyAlert: $showAskToBuyAlert
                )
            }
        }
        .background(.tableViewBackground)
        .onAppear {
            Task {
                await purchaseManager.loadProduct()
            }
        }
        .alert("Purchase Failed", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Unable to complete the purchase. Please try again later.")
        }
        .alert("Purchase Interrupted", isPresented: $showInterruptedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please try again later.")
        }
        .alert("Approval Pending", isPresented: $showAskToBuyAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your purchase request was sent for approval.")
        }
    }
}

struct PurchasedView: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
                Text("Instagram Reels Unlocked!")
                    .font(.headline)
                    .foregroundStyle(.blue)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.metaBlue)
            .cornerRadius(12)
            
            HowToExtrasView()
                .padding(.top)
            
            InstagramFooter()
        }
        .padding()
    }
}

struct InstagramFooter: View {
    var body: some View {
        Text("Instagram® is a registered trademark of Meta Platforms, Inc. OpenClip is not affiliated with or endorsed by Instagram or Meta Platforms, Inc. This extension runs on [instagram.com](https://www.instagram.com).")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
    }
}
