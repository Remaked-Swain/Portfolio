#  Task and .task
Task 단위와 .task 수정자에 대해 알아보자.

## Task
`Task`는 동기 또는 비동기 환경에서 동작할 수 있는 실행흐름의 단위이다.

* **예제코드**
```swift
import SwiftUI

final class TaskBootcampViewModel: ObservableObject {
    @Published var image: UIImage?
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run { self.image = UIImage(data: data) }
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            Task { // 독자적인 실행흐름: Task
                await viewModel.fetchImage()
            }
        }
    }
}
```
    * 예제코드
    1. 뷰가 나타나려할 때, 뷰모델의 fetchImage() 메서드를 호출한다.
    2. Task로 표현된 실행흐름 내에서 프로세스들이 동작을 기다렸다가 재개하는 과정을 통해 코드가 작성되어 순서대로 진행된다. (suspended and resume)
    
> Task의 클로저 블럭 내에 담긴 다른 코드들은 순차적으로 이루어지며 그것이 하나의 실행흐름이 되어 독자적으로 진행된다.

> 이전에 알아본 `async` 키워드도 마찬가지 인데, 비동기로 동작하는 독자적인 실행흐름을 표현할 때 사용하는 키워드이다.

---

* **두 이미지를 동시에 불러오기 1**
위의 예제코드는 이미지를 하나만 불러와 표시하고 있다.

만약 두 이미지를 불러오고 싶다면 어떻게 할까?

```swift
struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchImage() // suspended and resumed
                await viewModel.fetchImage2() // suspended and resumed
            }
        }
    }
}
```

    * 두 이미지를 동시에 불러오기 1 
    1. 뷰모델은 이제 이미지 두 개를 게시자 프로퍼티로 관리한다.
    2. 마찬가지로 동일한 로직의 `fetchImage()` 메서드의 두 가지 버전을 준비한다.
    3. .onAppear() 수정자 속 Task 블럭에서 두 메서드를 실행한다.
> 이는 실제로 두 이미지를 '동시에' 불러오지 못한다.

> await 키워드를 만나는 순간 `fetchImage()`는 suspend 되어 동작이 완료한 후 실행권한을 다시 받을 때까지 멈추어 기다리게 되고,

> 만약 실행권한이 반환되어 resume 되면 다음 `fetchImage2()`가 역시 suspend, 그리고 resume 된다.

> 따라서 첫 이미지가 근소한 차이로 먼저 나타나고, 뒤이어 다음 이미지가 나타난다.

---

* **두 이미지를 동시에 불러오기 2**

```swift
struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            // 생략...
        }
        .onAppear {
            Task { await viewModel.fetchImage() }
            Task { await viewModel.fetchImage2() }
        }
    }
}
```

    * 두 이미지를 동시에 불러오기 2
    1. 이미지를 불러오는 메서드를 서로 다른 Task 작업 단위로 분리해 선언했다.
> Task 블럭 내에 작성된 코드는 비동기 코드이지만, Task 블럭 자체가 선언된 .onAppear 블럭은 동기 코드이다.

> 따라서 첫 Task 작업을 부른 뒤 곧바로 다음 Task 작업을 호출하게 되므로 두 비동기 코드가 거의 동시에 동작되게 된다.

> 인터넷 속도, 해당 API의 상태, 작업 처리 속도 등에 따라 달라질 수 있지만, 하나의 이미지를 기다리지 않고도 두 이미지가 거의 동시에 나타나는 것을 확인할 수 있다.

---

* **작업 취소하기**
만약 이미지를 불러오는 작업이 끝나기 전에 다른 화면으로 이동하거나, 아예 다른 작업이 필요하거나 하는 등의 상황이 생길 수도 있다.

이 경우 이미지를 불러와도 쓸 일이 없기 때문에 괜히 컴퓨터 자원을 소모하면서 이미지를 불러오지 말고 취소하는 것이 더욱 바람직 할 수 있다.

```swift
struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    @State private var fetchImageTask: Task<Void, Never>?
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            fetchImageTask = Task { await viewModel.fetchImage() }
        }
        .onDisappear {
            fetchImageTask?.cancel()
        }
    }
}
```

    * 작업 취소하기
    1. 이미지를 가져오는 작업을 조종할 수 있도록 상태 변수로 추가한다.
    2. 화면이 사라질 때 호출되는 .onDisappear 수정자를 사용해, 해당 작업을 취소하는 Task.cancel() 메서드를 호출하도록 한다.
> 만약 다른 화면으로 이동하여 .onDisppear 수정자가 불릴 경우, 이제 이미지를 불러올 필요가 없으므로 작업을 취소할 수 있게 됐다.

---

* .task 수정자

```swift
struct TaskBootcamp: View {
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
//        .onAppear {
//            fetchImageTask = Task { await viewModel.fetchImage() }
//        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
        .task {
            await viewModel.fetchImage()
        }
    }
}
```

    * .task 수정자
    1. .onAppear와 .onDisappear 수정자를 사용, 해당 작업을 상태 변수로 저장해두고 사용하는 코드를 제거.
    2. 그 대신 .task 수정자를 사용해 필요한 동작을 호출한다.
> .task 수정자로 전달하는 action 매개변수에 대해 다음과 같은 설명이 쓰여 있다.

> `A closure that SwiftUI calls as an asynchronous task when the view appears.`

> `SwiftUI automatically cancels the task if the view disappears before the action completes.`

> 즉, SwiftUI가 뷰가 나타날 때, 사라질 때에 맞춰 자동으로 비동기 작업을 호출하거나 취소한다는 것이다.

> .task 수정자를 통해 기존과 동일한 행동을 수행할 수 있으면서 코드의 양은 줄일 수 있다.

> 만일 어떤 비동기 작업에 대해서, 그 작업이 또 다른 여러 비동기 작업으로 이루어질 수 있는데, 이 경우 작업을 취소하는 시도가 그 하위 비동기 작업에 대해 모두 적용되지 않는다.

> 따라서 작업의 취소 상태 여부를 검증하는 등의 추가적인 안전장치를 마련해두는 것을 고려해보아야 한다.
