//
//  ToastView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/12/24.
//

import SwiftUI

struct ToastView: View {
    @State private var toastManager = ToastManager.shared

    var body: some View {
        NavigationStack {
            List {
                Text("Dummy List RDummyow View")
            }
            .navigationTitle("Toasts")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Show", action: showToast)
                }
            }
        }
        .interactiveToasts($toastManager.toasts)
    }
    
    func showToast() {
        ToastManager.shared.show("Hello World!")
    }
}

#Preview {
    ToastView()
}

@Observable
class ToastManager {
    static let shared = ToastManager()
    private init() {}
    
    var toasts: [Toast] = []
    
    func show(_ message: String) {
        withAnimation(.bouncy) {
            let toast = Toast { id in
                self.ToastView(id)
            }
            
            toasts.append(toast)
        }
    }
    
    func dismiss(_ id: String) {
        toasts.removeAll(where: { $0.id == id })
    }
    
    /// YOUR CUSTOM TOAST VIEW
    @ViewBuilder
    private func ToastView(_ id: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "square.and.arrow.up.fill")

            Text("Hello World!")
                .font(.callout)

//            Spacer(minLength: 0)
//
//            Button {
//                $toasts.delete(id)
//            } label: {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.title2)
//            }
        }
        .foregroundStyle(Color.primary)
        .padding(.vertical, 12)
        .padding(.horizontal, 15)
//        .padding(.trailing, 10)
        .background {
            Capsule()
                .fill(.background)
                /// Shadows
                .shadow(color: .black.opacity(0.06), radius: 3, x: -1, y: -3)
                .shadow(color: .black.opacity(0.06), radius: 2, x: 1, y: 3)
        }
//        .padding(.horizontal, 15)
    }
}
