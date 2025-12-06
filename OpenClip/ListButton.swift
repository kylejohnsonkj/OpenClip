//
//  ListButton.swift
//  OpenClip
//
//  Created by Kyle Johnson on 9/21/24.
//

import SwiftUI

struct ListButton: View {
    let text: String
    let image: String
    let link: String?
    let isExtrasSetup: Bool
    
    init(text: String, image: String, link: String? = nil, isExtrasSetup: Bool = false) {
        self.text = text
        self.image = image
        self.link = link
        self.isExtrasSetup = isExtrasSetup
    }
    
    @State var isSheetPresented = false
    
    var buttonLabel: some View {
        HStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    var body: some View {
        Group {
            if let link {
                Link(destination: URL(string: link)!) {
                    buttonLabel
                }
            } else {
                Button {
                    isSheetPresented = true
                } label: {
                    buttonLabel
                }
                .sheet(isPresented: $isSheetPresented) {
                    VerifySetupListView(isExtrasSetup: isExtrasSetup)
                }
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    ContentView()
}
