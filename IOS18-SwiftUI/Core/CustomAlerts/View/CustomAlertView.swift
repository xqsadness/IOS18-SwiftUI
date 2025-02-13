//
//  CustomAlertView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/2/25.
//

import SwiftUI

struct CustomAlertView: View {
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            List {
                Button("Show Alert") {
                    showAlert.toggle()
                }
                .alert(isPresented: $showAlert) {
                    // YOUR ALERT CONTENT IN VIEW FORMAT
                    CustomDialog(
                        title: "Folder Name",
                        content: "Enter a file Name",
                        image: .init(content: "folder.fill.badge.plus", tint: .blue, foreground: .white),
                        button1: .init(content: "Save Folder", tint: .blue, foreground: .white, action: { folder in
                            print(folder)
                            showAlert = false
                        }),
                        button2: .init(content: "Cancel", tint: .red, foreground: .white, action: { _ in
                            showAlert = false
                        }),
                        addsTextField: true,
                        textFieldHint: "Personal Documents"
                    )
                    //Since it's using if condition to add view you can use swiftui transition here
                    .transition(.blurReplace.combined(with: .push(from: .bottom)))
                } background: {
                    // YOUR BACKGROUND CONTENT IN VIEW FORMAT
                    Rectangle()
                        .fill(.primary.opacity(0.35))
                }
            }
            .navigationTitle("Custom Alert")
        }
    }
}

#Preview{
    CustomAlertView()
}
