//
//  HomeControlSlider.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 11/4/25.
//

import SwiftUI

struct HomeControlSlider: View {
    var body: some View {
        VStack{
            Spacer()
            
            let config = SlideToConfirm.Config(
                idleText: "Swipe to pay",
                onSwipeText: "Confirm Payment",
                confirmationText: "Success!",
                tint: .green,
                foregorundColor: .white
            )
            
            SlideToConfirm(config: config) {
                print("Swiped")
            }
        }
        .padding(15)
    }
}

#Preview {
    HomeControlSlider()
}
