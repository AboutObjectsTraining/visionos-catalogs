// Copyright (C) 2023 About Objects, Inc. All Rights Reserved.
// See LICENSE.txt for this project's licensing information.

import SwiftUI

struct TitledCell: View {
    let title: String
    @Binding var value: String
    
    @Environment(\.editMode) var editMode
    
    var isEditing: Bool {
        editMode?.wrappedValue.isEditing ?? false
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("\(title)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.bottom, isEditing ? -4 : 0)
                .padding(.top, 4)
            
            if isEditing {
                TextField(text: $value) { }
            } else {
                Text(value)
            }
        }
        .font(.headline)
    }
}

#if DEBUG
struct TitledCell_Previews: PreviewProvider {
    static var previews: some View {
        
        List {
            TitledCell(title: "Name", value: .constant("Fred Smith"))
            TitledCell(title: "Name", value: .constant("Fred Smith"))
                .environment(\.editMode, .constant(.active))
        }
        .listRowSeparatorTint(.primary)
        .previewLayout(.sizeThatFits)
    }
}
#endif
