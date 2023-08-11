//
//  DragGesture.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/11.
//

import SwiftUI

struct DragGestureBootcamp: View {
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 300, height: 500)
                .offset(offset)
                .scaleEffect(getScaleAmount())
                .rotationEffect(Angle(degrees: getRotationAmount()))
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            offset = value.translation
                        })
                        .onEnded({ _ in
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        })
            )
        }
    }
    
    func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percent = currentAmount / max
        return 1.0 - min(percent, 0.5) * 0.5
    }
    
    func getRotationAmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset.width
        let percent = currentAmount / max
        let maxAngle: Double = 10
        return Double(percent) * maxAngle
    }
}

struct DragGesture_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureBootcamp()
    }
}
