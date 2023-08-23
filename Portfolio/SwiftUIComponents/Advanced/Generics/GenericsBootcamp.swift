//
//  GenericsBootcamp.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/23.
//

import SwiftUI

//struct StringModel {
//    let value: String?
//
//    func removeValue() -> StringModel {
//        StringModel(value: nil)
//    }
//}
//
//struct BoolModel {
//    let value: Bool?
//
//    func removeValue() -> BoolModel {
//        BoolModel(value: nil)
//    }
//}

struct GenericModel<T> {
    let value: T?
    func removeValue() -> GenericModel {
        GenericModel(value: nil)
    }
}

class GenericsViewModel: ObservableObject {
    @Published var data = GenericModel(value: "Hello, World!")
    @Published var data2 = GenericModel(value: true)
    
    func removeData() {
        data = data.removeValue()
        data2 = data2.removeValue()
    }
}

struct GenericView<T: View>: View {
    let content: T
    
    var body: some View {
        content
    }
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            GenericView(content: Text("content"))
            
            Text(vm.data.value ?? "Data not found")
            Text(vm.data2.value?.description ?? "Data not found")
        }
        .onTapGesture {
            vm.removeData()
        }
    }
}

struct GenericsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GenericsBootcamp()
    }
}
