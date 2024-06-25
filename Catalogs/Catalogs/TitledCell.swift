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
        Group {
            if isEditing {
                EditableField(title: title, value: $value)
            } else {
                StaticField(title: title, value: value)
            }
        }
        .font(.headline)
    }
    
    struct TitleView: View {
        let title: String
        
        var body: some View {
            Text("\(title)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
    
    struct StaticField: View {
        let title: String
        let value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 3) {
                TitleView(title: title)
                    .padding(.bottom, 0)
                Text("\(value)")
            }
        }
    }
    
    struct EditableField: View {
        let title: String
        @Binding var value: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 3) {
                TitleView(title: title)
                    .padding(.bottom, -4)
                    .padding(.top, 4)
                TextField(title, text: $value)
            }
        }
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
