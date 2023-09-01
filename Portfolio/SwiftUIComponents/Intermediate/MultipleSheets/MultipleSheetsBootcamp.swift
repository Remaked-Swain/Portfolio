//
//  MultipleSheetsBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/09/01.
//

import SwiftUI

struct RandomModel: Identifiable {
    let id = UUID().uuidString
    let title: String
}

struct MultipleSheetsBootcamp: View {
    @State private var selectedModel: RandomModel? = nil
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("버튼 #1") {
                selectedModel = RandomModel(title: "제목 #1")
                showSheet.toggle()
            }
            
            Button("버튼 #2") {
                selectedModel = RandomModel(title: "제목 #2")
                showSheet.toggle()
            }
        }
        .sheet(item: $selectedModel) { selectedModel in
            SheetScreen(selectedModel: selectedModel)
        }
    }
}

fileprivate struct SheetScreen: View {
    let selectedModel: RandomModel
    
    var body: some View {
        Text(selectedModel.title)
            .font(.largeTitle)
    }
}

struct MultipleSheetsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        MultipleSheetsBootcamp()
    }
}
