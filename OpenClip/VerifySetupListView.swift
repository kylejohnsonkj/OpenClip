//
//  VerifySetupListView.swift
//  OpenClip
//
//  Created by Kyle Johnson on 9/21/24.
//

import SwiftUI

struct VerifySetupListView: View {
    let isExtrasSetup: Bool
    
    init(isExtrasSetup: Bool = false) {
        self.isExtrasSetup = isExtrasSetup
    }
    
    var body: some View {
        List {
            Section {
                ColoredListEntry(
                    Text("Open the **Settings** app"),
                    image: "gear",
                    color: .gray
                )
                if #available(iOS 18, *) {
                    ColoredListEntry(
                        Text("Select **Apps**"),
                        image: "square.grid.3x3",
                        color: .purple
                    )
                }
                ColoredListEntry(
                    Text("Select **Safari**"),
                    image: "safari",
                    color: .blue
                )
                ColoredListEntry(
                    Text("Select **Extensions**"),
                    image: "puzzlepiece.extension",
                    color: .teal
                )
                ColoredListEntry(
                    Text("Select **OpenClip**"),
                    image: "bolt.horizontal",
                    color: .pink
                )
                ColoredListEntry(
                    Text("Turn **Allow Extension** On"),
                    image: "switch.2",
                    color: .green
                )
                if !isExtrasSetup {
                    ColoredListEntry(
                        Text("Set **tiktok.com** to Allow"),
                        image: "checkmark.circle",
                        color: .orange
                    )
                } else {
                    ColoredListEntry(
                        Text("Set **instagram.com** to Allow"),
                        image: "checkmark.circle",
                        color: .orange
                    )
//                    ColoredListEntry(
//                        Text("Set **facebook.com** to Allow"),
//                        image: "checkmark.circle",
//                        color: .orange
//                    )
                }
                
            } header: {
                Text("\nVerify setup")
            } footer: {
                Text("Looking for help? [kylejohnsonapps.com/contact](https://kylejohnsonapps.com/contact)")
                    .tint(.blue)
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
    
    struct ColoredListEntry: View {
        let text: Text
        let image: String
        let color: Color
        
        init(_ text: Text, image: String, color: Color) {
            self.text = text
            self.image = image
            self.color = color
        }
        
        var body: some View {
            Label {
                text
            } icon: {
                Image(systemName: image)
                    .foregroundStyle(color)
            }
        }
    }
}

#Preview {
    VerifySetupListView()
}
