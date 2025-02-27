//
//  TransparentBlurView.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 27/2/25.
//

import SwiftUI

struct TransparentBlurView: UIViewRepresentable {
    func makeUIView(context: Context) -> CustomBlurView {
        return CustomBlurView(effect: .init(style: .systemUltraThinMaterial))
    }
    
    func updateUIView(_ uiView: CustomBlurView, context: Context) {
        
    }
}

 class CustomBlurView: UIVisualEffectView {
     init(effect: UIBlurEffect?) {
        super.init(effect: effect)
        
        setup()
    }
    
    func setup() {
        removeAllFilters()
        
        /// Registering Trait Changes
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (self: Self, _) in
            DispatchQueue.main.async {
                self.removeAllFilters()
            }
        }
    }
    
    func removeAllFilters() {
        if let filterLayer = layer.sublayers?.first {
            filterLayer.filters = []
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
