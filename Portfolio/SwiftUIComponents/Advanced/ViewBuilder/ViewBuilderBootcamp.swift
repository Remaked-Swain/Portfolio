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
    let iconName: String?
    // let iconName2: String?
    // let iconName3: String?
    // ...
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            if let description = description {
                Text(description)
                    .font(.callout)
            }
            
            if let iconName = iconName {
                Image(systemName: iconName)
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct HeaderViewGeneric<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
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
            HeaderViewRegular(title: "Title", description: "Description", iconName: "heart.fill")
            HeaderViewRegular(title: "Title", description: nil, iconName: nil)
            HeaderViewGeneric(title: "Title") {
                Text("Description")
            }
            HeaderViewGeneric(title: "Title") {
                VStack {
                    Text("Description")
                    Image(systemName: "bolt.fill")
                }
            }
            
            Spacer()
        }
    }
}

struct ViewBuilderBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ConditionalView(type: .titleOnly)
        ConditionalView(type: .withDescription)
        ConditionalView(type: .withImage)
    }
}

struct ConditionalView: View {
    @frozen enum ViewType {
        case titleOnly, withDescription, withImage
    }
    
    let type: ViewType
    
    var body: some View {
        content
    }
    
    @ViewBuilder private var content: some View {
        switch type {
        case .titleOnly: titleOnly
        case .withDescription: withDescription
        case .withImage: withImage
        }
    }
    
    private var titleOnly: some View {
        Text("Title")
    }
    
    private var withDescription: some View {
        VStack {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Description")
                .font(.callout)
        }
    }
    
    private var withImage: some View {
        VStack {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Image(systemName: "heart.fill")
        }
    }
}
