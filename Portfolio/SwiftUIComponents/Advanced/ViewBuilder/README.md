# @ViewBuilder
매개변수로 커스텀한 하위 뷰를 그릴 수 있는 클로저를 만드는 ViewBuilder 속성 래퍼를 알아보자.

## 사용자 정의 헤더 뷰 만들기 예제
때때로 뷰의 헤더는 앱의 개성을 나타낼 수 있어야 하고 앱 내의 다양한 뷰에서 재사용할 수도 있어야 한다.

* 기본 형태

```Swift
import SwiftUI

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                Text("Description")
                    .font(.callout)
                
                RoundedRectangle(cornerRadius: 5)
                    .frame(height: 5)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            Spacer()
        }
    }
}
```

    * 기본 형태
    1. 제목, 설명, 표시선으로 이루어진 헤더 역할의 뷰를 선언
> 우선은 기본적인 헤더의 형태로 제목과 설명, 그리고 본문과의 구조 분리를 나타내는 디바이더 목적의 표시선이 있다.
> 뷰의 헤더는 앱의 개성이 나타나는 곳이기 때문에 우리는 앱을 자유롭게 꾸미고 싶다.
> 또한 헤더라는 역할에 맞게 다양한 뷰에서 재사용할 수 있게 설계해야 한다.
> 그렇게 하기 위해서 뷰 헤더를 별도의 뷰로 만들어두고, 필요한 곳에 가져다 쓸 수 있도록 만들고 싶다.

* 헤더 뷰를 추출

```Swift
struct HeaderViewRegular: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Description")
                .font(.callout)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewRegular()
            
            Spacer()
        }
    }
}
```

    * 헤더 뷰를 추출
    1. 헤더 뷰의 요소인 제목, 설명, 표시선을 HeaderViewRegular라는 이름의 뷰로 추출
    2. 헤더 뷰를 가져다 씀
> 헤더 뷰를 재사용할 수 있게 되었지만 아직 표현의 자유도 측면에서는 갈 길이 멀다.
> 어떤 화면이냐에 따라서 제목과 설명이 필요할 수도, 없을 수도, 또는 제목만 필요할지도 모르기 때문이다.

* 생성 시점에 결정되도록 변경

```Swift
struct HeaderViewRegular: View {
    let title: String
    let description: String?
    let iconName: String?
    // let iconName2: String?
    // let iconName3: String?
    // ...
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            if let description = description {
                Text(description)
                    .font(.callout)
            }
            
            if let iconName = iconName {
                Image(systemName: iconName)
            }
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            HeaderViewRegular(title: "Title", description: "Description", iconName: "heart.fill")
            HeaderViewRegular(title: "Title", description: nil, iconName: nil)
            
            Spacer()
        }
    }
}
```

    * 생성 시점에 결정되도록 변경
    1. 생성 시 매개변수로 헤더 뷰의 요소를 전달하도록 만듦
    2. 특정 요소가 필요없는 경우를 고려하여 옵셔널 타입으로 변경
    3. 적절한 옵셔널 해제 구문을 사용
> 이제 헤더 뷰는 구성에 필요한 요소를, 헤더 뷰가 선언되는 시점에 전달하여 생성될 수 있게 되었다.
> 그러나 위 코드처럼 만약 icon이 2개, 3개, 아니 100개가 필요하다면 어떻게 해야할까?
> 혹은 매우 복잡한 로직이 필요한 뷰를 헤더 뷰에 삽입해야 한다면 어떻게 해야할까?

* 제네릭 사용

```Swift
struct HeaderViewGeneric<Content: View>: View {
    let title: String
    let content: Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 5)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            // 생략...
            HeaderViewGeneric(title: "Title", content: Text("Description"))
            HeaderViewGeneric(title: "Title", content: VStack {
                Text("Description")
                Image(systemName: "bolt.fill")
            })
            
            Spacer()
        }
    }
}
```

    * 제네릭 사용
    1. 제네릭 타입 뷰 구조체인 HeaderViewGeneric 선언, 내부 로직은 동일
> Text, Image 처럼 View 프로토콜을 준수하는 객체인 경우는 위 코드로 이전과 동일한 효과를 보장한다.
> 또한 View 프로토콜만 준수하면 되니까 복잡한 로직을 가진 뷰를 외부에 만들어두고 제네릭으로 전달하기만 하면 쉽게 삽입할 수 있다.
> 그러나 content 제네릭 매개변수를 전달하는 곳을 보면 느껴지듯이, 코드 가독성이 저하될 수 있는 여지가 있다.
> 클로저의 사용이 권장되는 시점이다.

* 제네릭에 클로저 사용

```Swift
struct HeaderViewGeneric<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    // 생략...
}

struct ViewBuilderBootcamp: View {
    var body: some View {
        VStack {
            // 생략...
            HeaderViewGeneric(title: "Title") {
                Text("Description")
            }
            HeaderViewGeneric(title: "Title") {
                VStack {
                    Text("Description")
                    Image(systemName: "bolt.fill")
                }
            }
            
            Spacer()
        }
    }
}
```

    * 클로저 사용
    1. content 제네릭 매개변수를 전달받는 것을 함수로 받게 됨(즉 클로저)
> 이렇게 하면 외부에서 클로저를 통해 매개변수명을 직접 사용하지 않아도 된다.
> 그렇다면 이 문서의 본래 주제인 @ViewBuilder는 왜 사용해야 하는 것일까?

--------------------------------------------------

## @ViewBuilder
@ViewBuilder는 대체 무슨 장점이 있길래 사용하는 것일까?

* @ViewBuilder 사용으로 얻게되는 이점
1. Multiple Child Views Handling
    `@ViewBuilder`를 사용하면 클로저 내에 여러 개의 뷰를 포함할 수 있게 되고,
    이렇게 되면 해당 함수를 호출할 때 다양한 뷰 구조를 생성할 수 있게 된다.
    따라서 `@ViewBuilder`를 사용하지 않으면 하나의 뷰 타입만 반환할 수 밖에 없다.
2. Conditional View Composition
    `@ViewBuilder`를 사용하면 조건부로 뷰를 조립할 수 있다. 조건에 따라 뷰를 달리해야할 때 가독성을 높일 수 있다.
    
* @ViewBuilder 미사용 예제

```Swift
struct ConditionalView: View {
    @frozen enum ViewType {
        case titleOnly, withDescription, withImage
    }
    
    let type: ViewType
    
    var body: some View {
        content
    }
    
    // 이 지점에서 에러 발생. (명확하지 않고 비결정적인 조건부 뷰의 반환이 원인)
    private var content: some View {
        switch type {
        case .titleOnly: return titleOnly
        case .withDescription: return withDescription
        case .withImage: return withImage
        }
    }
    
    private var titleOnly: some View {
        Text("Title")
    }
    
    private var withDescription: some View {
        VStack {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Description")
                .font(.callout)
        }
    }
    
    private var withImage: some View {
        VStack {
            Text("Title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Image(systemName: "heart.fill")
        }
    }
}
```

    * 미사용 예제
    1. ConditionalView를 사용하려할 시, ViewType을 전달하면 생성이 가능
    2. ViewType에 따라 표시해야할 하위 뷰 3개 존재
> 이 예제에서는 명확하지 않은 뷰의 반환이 이루어짐에 따라 에러메시지가 나온다.
> @ViewBuilder의 효과를 사용해보자.

* @ViewBuilder 사용 예제

```Swift
struct ConditionalView: View {
    // 생략...
    
    @ViewBuilder private var content: some View {
        switch type {
        case .titleOnly: titleOnly
        case .withDescription: withDescription
        case .withImage: withImage
        }
    }
    
    // 생략...
}
```

    * 사용 예제
    1. 조건 분기가 포함된 변수에 @ViewBuilder 애트리뷰션을 붙힘
> `@ViewBuilder`의 이점을 활용하여 에러 없이 멋진 뷰를 만들 수 있게 되었다.
