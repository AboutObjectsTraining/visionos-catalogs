//
//  Created 1/28/25 by Jonathan Lehr
//  Copyright © 2025 About Objects.
//  

import SwiftUI

struct EmptyContentMessage: View {
    let itemName: String
    
    var body: some View {
        VStack {
            Text("No \(itemName.capitalized)s")
                .font(.headline)
                .padding(.bottom, 12)
            Text("Tap the + button to add a \(itemName).")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    EmptyContentMessage(itemName: "item")
}
