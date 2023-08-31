//
//  PreferenceKeyBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/31.
//

import SwiftUI

struct CustomTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

struct PreferenceKeyBootcamp: View {
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen()
            }
            .navigationTitle(text) // 상위 뷰에 붙어있는 타이틀
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.text = value
        }
    }
}

fileprivate struct SecondaryScreen: View {
    @State private var navigationTitle: String = ""
    
    var body: some View {
        Button {
            navigationTitle = "Title Changed!"
        } label: {
            Text("Click here to change Title")
        }
        .preference(key: CustomTitlePreferenceKey.self, value: navigationTitle)
    }
}

struct PreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PreferenceKeyBootcamp()
    }
}
