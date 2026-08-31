//
//  NonPurchasedView.swift
//  OpenClip
//
//  Created by Kyle Johnson on 12/19/25.
//

import StoreKit
import SwiftUI

struct NonPurchasedView: View {
    let product: Product?
    
    @Binding var isPurchasing: Bool
    @Binding var showError: Bool
    @Binding var showInterruptedAlert: Bool
    @Binding var showAskToBuyAlert: Bool
    @State var isSheetPresented = false
    @State var sheetHeight: CGFloat = .zero
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Extras")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            HStack(alignment: .center, spacing: 8) {
                Image(systemName: "camera")
                    .font(.title3)
                    .frame(width: 32, height: 32)
                
                Text("Instagram Reels Support")
                    .font(.headline)
                
                Text("NEW")
                    .font(.caption2)
                    .bold()
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.pink)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("You can now bring the OpenClip experience to **Instagram Reels**! Watch freely without creating an account.")
                    
                Text("""
                    • Bypass "Watch in the app" screen
                    • Avoid App Store redirects
                    • Hide distracting UI elements
                    • Expand video descriptions
                    • Convenient "Watch again" button
                    • Share sheet functionality, and more!
                    """)
                .padding(.leading)
                
                Button {
                    isSheetPresented = true
                } label: {
                    HStack {
                        Image(systemName: "arrow.up.forward.app")
                            .imageScale(.medium)
                            .bold()
                        Text("**A message from the developer**")
                    }
                }
                .foregroundStyle(.blue)
                .padding(.top, 4)
                .sheet(isPresented: $isSheetPresented) {
                    NavigationStack {
                        Text("""
                            Thank you for considering supporting OpenClip. This project has grown from a simple extension I made to watch my wife's TikToks, to an app that resonates with users across 85+ countries! ❤️
                            
                            Many have asked for a way to tip, but I wanted to offer something in return. Support for Instagram Reels has been a highly requested feature that I'm excited to release at last.
                            
                            **This is a one-time purchase.** Maintaining OpenClip requires frequent updates as social platforms often change and run UI experiments that break functionality. Your support helps me dedicate the time to both maintaining this extension and developing new features.
                            
                            If you are unable to purchase, no worries! TikTok support will always remain free and [leaving a review](https://itunes.apple.com/app/id6708240044?action=write-review) goes a long way too. 🙂
                            
                            Happy watching!
                            Kyle
                            
                            """)
                        .font(.callout)
                        .foregroundStyle(.primary)
                        .padding(.horizontal)
                        .navigationTitle("From the developer")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button {
                                    isSheetPresented = false
                                } label: {
                                    Image(systemName: "xmark")
                                }
                            }
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .onGeometryChange(for: CGFloat.self) { proxy in
                            proxy.size.height
                        } action: { newValue in
                            sheetHeight = newValue + 75
                        }
                        .presentationDetents([.height(sheetHeight)])
                    }
                    .background(Color.background)
                }
            }
            .font(.callout)
            .foregroundStyle(.secondary)
            
            HStack(spacing: 12) {
                PreviewImageView(
                    phases: [
                        PreviewPhase(image: Image("insta-before1"), label: "Before"),
                        PreviewPhase(image: Image("insta-before2"), label: "Before"),
                        PreviewPhase(image: Image("insta-before3"), label: "Before"),
                        PreviewPhase(image: Image("insta-before4"), label: "Before")
                    ]
                )
                .frame(width: UIScreen.main.bounds.width * 0.4)
                
                PreviewImageView(
                    phases: [
                        PreviewPhase(image: Image("insta-after1"), label: "After"),
                        PreviewPhase(image: Image("insta-after2"), label: "After"),
                        PreviewPhase(image: Image("insta-after3"), label: "After"),
                        PreviewPhase(image: Image("insta-after4"), label: "After")
                    ]
                )
                .frame(width: UIScreen.main.bounds.width * 0.4)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 8)
            
            Text("**Note:** These enhancements only apply when logged out")
                .padding(.bottom, 8)
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            
            if let product = product {
                HStack {
                    PurchaseButtons(
                        product: product,
                        isPurchasing: $isPurchasing,
                        showError: $showError,
                        showInterruptedAlert: $showInterruptedAlert,
                        showAskToBuyAlert: $showAskToBuyAlert
                    )
                    .frame(width: UIScreen.main.bounds.width * 0.8 + 12)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            } else {
                if isPurchasing {
                    ProgressView().padding()
                } else {
                    Group {
                        Button {
                        } label: {
                            HStack {
                                Image(systemName: "lock.fill")
                                Text("Unable to load product")
                            }
                            .font(.headline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.9)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(12)
                        }
                        .disabled(true)
                        .frame(width: UIScreen.main.bounds.width * 0.8 + 12)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            
            InstagramFooter()
                .padding(.top, 6)
        }
        .padding()
    }
}

// MARK: - Purchase Buttons
struct PurchaseButtons: View {
    let product: Product
    @Binding var isPurchasing: Bool
    @Binding var showError: Bool
    @Binding var showInterruptedAlert: Bool
    @Binding var showAskToBuyAlert: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Button {
                Task { await handlePurchase() }
            } label: {
                HStack {
                    Image(systemName: "lock.fill")
                    Text("\(product.displayName) • \(product.displayPrice)")
                }
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.pink)
                .cornerRadius(12)
            }
            .disabled(isPurchasing)
            
            Button {
                Task { await handleRestore() }
            } label: {
                Text("Restore Purchases")
                    .font(.subheadline)
                    .foregroundStyle(.pink)
            }
            .disabled(isPurchasing)
        }
    }
    
    private func handlePurchase() async {
        isPurchasing = true
        do {
            try await PurchaseManager.shared.purchase()
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        } catch PurchaseError.pending {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            showAskToBuyAlert = true
        } catch PurchaseError.userCancelled {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            showInterruptedAlert = true
        } catch {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
            showError = true
        }
        isPurchasing = false
    }
    
    private func handleRestore() async {
        do {
            try await PurchaseManager.shared.restorePurchases()
            if PurchaseManager.shared.isPurchased {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            }
        } catch {
            showError = true
        }
    }
}
