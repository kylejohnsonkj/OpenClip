//
//  ContentView.swift
//  OpenClip
//
//  Created by Kyle Johnson on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var purchaseManager = PurchaseManager.shared
    @State private var selectedTab = Tab.tiktok
    
    enum Tab {
        case tiktok, instagram
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // TikTok tab
            ScrollView {
                HeaderView()
                HowToListView()
            }
            .gradientBackground()
            .tabItem {
                Image(systemName: "music.note")
                Text("TikTok")
            }
            .tag(Tab.tiktok)

            // Instagram tab
            ScrollView {
                HeaderView()
                PurchaseView()
            }
            .gradientBackground()
            .tabItem {
                Image(systemName: "camera.fill")
                Text("Instagram")
            }
            .tag(Tab.instagram)
        }
        .onOpenURL { url in
            switch url.host {
            case "instagram":
                selectedTab = .instagram
            default:
                break
            }
        }
    }
}

struct HeaderView: View {
    var body: some View {
        HStack(spacing: 0) {
            Image("AppIcon-Rounded")
                .resizable()
                .frame(width: 96, height: 96)
                .padding(.trailing)
            
            VStack(alignment: .leading) {
                Text("OpenClip")
                    .font(.title)
                    .bold()
                Text("A Safari extension that lets you watch social videos in your browser again")
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
    }
}

struct HowToListView: View {
    @ScaledMetric var buttonInset = 35
    @ScaledMetric var maxVideoWidth = 550 // for iPad
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("How to enable")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            ListEntry(
                Text("Open a shared TikTok video"),
                image: "1.circle"
            )
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            ListButton(
                text: "Try it now!",
                image: "music.note",
                link: "https://www.tiktok.com/t/ZP8fev6Gs/"
            )
            .tint(.pink)
            .padding(.leading, buttonInset)
            
            ListEntry(
                tapInstructionsText, // Tap the icon...
                image: "2.circle"
            )
            .padding(.vertical, 12)
            
            ListEntry(
                Text("Enable the OpenClip extension"),
                image: "3.circle"
            )
            .padding(.bottom, 12)
            
            ListEntry(
                Text("Tap OpenClip and select \"Always Allow\""),
                image: "4.circle"
            )
            
            Group {
                VideoExplainerSwiftUIView()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: maxVideoWidth)
                    .shadow(radius: 3)
                    .padding(.vertical)
                    .padding(.horizontal, 2)
            }
            .frame(maxWidth: .infinity)
            
            ListEntry(
                Text("Videos still not playing?"),
                image: "questionmark.circle"
            )
            .padding(.bottom, 8)
            
            ListButton(
                text: "Verify setup",
                image: "gear"
            )
            .tint(.buttonGray)
            .padding(.leading, buttonInset)
            .padding(.bottom)
            
            Text("TikTok® is a registered trademark of ByteDance Ltd. OpenClip is not affiliated with or endorsed by TikTok or ByteDance Ltd. This extension runs on [tiktok.com](https://www.tiktok.com).")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(.tableViewBackground)
    }
    
    var tapInstructionsText: Text {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if #available(iOS 18, *) {
                Text("Tap the \(Image("symbol")) icon on the left of the search bar")
            } else {
                Text("Tap the \(Image(systemName: "textformat.size")) icon on the left of the search bar")
            }
        } else {
            Text("Tap the \(Image(systemName: "puzzlepiece.extension")) icon on the right of the search bar")
        }
    }
}

extension View {
    func gradientBackground() -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: [.background, .background, .tableViewBackground, .tableViewBackground]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

#Preview {
    ContentView()
}
