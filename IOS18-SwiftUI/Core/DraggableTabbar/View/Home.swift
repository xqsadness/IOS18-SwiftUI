//
//  Home.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/9/24.
//

import SwiftUI

struct Home: View {
    @Environment(TabProperties.self) private var properties
    var body: some View {
        @Bindable var binding = properties
        NavigationStack{
            List{
                Toggle("Edit tab locatiob", isOn: $binding.editMode)
            }
            .navigationTitle("Home")
        }
    }
}

#Preview {
    DraggableTabbarView()
}
