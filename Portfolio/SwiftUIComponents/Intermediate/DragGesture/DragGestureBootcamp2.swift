//
//  DragGestureBootcamp2.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/11.
//

import SwiftUI

struct DragGestureBootcamp2: View {
    @State private var startOffsetY: CGFloat = UIScreen.main.bounds.height * 0.83
    @State private var endOffsetY: CGFloat = .zero
    @State private var currentDragOffsetY: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.3).ignoresSafeArea()
            
            SignUpView()
                .offset(y: startOffsetY)
                .offset(y: currentDragOffsetY)
                .offset(y: endOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation(.spring()) {
                                currentDragOffsetY = value.translation.height
                            }
                        })
                        .onEnded({ value in
                            withAnimation(.spring()) {
                                if currentDragOffsetY < -150 {
                                    endOffsetY = -startOffsetY
                                } else if endOffsetY != 0 && currentDragOffsetY > 150 {
                                    endOffsetY = .zero
                                }
                                
                                currentDragOffsetY = .zero
                            }
                        })
                )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct DragGestureBootcamp2_Previews: PreviewProvider {
    static var previews: some View {
        DragGestureBootcamp2()
    }
}

struct SignUpView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chevron.up")
                .imageScale(.large)
                .padding(.top)
            
            Text("가입하기")
                .font(.headline).fontWeight(.semibold)
            
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("드래그 제스처를 통해 ZStack 내에서 겹쳐져 있던 뷰를 끌어당겨오는 듯한 효과를 줄 수 있습니다.\n이 뷰는 회원가입을 위한 계정 생성 단계를 시트처럼 표현한 예제입니다.")
                .multilineTextAlignment(.center)
            
            Text("계정 생성하기!")
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .padding(.horizontal)
                .background(Color.black.cornerRadius(25))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
    }
}
