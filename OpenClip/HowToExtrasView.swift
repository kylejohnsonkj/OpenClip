//
//  HowToExtrasView.swift
//  OpenClip
//
//  Created by Kyle Johnson on 12/9/25.
//

import SwiftUI

struct HowToExtrasView: View {
    @ScaledMetric var buttonInset = 35
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("How to enable")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            
            ListEntry(
                Text("Open a shared Instagram video"),
                image: "1.circle"
            )
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            ListButton(
                text: "Try it now!",
                image: "camera.fill",
                link: "https://www.instagram.com/reel/DLXrFTyMz6m/?igsh=MXNlcTBkM2Z6NWQw"
            )
            .tint(.pink)
            .padding(.leading, buttonInset)
            
            ListEntry(
                tapInstructionsText, // Tap the icon...
                image: "2.circle"
            )
            .padding(.vertical, 12)
            
            ListEntry(
                Text("Tap OpenClip and select \"Always Allow\""),
                image: "3.circle"
            )
            
            ListEntry(
                Text("Log out of Instagram for the best viewing experience"),
                image: "4.circle"
            )
            .padding(.vertical, 12)
            
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
            .padding(.top, 4)
            .padding(.bottom, 16)
            
            ListEntry(
                Text("Videos still not playing?"),
                image: "questionmark.circle"
            )
            .padding(.bottom, 8)
            
            ListButton(
                text: "Verify setup",
                image: "gear",
                isExtrasSetup: true
            )
            .tint(.buttonGray)
            .padding(.leading, buttonInset)
            .padding(.bottom)
        }
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
