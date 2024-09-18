//
//  View+Extension.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 18/9/24.
//

import SwiftUI


extension View{
    @ViewBuilder
    func hideTabbar() -> some View{
        self
            .toolbarVisibility(.hidden, for: .tabBar)
    }
    
    @ViewBuilder
    func loopingWiggle(_ isEnabled: Bool = false) -> some View{
        self
            .symbolEffect(.wiggle.byLayer.counterClockwise, isActive: isEnabled)
    }
}
