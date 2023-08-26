#  GeometryReader
객체의 정확한 크기와 위치를 알아내주는 GeometryReader에 대해 알아보자.

## 화면 분할 예제
너비를 동적으로 계산하여 화면을 분할시켜보자

* Frame을 통한 화면 분할

```Swift
import SwiftUI

struct GeometryReaderBootcamp: View {
    var body: some View {
        HStack(spacing: 0) {
            Rectangle().fill(Color.red).frame(width: UIScreen.main.bounds.width * 2 / 3)
            Rectangle().fill(Color.blue)
        }
        .ignoresSafeArea()
    }
}
```

    * Frame을 통한 화면 분할
    1. 화면에는 두 개의 뷰가 존재(빨강 영역과 파랑 영역)
    2. 한 쪽 뷰에 화면 너비의 2/3 값을 주어 화면을 두 영역으로 분할
> 이 경우에는 화면을 분할하기 위해 프레임 값 조절을 시도했다.
> 그러나 아이폰을 가로 방향으로 돌린다면, 프레임 값은 UIScreen의 width로 계산했기 때문에 오히려 파랑 영역이 더 넓게 차지하게 된다.
> 즉, 위 코드로는 모든 상황에서 빨강 영역이 파랑 영역의 두배가 되게끔 만들지는 못한다는 것이다.
> 왜냐하면 UIScreen의 width 값은 아이폰이 세로 방향일 때의 너비를 의미하기 때문이다.

* GeometryReader를 통한 화면 분할

```Swift
struct GeometryReaderBootcamp: View {
    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                Rectangle().fill(Color.red).frame(width: proxy.size.width * 2 / 3)
                Rectangle().fill(Color.blue)
            }
            .ignoresSafeArea()
        }
    }
}
```

    * GeometryReader를 통한 화면 분할
    1. GeometryReader 블럭 내에 추적 대상을 넣음
    2. 분할 비율로서 전달하려는 값을 proxy객체가 추적한 width로 변경
> 위 코드에서는 시뮬레이터의 방향과 관계없이 빨강 영역이 파랑 영역의 두배를 차지하게 된다.
> 왜냐하면 GeometryReader는 똑똑하기 떄문에 화면을 돌려도 proxy가 추적하는 값이 그 상태에 맞게 업데이트 되기 때문이다.
> 이처럼 GeometryReader는 기하학적인 요소를 추적해야할 때 유용하게 사용할 수 있다.

----------------------------------------------------

## 애니메이션이 가미된 스크롤뷰 구현
GeometryReader를 사용해 멋진 스크롤뷰를 만들어보자

* 기본 예제

```Swift
struct GeometryReaderBootcamp: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<20) { index in
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width: 300, height: 250)
                        .padding()
                }
            }
        }
    }
}
```

    * 기본 예제
    1. 가로로 스크롤되는 뷰 선언
    2. 20개의 둥근 모서리 사각형 나열
> GeometryReader를 사용하여 스크롤뷰에서 도형의 위치에 따라 기울어지는 듯한 애니메이션 효과를 주려고 한다.

* 애니메이션된 스크롤뷰 구현

```Swift
struct GeometryReaderBootcamp: View {
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<20) { index in
                    GeometryReader { proxy in
                        RoundedRectangle(cornerRadius: 20)
                            .rotation3DEffect(Angle(degrees: getPercentage(proxy: proxy) * 40), axis: (x: 0, y: 1, z: 0))
                    }
                    .frame(width: 300, height: 250)
                    .padding()
                }
            }
        }
    }
    
    private func getPercentage(proxy: GeometryProxy) -> CGFloat {
        let maxDistance = UIScreen.main.bounds.width / 2 // 화면 너비의 중앙
        let currentX = proxy.frame(in: .global).midX // proxy로 추적 중인 객체의 수평값의 중앙
        return 1 - (currentX / maxDistance)
    }
}
```

    * 변경점
    1. GeometryReader 블럭 내에 추적 대상을 넣음
    2. .rotation3DEffect() 수정자와 각도 값을 동적으로 계산하기 위한 getPercentage() 함수를 선언
> 추적 중인 도형의 위치가 화면 왼쪽에서부터 오른쪽으로 이동하는 과정이 자연스럽게 로테이션된다.
> proxy.frame(.global)로 전역 공간 상의 도형의 좌표값을 추적, 사용하는 예제이다.
