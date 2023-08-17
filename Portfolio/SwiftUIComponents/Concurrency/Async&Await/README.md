#  Async & Await
Escaping Closure와 Combine을 사용하여 이미지를 다운로드하고 async, await 키워드를 익혀보자.

## Download Image
Lorem Picsum API를 이용하여 여러가지 방법으로 이미지를 다운로드

* Escaping Closure를 사용한 방법
```Swift
class ImageLoader {
    private let url = URL(string: "https://picsum.photos/200")!
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let url = self.url else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data,
                  let image = UIImage(data: data),
                  let response = response as? HTTPURLResponse,
                  response.statusCode >= 200 && response.statusCode < 300
            else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(image, nil)
        }
        .resume()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let loader = ImageLoader()
    
    func fetchImage() {
        loader.downloadImage { [weak self] image, error in
            if let image = image {
                self?.image = image
            }
        }
    }
}

struct DownloadImageAsync: View {
    @StateObject private var vm = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            vm.fetchImage()
        }
    }
}
```

    * 기본 틀
    1. ViewModel은 ImageLoader를 이용해 View로 데이터를 전달
    2. ImageLoader는 실질적으로 URLSession을 이용해 Lorem Picsum API와 통신하여 이미지 데이터를 수신
> ImageLoader.downloadWithEscaping() 메서드는 이미지 데이터를 받아오기 위한 작업을 수행하는데 이 과정에서 성공과 실패 상태에 따른 처리는 다른 곳에서 처리하려고 한다.
> 따라서 @escaping 키워드를 적은 핸들러 함수를 포함시키고, 이를 호출하는 ViewModel에서 핸들러 작업을 처리하게 한다.
> 하지만 View를 렌더링하는 일은 메인스레드 상에서 이루어져야 하므로 코드를 수정할 필요가 있다.

```Swift
class ImageLoader {
    private let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300
        else { return nil }
        
        return image
    }
    
    func downloadWithEscaping(completionHandler: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {
        guard let url = self.url else { return }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, error)
        }
        .resume()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let loader = ImageLoader()
    
    func fetchImage() {
        loader.downloadImage { [weak self] image, error in
            DispatchQueue.main.async {
                self?.image = image
            }
        }
    }
}
```

    * 변경점
    1. View에 그려지는 이미지에 대하여 메인스레드 환경임을 보장하기 위해 그 원천인 ViewModel의 image를 DispatchQueue.main에서 대입하도록 만듦
    2. URLSession의 API 응답을 전처리하는 클로저를 별도의 함수로 추출
> Combine을 사용하면 코드를 어떻게 바꿀 수 있을까?

* Combine을 사용한 방법
```Swift
import Combine

class ImageLoader {
    // 생략...
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({$0})
            .eraseToAnyPublisher()
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    
    private let loader = ImageLoader()
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage() {
        loader.downloadWithCombine()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                //
            } receiveValue: { [weak self] receiveImage in
                self?.image = receiveImage
            }
            .store(in: &cancellables)
    }
}
```

    * 변경점
    1. Combine은 게시와 구독을 결합해 처리하는 작업을 쉽게 만들 수 있음, 따라서 URLSession의 통신이 게시자를 두고 이루어지게 함
    2. .receive 를 이용해 메인스레드 환경임을 보장
    3. .sink 를 이용해 게시자로부터 이미지 데이터를 구독받고 이 구독자는 cancellables set에 저장됨
> 오히려 Escaping closure 보다 Combine을 많이 써봐서 그런지 이게 더 친숙한 느낌이 든다.
> 이제 async, await 키워드를 사용한 예제를 보자.

* Async, Await 키워드를 사용한 방법
```Swift
class ImageLoader {
    // 생략...
    
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

class DownloadImageAsyncViewModel: ObservableObject {
    // 생략...
    
    func fetchImage() async {
        let image = try? await loader.downloadWithAsync()
        await MainActor.run { self.image = image }
    }
}

struct DownloadImageAsync: View {
    @StateObject private var vm = DownloadImageAsyncViewModel()
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            Task { await vm.fetchImage() }
        }
    }
}
```

    * 변경점
    1. URLSession.shared.data() 를 통해 응답을 받는 것은 Concurrency Context를 만족하여야 함
        1-1. Concurrency Context란, 해당 코드 문맥이 동시성을 지원하는 상태에 놓여있다는 것이다.
        1-2. Concurrency Context를 만족하여야 비로소 async, await 등의 동시성 키워드를 사용하여 코드를 구성할 수 있다.
    2. ViewModel.fetchImage() 역시 ImageLoader.downloadWithAsync()를 호출하는 상황에서 Concurrency Context를 만족시켜야 함
        2-1. try? await 키워드를 통해 image 수신을 위한 대기와 옵셔널 에러 처리를 수행한다.
        2-2. MainActor.run()으로 메인스레드 환경임을 보장하고, 또한 await 키워드를 붙힌다.
    3. View 역시 ViewModel.fetchImage()를 호출하는 상황에서 Concurrency Context를 만족시켜야 함
        3-1. Task() 객체는 동시성을 지원하는 상태의 작업을 표현할 수 있다.
        3-2. 따라서 Task 객체를 통해 ViewModel.fetchImage()를 호출한다.
        3-3. 마찬가지로 image를 수신하는 과정에서 대기하여야 할 수 있으므로 await 키워드를 붙힌다.
> async, await 키워드를 사용하여 바뀐 메서드는 URLSession 통신으로 인해 대기하게 될 수 있다는 것을 코드 상으로 빠르게 표현할 수 있고,
> 핸들링 클로저에 오타가 있거나 생략한 경우에 민감하게 반응하여 안전한 코딩이 가능하다.
