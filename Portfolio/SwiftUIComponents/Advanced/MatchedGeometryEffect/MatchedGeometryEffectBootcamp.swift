//
//  MatchedGeometryEffectBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/14.
//

import SwiftUI

struct MatchedGeometryEffectBootcamp: View {
    @State private var selectedCategory: String = "Home"
    @Namespace private var namespace
    
    private let categories: [String] = ["Home", "Popular", "Saved"]
    
    var body: some View {
        HStack {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    if selectedCategory == category {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.3))
                            .matchedGeometryEffect(id: "id", in: namespace)
                    }
                    
                    Text(category)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedCategory = category
                    }
                }
            }
        }
        .padding()
    }
}

struct MatchedGeometryEffectBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryEffectBootcamp()
    }
}
