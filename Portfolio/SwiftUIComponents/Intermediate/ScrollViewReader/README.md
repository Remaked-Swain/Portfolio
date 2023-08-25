#  ScrollViewReader
스크롤뷰를 더욱 풍성하게 사용할 수 있는 ScrollViewReader에 대해 알아보자.

## 기본 세팅
학습 진행을 위해 다음과 같은 코드로 세팅한다.

```Swift
import SwiftUI

struct ScrollViewReaderBootcamp: View {
    var body: some View {
        ScrollView {
            ForEach(0..<50) { index in
                Text("This is item #\(index)")
                    .font(.headline)
                    .frame(height: 100)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(14)
                    .shadow(radius: 10)
                    .padding()
            }
        }
    }
}
```

    * 기본 세팅
    1. 50개의 텍스트 카드로 구성된 스크롤뷰 선언
> 서로 간격을 두고 50개의 텍스트 카드가 나열되어있다.
> ScrollViewReader를 가지고 놀아보자.

---------------------------------------------

## ScrollViewReader
ScrollViewReader의 선언과 활용

* 드래그없이 스크롤뷰 조작하기

```Swift
struct ScrollViewReaderBootcamp: View {
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                ForEach(0..<50) { index in
                    Text("This is item #\(index)")
                        // 생략...
                }
            }
        }
    }
}
```

    * 변경점
    1. ScrollViewReader를 선언하고 읽어들일 대상을 클로저로 전달.
> 프록시는 '다른 서버로부터 클라이언트의 요청을 중계하거나 필터링하는 역할을 하는 중간 서버'를 말한다.
> SwiftUI에서 프록시는 추적 대상의 정보를 Reader에게 중계, 필터링하는 중간 매개체라고 이해하면 좋을 것 같다.
> 프록시는 다음과 같이 사용할 수 있다.

```Swift
struct ScrollViewReaderBootcamp: View {
    var body: some View {
        ScrollView {
            ScrollViewReader { proxy in
                Button("Go to #49") {
                    proxy.scrollTo(49, anchor: nil)
                }
                
                ForEach(0..<50) { index in
                    Text("This is item #\(index)")
                        // 생략...
                        .id(index)
                }
            }
        }
    }
}
```

    * 변경점
    1. 프록시를 다룰 버튼 추가
    2. 인덱스를 기준으로 텍스트 카드에 id 부여
> proxy객체의 .scrollTo(_ id: Hashable, _ anchor: UnitPoint?) 메서드를 활용해, 버튼을 누르면 최하단 텍스트 카드로 이동하게 만들었다.
> proxy객체는 49 라는 id값을 가지고 텍스트 카드에 부여된 id값과 비교하여 위치를 찾아낸다.
> anchor는 프록시로 추적한 대상의 위치로, 버튼을 눌렀을 때 화면에 나타날 텍스트 카드의 위치를 정할 수 있다.
> .center, .top, .bottom과 같이 UnitPoint값을 주면 된다.
> 만약 버튼을 통해 스크롤뷰를 조종하는 기능이 있는 앱이라면, 그 버튼이 스크롤뷰 내부에 있을 일은 보통 없으므로 버튼을 밖으로 빼보기로 했다.

```Swift
struct ScrollViewReaderBootcamp: View {
    @State private var text: String = ""
    @State private var scrollToIndex: Int = 0
    
    var body: some View {
        VStack {
            TextField("숫자를 입력하세요.", text: $text)
                .frame(height: 55)
                .border(Color.gray)
                .padding(.horizontal)
                .keyboardType(.numberPad)
            
            Button("Scroll") {
                if let index = Int(text) {
                    scrollToIndex = index
                }
            }
            
            ScrollView {
                ScrollViewReader { proxy in
                    ForEach(0..<50) { index in
                        Text("This is item #\(index)")
                            // 생략...
                            .id(index)
                    }
                    .onChange(of: scrollToIndex) { newValue in
                        withAnimation(.easeInOut) {
                            proxy.scrollTo(newValue, anchor: nil)
                        }
                    }
                }
            }
        }
    }
}
```

    * 변경점
    1. 동적으로 이동할 목표 index를 받기 위한 상태변수와 텍스트필드를 추가
    2. 이동 버튼의 위치를 ScrollViewReader 블록 밖으로 변경
    3. 텍스트 카드의 데이터 변화에 따라 특정 작업을 수행할 수 있도록 .onChange() 메서드 선언
> 버튼을 ScrollViewReader 블록 밖으로 옮겼기 때문에 proxy객체를 바로 사용할 수 없게 되었다.
> 그래서 scrollToIndex라는 상태변수를 두고 .onChange 메서드로 변경을 감시, 버튼을 누르면 이동되게끔 재구성했다.
> ScrollViewReader는 똑똑하기 때문에 텍스트 카드의 id값이 아닌 인덱스로의 이동은 무시한다.
> 예를 들어 텍스트필드에 50을 넣고 버튼을 누르면 아무런 반응이 없을 것이다.
