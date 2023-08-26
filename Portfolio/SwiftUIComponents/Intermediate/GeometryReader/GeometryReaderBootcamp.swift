//
//  GeometryReaderBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/26.
//

import SwiftUI

struct GeometryReaderBootcamp: View {
    var body: some View {
//        practice1
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<20) { index in
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: 20)
                            .rotation3DEffect(Angle(degrees: getPercentage(proxy: proxy) * 40), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(width: 300, height: 250)
                    .padding()
                }
            }
        }
    }
    
    private func getPercentage(proxy: GeometryProxy) -> CGFloat {
        let maxDistance = UIScreen.main.bounds.width / 2 // 화면 너비의 중앙
        let currentX = proxy.frame(in: .global).midX // proxy로 추적 중인 객체의 수평값의 중앙
        return 1 - (currentX / maxDistance)
    }
}

struct GeometryReaderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReaderBootcamp()
    }
}

extension GeometryReaderBootcamp {
    private var practice1: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Rectangle().fill(Color.red).frame(width: proxy.size.width * 2 / 3)
                Rectangle().fill(Color.blue)
            }
            .ignoresSafeArea()
        }
    }
}
