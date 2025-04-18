//
//  SlideToConfirm.swift
//  IOS18-SwiftUI
//
//  Created by xqsadness on 11/4/25.
//

import SwiftUI

struct SlideToConfirm: View {
    var config: Config
    var onSwiped: () -> ()
    //View props
    @State private var animatedText: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var isCompleted: Bool = false
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            let knobSize = size.height
            let maxLimit = size.width - knobSize
            let progress: CGFloat = isCompleted ? 1 : offsetX / maxLimit
            
            ZStack(alignment: .leading){
                Capsule()
                    .fill(
                        .gray.opacity(0.25)
                        .shadow(.inner(color: .black.opacity(0.2), radius: 10))
                    )
                
                //Tint capsule
                let extraCapsuleWidth = (size.width - knobSize) * progress
                Capsule()
                    .fill(config.tint.gradient)
                    .frame(width: knobSize + extraCapsuleWidth, height: knobSize)
                
                LeadingTextView(size, progress: progress)
                
                HStack(spacing: 0){
                    KnobView(size, progress: progress, maxLimit: maxLimit)
                        .zIndex(1)
                    
                    ShimmerTextView(size, progress: progress)
                }
            }
        }
        .frame(height: isCompleted ? 50 : config.height)
        .containerRelativeFrame(.horizontal){ value, _ in
            //Modify this as your needs
            let ratio: CGFloat = isCompleted ? 0.5 : 0.8
            return value * ratio
        }
        .frame(maxWidth: 300)
        .allowsHitTesting(!isCompleted)
    }
    
    //knob view
    func KnobView(_ size: CGSize, progress: CGFloat, maxLimit: CGFloat) -> some View{
        Circle()
            .fill(.background)
            .padding(6)
            .frame(width: size.height, height: size.height)
            .overlay {
                ZStack{
                    Image(systemName: "chevron.right")
                        .opacity(1 - progress)
                        .blur(radius: progress * 10)
                    
                    Image(systemName: "checkmark")
                        .opacity(progress)
                        .blur(radius: (1 - progress) * 10)
                }
                .font(.title3.bold())
            }
            .contentShape(.circle)
            .scaleEffect(isCompleted ? 0.6 : 1, anchor: .center)
            .offset(x: isCompleted ? maxLimit : offsetX)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offsetX = min(max(value.translation.width, 0), maxLimit)
                    }).onEnded({ value in
                        if offsetX == maxLimit{
                            onSwiped()
                            //Stopping shimmer text
                            animatedText = false
                            
                            withAnimation(.bouncy){
                                isCompleted = true
                            }
                        }else{
                            withAnimation(.smooth){
                                offsetX = 0
                            }
                        }
                    })
            )
    }
    
    //Shimmer text view
    func ShimmerTextView(_ size: CGSize, progress: CGFloat) -> some View{
        Text(isCompleted ? config.confirmationText : config.idleText)
            .foregroundStyle(.gray.opacity(0.6))
            .overlay{
                //Shimmer effect
                Rectangle()
                    .frame(height: 15)
                    .rotationEffect(.init(degrees: 90))
                    .visualEffect { [animatedText] content, proxy in
                        content
                            .offset(x: -proxy.size.width / 1.8)
                            .offset(x: animatedText ? proxy.size.width * 1.2 : 0)
                    }
                    .mask(alignment: .leading){
                        Text(config.idleText)
                    }
                    .blendMode(.softLight)
            }
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity)
            .padding(.trailing, size.height / 2)
            .mask{
                Rectangle()
                    .scale(x: 1 - progress, anchor: .trailing)
            }
            .frame(height: size.height)
            .task {
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)){
                    animatedText = true
                }
            }
    }
    
    //On swipe confimation text view
    func LeadingTextView(_ size: CGSize, progress: CGFloat) -> some View{
        ZStack{
            Text(config.onSwipeText)
                .opacity(isCompleted ? 0 : 1)
                .blur(radius: isCompleted ? 10 : 0)
            
            Text(config.confirmationText)
                .opacity(!isCompleted ? 0 : 1)
                .blur(radius: !isCompleted ? 10 : 0)
        }
        .fontWeight(.semibold)
        .foregroundStyle(config.foregorundColor)
        .frame(maxWidth: .infinity)
        // To make it center
        .padding(.trailing, (size.height * (isCompleted ? 0.6 : 1)) / 2)
        .mask {
            Rectangle()
                .scale(x: progress, anchor: .leading)
        }
    }
    
    struct Config{
        var idleText: String
        var onSwipeText: String
        var confirmationText: String
        var tint: Color
        var foregorundColor: Color
        var height: CGFloat = 70
    }
}

#Preview {
    HomeControlSlider()
}
