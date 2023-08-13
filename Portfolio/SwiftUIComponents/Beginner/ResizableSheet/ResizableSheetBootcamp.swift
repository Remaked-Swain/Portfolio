//
//  ResizableSheetBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/13.
//

import SwiftUI

struct ResizableSheetBootcamp: View {
    @State private var showSheet: Bool = false
    @State private var detents: PresentationDetent = .large
    
    let selectableDetents: Set<PresentationDetent> = [.large, .medium, .fraction(0.1)]
    
    var body: some View {
        Button("Click here!") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            SheetView(detents: $detents, selectableDetents: selectableDetents)
                .presentationDetents(selectableDetents, selection: $detents)
//                .presentationDragIndicator(.hidden) // 시트의 드래그 인디케이터를 숨김
//                .interactiveDismissDisabled() // 시트를 화면 하단 끝까지 내려서 시트를 닫는 대화형 해제 장치를 비활성화
        }
    }
}

fileprivate struct SheetView: View {
    @Binding var detents: PresentationDetent
    
    let selectableDetents: Set<PresentationDetent>
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Button("Large state") {
                    detents = .large
                }
                
                Button("Medium state") {
                    detents = .medium
                }
                
                Button("Fraction 0.1 state") {
                    detents = .fraction(0.1)
                }
            }
        }
    }
}

struct ResizableSheetBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ResizableSheetBootcamp()
    }
}
