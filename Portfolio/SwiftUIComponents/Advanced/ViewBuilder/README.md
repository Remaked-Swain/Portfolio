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
