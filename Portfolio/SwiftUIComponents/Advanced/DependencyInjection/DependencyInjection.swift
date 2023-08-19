//
//  DependencyInjection.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/08/19.
//

import SwiftUI
import Combine

struct PostModel: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostModel], Error>
}

class ProductionDataService: DataServiceProtocol {
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class TestingDataService: DataServiceProtocol {
    let testData: [PostModel] = [
        PostModel(userId: 1, id: 1, title: "title1", body: "body1"),
        PostModel(userId: 2, id: 2, title: "title2", body: "body2"),
    ]
    
    func getData() -> AnyPublisher<[PostModel], Error> {
        Just(testData)
            .tryMap({$0})
            .eraseToAnyPublisher()
    }
}

class DependencyInjectionViewModel: ObservableObject {
    @Published var dataArray: [PostModel] = []
    
    let dataService: DataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: DataServiceProtocol) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { _ in
                //
            } receiveValue: { [weak self] receivePosts in
                self?.dataArray = receivePosts
            }
            .store(in: &cancellables)
    }
}

struct DependencyInjection: View {
    @StateObject private var vm: DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocol) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(vm.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}

struct DependencyInjection_Previews: PreviewProvider {
//    static let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    
    static let dataService = TestingDataService()
    
    static var previews: some View {
        DependencyInjection(dataService: dataService)
    }
}
