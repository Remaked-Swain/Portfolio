//
//  ScrollViewReaderBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/25.
//

import SwiftUI

struct ScrollViewReaderBootcamp: View {
    @State private var text: String = ""
    @State private var scrollToIndex: Int = 0
    
    var body: some View {
        VStack {
            TextField("숫자를 입력하세요.", text: $text)
                .frame(height: 55)
                .border(Color.gray)
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            Button("Scroll") {
                if let index = Int(text) {
                    scrollToIndex = index
                }
            }
            
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach(0..<50) { index in
                        Text("This is item #\(index)")
                            .font(.headline)
                            .frame(height: 100)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(14)
                            .shadow(radius: 10)
                            .padding()
                            .id(index)
                    }
                    .onChange(of: scrollToIndex) { newValue in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newValue, anchor: nil)
                        }
                    }
                }
            }
        }
    }
}

struct ScrollViewReaderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewReaderBootcamp()
    }
}
