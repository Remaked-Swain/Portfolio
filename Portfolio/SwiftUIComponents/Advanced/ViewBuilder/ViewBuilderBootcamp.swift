//
//  ViewBuilderBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/29.
//

import SwiftUI

struct HeaderViewRegular: View {
    let title: String
    let description: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Description")
                .font(.callout)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewRegular()
            
            Spacer()
        }
    }
}

struct ViewBuilderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewBuilderBootcamp()
    }
}
