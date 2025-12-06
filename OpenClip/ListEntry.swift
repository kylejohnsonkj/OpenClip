//
//  ListEntry.swift
//  OpenClip
//
//  Created by Kyle Johnson on 12/6/25.
//

import SwiftUI

struct ListEntry: View {
    let text: Text
    let image: String
    
    init(_ text: Text, image: String) {
        self.text = text
        self.image = image
    }
    
    var body: some View {
        Label {
            text
                .font(.headline)
                .imageScale(.large)
        } icon: {
            Image(systemName: image)
                .imageScale(.large)
        }
    }
}
