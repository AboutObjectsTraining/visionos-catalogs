//
//  Created 6/26/24 by Jonathan Lehr
//  Copyright © 2024 About Objects.
//  

import SwiftUI

struct SettingsBrowser: View {
    @AppStorage("shouldShowBooks") private var shouldShowBooks = true

    var body: some View {
        Form {
            Toggle(isOn: $shouldShowBooks) {
                Label("Show Books", systemImage: "books")
            }
        }
    }
}
