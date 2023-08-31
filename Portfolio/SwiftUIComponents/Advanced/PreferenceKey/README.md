# PreferenceKey
PreferenceKey Protocol이 무엇인지, 그리고 왜 사용하는지 알아보자.

## PreferenceKey
PreferenceKey 프로토콜은 데이터 흐름을 관리하고 뷰 간에 데이터를 전달하고 공유하기 위해 사용된다.
선언형 프로그래밍 방식의 SwiftUI는 데이터의 상태 변화를 추적하고 UI를 업데이트하기 위한 매커니즘이 필요한데,
PreferenceKey 프로토콜을 통해 이러한 데이터의 흐름을 관리하는 역할을 수행할 수 있다.

* PreferenceKey 사용으로 얻는 이점
    * 데이터 공유와 전달: 하위 뷰에서 생성된 정보를 상위 뷰로 전달하여 사용하거나, 여러 뷰 사이에서 공유해야 하는 데이터를 전달할 수 있다.
    * 레이아웃 및 배치 조정: 하위 뷰에서 생성된 크기나 위치와 같은 정보를 사용하여 상위 뷰의 레이아웃 및 배치를 조정해야할 때 유용하다.
    * 뷰 간 협력: 여러 개의 하위 뷰를 조합해 하나의 복합적인 UI를 구성해야할 때 각 하위 뷰에서 생성된 정보를 수집하여 이를 구현할 수 있다.
    
* PreferenceKey 사용 요약
    1. PreferenceKey 프로토콜을 채택하는 데이터를 생성, 프로토콜을 준수할 수 있도록 필수로 구현해야하는 것들을 용도에 맞게 구현.
    2. `.preference()` 메서드를 사용하여 하위 뷰에서 상위 뷰로 전달 가능.
    3. `.onPreferenceChange(_ : perform:)` 메서드를 사용하여 하위 뷰에서 전달된 데이터의 변화를 감지, 상위 뷰에서 활용.
> PreferenceKey의 사용법을 예제를 통해 살펴보자.

-------------------------------------------------------

## 네비게이션 타이틀을 동적으로 전달하는 예제
하위 뷰에서 네비게이션 타이틀을 상위 뷰에 전달하는 방식으로 PreferenceKey Protocol을 이해해보자.

* 기본 세팅
```Swift
import SwiftUI

struct PreferenceKeyBootcamp: View {
    @State private var text: String = "Hello, world!"
    
    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen(text: text)
//                    .navigationTitle("Navigation Title") // 하위 뷰에 붙어있는 타이틀
            }
            .navigationTitle("Navigation Title") // 상위 뷰에 붙어있는 타이틀
        }
    }
}

fileprivate struct SecondaryScreen: View {
    let text: String
    
    var body: some View {
        Text(text)
    }
}
```

    * 기본 세팅
    1. 위와 같은 Navigation 구조가 존재한다고 가정
    2. 하위 뷰의 text 데이터는 상위 뷰에서 흘러들어옴
> PreferenceKeyBootcamp View(이하 상위 뷰)가 존재하고, SecondaryScreen View(이하 하위 뷰)가 존재한다.
> 상태변수 text는 상위 뷰에서 선언되어 네비게이션 컨테이너를 타고 하위 뷰에 전달되고 하위 뷰에서는 다시 Text() 객체에 전달하는 식으로 구성 되어있다.
> 이것이 SwiftUI에서 곧잘 이루어지는 데이터 흐름이기에 아주 익숙한 모습이다.
> 만약 `.navigationTitle()` 수정자가 하위 뷰에 붙어있으면 네비게이션 타이틀을 하위 뷰에서 바꿀 수 있을까?

* 사용법 #1 적용
```Swift
struct CustomTitlePreferenceKey: PreferenceKey {
    static var defaultValue: String = ""
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
```

    * 사용법 #1 적용
    1. PreferenceKey 프로토콜 하에 주고받을 데이터에 대해 정의
    2. defaultValue는 주고받을 데이터에 대한 타입을 명시
    3. reduce() 함수는 PreferenceKey의 전달을 통해 뭔가 변경이 일어날 경우의 처리를 명시
> 우선 사용법 #1에서 설명했듯이 프로토콜을 채택하는 데이터를 선언하고 프로토콜의 적용을 위해 필수로 구현해야할 defaultValue, reduce()를 구현했다.
> NavigationTitle은 문자열 타입으로 다룰 것이므로 `static var defaultValue: String = ""`으로,
> `static func reduce(value: inout String, nextValue: () -> String) {...}` 함수는 동일한데,
> nextValue 클로저를 통해 기존 데이터의 변경이 이루어진다는 의미이다.

* 사용법 #2,3 적용
```Swift
struct PreferenceKeyBootcamp: View {
    @State private var text: String = "Hello, world!"
    
    var body: some View {
        NavigationStack {
            // 생략...
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.text = value
        }
    }
}

fileprivate struct SecondaryScreen: View {
    let text: String
    
    var body: some View {
        Text(text)
            .preference(key: CustomTitlePreferenceKey.self, value: "New Value")
    }
}
```

    * 사용법 #2,3 적용
    1. 하위 뷰에서 값을 전달하기 위해 `.preference()` 메서드 사용
    2. 상위 뷰에서 전달된 데이터를 관찰하고 변화를 감지할 수 있도록 `.onPreferenceChange(_ :, perform:)` 메서드 사용
> 위 코드에서는 text로 선언했던 "Hello, world!" 라는 문자열에서 "New Value" 라는 문자열로 변화가 이루어짐에 따라
> 상위 뷰가 이러한 변화를 알아차리고 "New Value" 데이터를 담은 Text() 객체를 다시 그리게 된다.
> 즉, 뷰를 그리는데 필요한 데이터가 상위 뷰에서 하위 뷰로 흘러내려오는게 아니라 하위 뷰에서 상위 뷰로 올라가는 구조가 됐다는 것을 알 수 있다.

* 네비게이션 타이틀 변경
```Swift
struct PreferenceKeyBootcamp: View {
    @State private var text: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen()
            }
            .navigationTitle(text) // 상위 뷰에 붙어있는 타이틀
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.text = value
        }
    }
}

fileprivate struct SecondaryScreen: View {
    @State private var navigationTitle: String = ""
    
    var body: some View {
        Button {
            navigationTitle = "Title Changed!"
        } label: {
            Text("Click here to change Title")
        }
        .preference(key: CustomTitlePreferenceKey.self, value: navigationTitle)
    }
}
```

    * 네비게이션 타이틀 변경
    1. 하위 뷰에서 동적으로 네비게이션 타이틀을 바꿀 수 있도록 상태변수 navigationTitle을 선언
    2. 네비게이션 타이틀 변경의 트리거인 버튼을 구현
    3. `.preference()` 메서드로 전달할 값(네비게이션 타이틀)을 text에서 navigationTitle 상태변수로 변경
> 이제 버튼을 누르면 상위 뷰의 text 값이 하위 뷰에서 올라온 문자열 값에 영향을 받게 되어 네비게이션 타이틀이 변경된다.
