//
//  DoCatchThrowsBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/17.
//

import SwiftUI

fileprivate class DataManager {
    let isActive: Bool = false
    
    func getTitle() throws -> String {
        guard isActive else { throw URLError(.badURL) }
        return "New Text!"
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {
    @Published var text: String = "Starting Text."
    
    private let manager = DataManager()
    
    func fetchTitle() {
        let title = try? manager.getTitle()
        self.text = title ?? "Default Text..."
    }
}

struct DoTryCatchThrowsBootcamp: View {
    @StateObject private var vm = DoTryCatchThrowsViewModel()
    
    var body: some View {
        Text(vm.text)
            .frame(width: 300, height: 300)
            .background(Color.cyan)
            .onTapGesture {
                vm.fetchTitle()
            }
    }
}

struct DoTryCatchThrowsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DoTryCatchThrowsBootcamp()
    }
}
