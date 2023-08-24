//
//  MagnificationGestureBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/24.
//

import SwiftUI

struct MagnificationGestureBootcamp: View {
    @State private var currentAmount: CGFloat = 0
    @State private var lastAmount: CGFloat = 0
    
    var body: some View {
//        practice1
        
        VStack {
            HStack {
                Circle().frame(width: 35, height: 35)
                Text("Swain Yun")
                Spacer()
                Image(systemName: "ellipsis")
            }
            
            Rectangle().frame(height: 300)
                .scaleEffect(1 + currentAmount)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentAmount = value - 1
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                currentAmount = 0
                            }
                        }
                )
            
            HStack {
                Image(systemName: "heart.fill")
                Image(systemName: "text.bubble.fill")
                Spacer()
            }
            .font(.headline)
            
            Text("This looks like Instagram feed!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
        }
        .padding()
    }
}

struct MagnificationGestureBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MagnificationGestureBootcamp()
    }
}

extension MagnificationGestureBootcamp {
    private var practice1: some View {
        Text("Hello, World!")
            .font(.title)
            .padding(40)
            .background(Color.green.opacity(0.3).cornerRadius(14))
            .scaleEffect(1 + currentAmount + lastAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentAmount = value - 1
                    }
                    .onEnded { value in
                        lastAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}
