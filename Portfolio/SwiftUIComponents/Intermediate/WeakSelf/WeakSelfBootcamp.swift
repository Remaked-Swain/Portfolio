//
//  WeakSelfBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/20.
//

import SwiftUI

class NextScreenViewModel: ObservableObject {
    @Published var data: String? = nil
    
    init() {
        print("Initialized")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit {
        print("Deinitialized")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 100) { [weak self] in
            self?.data = "New Data"
        }
    }
}

fileprivate struct NextScreen: View {
    @StateObject var vm = NextScreenViewModel()
    
    var body: some View {
        Text("Subview")
            .font(.largeTitle)
            .foregroundColor(.red)
        
        if let data = vm.data {
            Text(data)
        }
    }
}

struct WeakSelfBootcamp: View {
    @AppStorage("count") var count: Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink("Navigate") {
                NextScreen()
                    .navigationTitle("Screen 1")
            }
            .navigationTitle("Upper View")
        }
        .overlay(
            Text("\(count ?? 0)")
                .padding()
                .background(Color.green.cornerRadius(14))
            , alignment: .topTrailing
        )
    }
}

struct WeakSelfBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        WeakSelfBootcamp()
    }
}
