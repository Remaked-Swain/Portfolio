#  Dependency Injection
코드의 설계에 의존성 주입 패턴을 적용하면 어떻게 되는지 알아보자.

## 기본 예제
* 내용 전개를 위해 아래의 코드처럼 세팅

```Swift
import SwiftUI
import Combine

struct PostModel: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

class ProductionDataService {
    let url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    func getData() -> AnyPublisher<[PostModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class DependencyInjectionViewModel: ObservableObject {
    @Published var dataArray: [PostModel] = []
    
    init() {
        loadPosts()
    }
    
    private func loadPosts() {
        // DataService.getData() 메서드와의 연결이 필요한 곳
    }
}

struct DependencyInjection: View {
    @StateObject private var vm = DependencyInjectionViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // ForEach(vm.dataArray) { post in
                //     Text(post.title)
                // }
            }
        }
    }
}
```

    * 기본 예제
    1. JSON응답을 디코딩하기 위해 PostModel을 만들어 Codable 프로토콜을 적용
    2. DataService는 URL에서 JSON응답을 받아 PostModel 배열로 바꿔주는 메서드를 가지고 있음.
> 의존성 주입을 학습하기 위해 생각해보아야 할 것은, 데이터를 가져와 View로 표현하기 위해서 ViewModel은 DataService에 어떻게 연결시킬지이다.

## Singleton Pattern
먼저 싱글톤 패턴을 써보자

* DataService, Singleton pattern 적용

```Swift
class ProductionDataService {
    static let shared = ProductionDataService() // Singleton instance
    
    let url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    private init() {}
    
    func getData() -> AnyPublisher<[PostModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({$0.data})
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

class DependencyInjectionViewModel: ObservableObject {
    @Published var dataArray: [PostModel] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadPosts()
    }
    
    private func loadPosts() {
        ProductionDataService.shared.getData()
            .sink { _ in
                //
            } receiveValue: { [weak self] receivePosts in
                self?.dataArray = receivePosts
            }
            .store(in: &cancellables)
    }
}
```

    * 변경점
    1. DataService 인스턴스를 클래스 내부에서 static으로 생성하여 싱글톤 인스턴트로 생성
    2. ViewModel에서는 DataService의 전역 인스턴스에 접근
> 싱글톤 패턴은 전역적으로 사용할 수 있는 하나의 인스턴스를 생성하고 여러 곳에 설정 값이나 자원을 공유할 수 있다.
> 따라서 여러 곳에서 사용되는 리소스를 효율적으로 관리할 수 있다.
> 또한 한 번 생성된 인스턴스를 계속해서 재사용함으로써 메모리 사용을 절약할 수 있다.
> 그렇다면 의존성 주입 방식을 왜 사용하는 것일까?

----------------------------------------------

## Singleton Pattern's Flaw
싱글톤 패턴의 단점을 살펴보고 의존성 주입 방식이 이를 어떻게 해결할 수 있는지 알아보자

* 싱글톤은 전역적이다.

싱글톤 인스턴스의 선언이 코드 그 어떤 곳에서든 일어날 수 있다. 또한 많은 전역변수를 싱글톤에서 관리하면 코드가 매우 복잡해질 수 있다.
특히 멀티스레딩 환경에서 싱글톤 인스턴스에 다발적으로 접근하려 한다면 충돌이 발생할 수 있고 이를 위한 처리가 필요하다.

* 생성자를 커스텀하게 설정할 수 없다

```Swift
class ProductionDataService {
    static let shared = ProductionDataService(param: '...???' ) // Singleton instance
    
    init(param: Any) {
        // 생성 시 매개변수를 받아 뭔가를 하고 싶음...
    }
    
    // 생략...
}
```

별도의 매개변수를 전달하여 사용자 정의 작업을 수행하고 싶다면 이니셜라이저를 위와 같이 작성하면 된다.
이러면 다른 위치에 DataService를 생성하는 경우에 생성에 필요한 파라미터를 새로이 바꿔서 전달할 수 없게 된다.
전역 인스턴스를 위처럼 클래스 내부에서 생성하고 있으므로 즉시 그 매개변수를 넣어주어야 하기 때문이다.
따라서 생성자를 커스터마이징 할 수 없다.

* 강한 결합도

싱글톤 인스턴스는 코드 내에서 직접 참조되므로, 클래스 간 결합도가 강하게 유지된다.
따라서 만약 다른 기능을 수행하는 DataService2가 있고, 이것으로 연결을 바꾸고자 하여도 교체가 어렵다.

----------------------------------------------

## DI (Dependency Injection) Pattern
의존성 주입 방식은 인스턴스를 생성하는 시기를 일찍 이루어지게 하는 것이다

``` Swift
class DependencyInjectionViewModel: ObservableObject {
    @Published var dataArray: [PostModel] = []
    
    let dataService: ProductionDataService
    private var cancellables = Set<AnyCancellable>()
    
    init(dataService: ProductionDataService) {
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
    
    init(dataService: ProductionDataService) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    // 생략...
}

struct DependencyInjection_Previews: PreviewProvider {
    static let dataService = ProductionDataService()
    
    static var previews: some View {
        DependencyInjection(dataService: dataService)
    }
}
```

    * 변경점
    1. DataService의 싱글톤 인스턴스 제거
    2. ViewModel의 이니셜라이저에서 DataService를 외부로부터 전달받음
    3. View의 이니셜라이저에서 ViewModel을 외부로부터 전달받음
    4. 외부에서 생성된 DataService의 인스턴스를 View에 전달
> 이렇게 일찍 생성한 인스턴스를 필요한 곳에 말 그대로 '주입'하는 것이 의존성 주입 방식이다.

----------------------------------------------

## DI Pattern's Benefit
의존성 주입 방식을 도입하여 싱글톤 패턴의 단점을 해소할 수 있다

* 선택적 접근과 리소스 사용

```Swift
class ProductionDataService {
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

struct DependencyInjection_Previews: PreviewProvider {
    static let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    
    static var previews: some View {
        DependencyInjection(dataService: dataService)
    }
}
```

이제 DataService에 접근할 수 있는 클래스는 실제로 이것을 주입하게 선택한 클래스 뿐이므로,
앱의 아무데서나 DataService를 참조할 수 없으며 주입하지 않으면 리소스를 사용할 수 없게 된다.
이렇게 의존성 주입 방식을 사용하면 어떤 클래스가 필요하지 않은 상황에서 전역 인스턴스에 접근하는 것을 예방하게 된다.

* 이니셜라이징 과정을 커스터마이징

DataService의 메서드는 그대로 사용하되, 만약 데이터를 요청할 URL을 바꾸고 싶을 때를 가정하여
DataService의 이니셜라이저를 수정, 요청할 URL을 매개변수로 받아오도록 만들었다.
이렇게 의존성 주입 방식을 사용하면 이니셜라이저를 원하는 용도에 맞게 커스터마이징하여 사용할 수 있게 된다.

* 느슨한 결합도

```Swift
protocol DataServiceProtocol {
    func getData() -> AnyPublisher<[PostModel], Error>
}

class ProductionDataService: DataServiceProtocol {
    // 생략...
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
    
    // 생략...
}

struct DependencyInjection: View {
    @StateObject private var vm: DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocol) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    // 생략...
}

struct DependencyInjection_Previews: PreviewProvider {
//    static let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
    
    static let dataService = TestingDataService()
    
    static var previews: some View {
        DependencyInjection(dataService: dataService)
    }
}
```

    * 변경점
    1. DataServiceProtocol 선언
    2. 의존성 주입 경로에서 DataServices 타입을 DataServiceProtocol로 수정
    3. 코드 테스트에 사용할 목데이터를 다루는 클래스인 TestingDataService를 선언
> 기존 ProductionDataService에 추가로 TestingDataService를 사용하게 되었다고 가정하자.
> 만약 내부 테스트를 위해 ViewModel과 연결된 DataService를 교체하고 싶은 상황이다.
> 커스텀 프로토콜을 사용하여 동일한 프로토콜을 채택한 DataServices들 중에 주입하려는 클래스를 선택하여 연결시킬 수 있게 되었다.

의존성 주입 방식을 사용하면 필요에 따라서 연결시킬 DataService를 선택해 부품을 갈아끼우듯이 교체할 수 있다.
따라서 낮은 결합 상태의 특징인 유지보수성과 확장성의 증가를 기대할 수 있다.
