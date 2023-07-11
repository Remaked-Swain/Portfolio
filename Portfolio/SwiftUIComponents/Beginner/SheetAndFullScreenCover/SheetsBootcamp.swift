//
//  SheetsBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/07/11.
//

import SwiftUI

struct SheetsBootcamp: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            Button {
                showSheet.toggle()
            } label: {
                Text("Sheet 열기")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10, y: 10)
            }
            .sheet(isPresented: $showSheet) {
                SheetView(showSheet: $showSheet)
            }
        }
    }
}

struct SheetView: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            Button {
                showSheet.toggle()
            } label: {
                Text("Sheet 닫기")
                    .foregroundColor(.yellow)
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10, y: 10)
            }
        }
    }
}

struct SheetsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        SheetsBootcamp()
    }
}
