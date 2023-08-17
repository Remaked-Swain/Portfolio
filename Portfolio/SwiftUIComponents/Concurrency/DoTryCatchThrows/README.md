#  Do, Try, Catch, Throws
Swift Concurrency에서 Error throwing이 필요한 이유에 대해 알아보고 do, try, catch 키워드와 throw-throws 키워드를 통한 에러 처리 방법을 연습해보자.

## 기본 예제
인터넷이나 서버같이 외부에서 데이터를 받아오는 상황을 가정하여 프로그램을 작성했다.

* 기반 코드

```Swift
import SwiftUI

fileprivate class DataManager {
    let isActive: Bool = false
    
    func getTitle() -> String? {
        guard isActive else { return nil }
        return "New Text!"
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    
    private let manager = DataManager()
    
    func fetchTitle() {
        if let title = manager.getTitle() {
            self.text = title
        }
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
```

    * 기본 예제
    1. View에서 300x300 크기의 영역을 탭하면 새로운 텍스트를 가져와 표시하도록 구성
    2. ViewModel은 DataManager를 이용하여 외부와 통신하고 데이터를 View로 전달
    3. DataManager은 외부에서 데이터를 받아오는 모듈 역할이며, isActive라는 변수는 서버가 문자열을 반환할 수 있는 상태인지 아닌지를 나타냄
> 현재 서버가 정상적으로 데이터를 줄 수 있는 상황인지 여부에 따라 DataManager의 getTitle() 메서드의 결과값이 달라질 것이다.
> 이 기본 코드로는 isActive가 false 일 때 View에서 탭제스처가 이루어져도 아무런 변화가 없다.
> 따라서 사용자 입장에서는 어떤 버그가 있는 것처럼 느낄 수 있고, 동료 개발자가 코드를 원래와는 다른 의도로 사용하게 되는 등, 여러 문제가 발생할 수 있다.

```Swift
fileprivate class DataManager {
    let isActive: Bool = false
    
    func getTitle() -> (title: String?, error: Error?) {
        guard isActive else { return (nil, URLError(.badURL)) }
        return ("New Text!", nil)
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {
    // 생략...
    
    func fetchTitle() {
        let output = manager.getTitle()
        if let title = output.title {
            self.text = title
        } else if let error = output.error {
            self.text = error.localizedDescription
        }
    }
}
```

    * 변경점
    1. DataManager.getTitle() 메서드는 이제 title 결과값과 error 객체로 이루어진 튜플을 반환함
    2. ViewModel.fetchTitle() 메서드는 튜플의 title을 받거나, 없을 경우 error 처리
> 메서드의 반환값을 바꾼 것만으로 조금 더 열린 방식의 처리가 가능해졌고 메서드의 역할과 한계를 보다 명확히 설명할 수 있게 되었다.
> 그러나 title과 error라는 두 가지 결과물을 모두 내보내는 것보다 Result객체 하나만을 내보내는 것이 더 좋아 보인다.

```Swift
fileprivate class DataManager {
    let isActive: Bool = false
    
    func getTitle() -> Result<String, Error> {
        guard isActive else { return .failure(URLError(.badURL)) }
        return .success("New Text!")
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {
    // 생략...
    
    func fetchTitle() {
        let result = manager.getTitle()
        switch result {
        case .success(let title): self.text = title
        case .failure(let error): self.text = error.localizedDescription
        }
    }
}
```

    * 변경점
    1. DataManager.getTitle() 메서드는 이제 Result객체를 반환함
> 개발 과정에서 이 결과물, 저 결과물 전부 살펴보고 처리하는 것보다 성공 상태인지 실패 상태인지만 식별하면 되기 때문에
> 이전 작업과 동일한 동작을 수행하면서도 어떻게 동작하는지 한 눈에 알아보기 쉬워졌다.
> 하지만 이 코드로는 DataManager.getTitle() 메서드가 호출될 때마다 매번 Result에 대한 completion으로 들어가는데, 이때 do, try, catch를 통한 에러 핸들링을 써보자.

```Swift
fileprivate class DataManager {
    let isActive: Bool = false
    
    func getTitle() throws -> String {
        guard isActive else { throw URLError(.badURL) }
        return "New Text!"
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {
    @Published var text: String = "Starting text."
    
    private let manager = DataManager()
    
    func fetchTitle() {
        do {
            let title = try manager.getTitle()
            self.text = title
        } catch let error {
            self.text = error.localizedDescription
        }
    }
}
```

    * 변경점
    1. DataManager.getTitle() 메서드는 이제 처음 계획했던 대로 String값을 반환, 실패할 경우 에러를 던짐
    2. ViewModel.fetchTitle() 메서드는 이제 성공과 실패 상황에 대한 처리를 모두 지원하면서도 효율적인 동작이 가능
> 만약 실패 시 후속 코드를 살펴보지 않고 에러를 던지거나, 성공 시 데이터를 전달하고 catch 블럭을 타지 않는다.


