// Copyright (C) 2023 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct CompletionProgressViewStyle: ProgressViewStyle {
        
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            if (configuration.percentComplete < 1) {
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.percentComplete))
                    .stroke(configuration.color, style: configuration.strokeStyle)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 60)
                    .background(
                        Circle()
                            .stroke(configuration.color.opacity(0.3), style: configuration.strokeStyle)
                            .rotationEffect(.degrees(-90))
                    )
                Text(configuration.percentComplete, format: .percent)
                    .font(.caption)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .imageScale(.large)
                    .font(.system(size: 48).weight(.medium))
                    .opacity(0.5)
                    .padding(.horizontal, -6)
            }
        }
        .foregroundColor(configuration.color)
    }
}

extension ProgressViewStyleConfiguration {
    
    var strokeStyle: StrokeStyle {
        StrokeStyle(lineWidth: 8)
    }
    
    var percentComplete: Double {
        fractionCompleted ?? 0
    }
    
    var color: Color {
        percentComplete < 0.1 ? .secondary :
        percentComplete < 0.4 ? .red :
        percentComplete < 0.7 ? .orange : .green
    }
}

#Preview {
    Form {
        ProgressView("", value: 0.0)
            .progressViewStyle(CompletionProgressViewStyle())
        ProgressView("", value: 0.3)
            .progressViewStyle(CompletionProgressViewStyle())
        ProgressView("", value: 0.5)
            .progressViewStyle(CompletionProgressViewStyle())
        ProgressView("", value: 0.7)
            .progressViewStyle(CompletionProgressViewStyle())
        ProgressView("", value: 0.9)
            .progressViewStyle(CompletionProgressViewStyle())
        ProgressView("", value: 1.0)
            .progressViewStyle(CompletionProgressViewStyle())
    }
    .preferredColorScheme(.dark)
}
