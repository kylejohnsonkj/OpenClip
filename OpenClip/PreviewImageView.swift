//
//  OpenClipApp.swift
//  OpenClip
//
//  Created by Kyle Johnson on 12/6/25.
//

import SwiftUI

struct PreviewPhase: Identifiable {
    let id = UUID()
    let image: Image
    let label: String?
}

struct PreviewImageView: View {
    let phases: [PreviewPhase]
    
    @State private var index = 0
    @State private var lastInteraction = Date.distantPast
    
    private let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 0) {
            if let label = phases[index].label {
                Text(label)
                    .font(.callout)
                    .bold()
                    .foregroundColor(.white)
                    .frame(height: 30)
            }
            
            ZStack {
                ForEach(phases.indices, id: \.self) { i in
                    phases[i].image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(index == i ? 1 : 0)
                }
            }
            .cornerRadius(10)
            .clipped()
        }
        .background(phases[index].label == "Before" ? Color.blue : Color.pink)
        .animation(.easeInOut(duration: 0.6), value: index)
        .cornerRadius(10)
        .clipped()
        .onReceive(timer) { _ in
            guard phases.count > 1 else { return }
            
            lastInteraction = Date()
            index = (index + 1) % phases.count
        }
    }
}
