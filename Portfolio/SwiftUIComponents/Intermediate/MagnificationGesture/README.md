#  Magnification Gesture
줌인, 줌아웃이란 이름으로 더 익숙한 '확대 제스처'에 대해 알아보자.

## 기본 예제
뷰를 대상으로 확대 제스처를 사용

* 변화량 추적

```Swift
import SwiftUI

struct MagnificationGestureBootcamp: View {
    @State private var currentAmount: CGFloat = 0
    
    var body: some View {
        Text("Hello, World!")
            .font(.title)
            .padding(40)
            .background(Color.green.opacity(0.3).cornerRadius(14))
            .scaleEffect(1 + currentAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentAmount = value - 1
                    }
            )
    }
}
```

    * 변화량 추적
    1. 텍스트에 여백을 포함한 배경을 입힘
    2. 확대 제스처를 연결
> .scaleEffect 계산 시 1을 더해주는 이유는 최초의 크기가 100%, 즉 1 값으로 시작하기 때문이다.
> 또한 currentAmount 계산 시 1을 빼주는 이유는 현재 크기 값에 대한 변화량을 얻어야하기 때문이다.

* 변경된 사이즈 저장

```Swift
struct MagnificationGestureBootcamp: View {
    @State private var currentAmount: CGFloat = 0
    @State private var lastAmount: CGFloat = 0
    
    var body: some View {
        Text("Hello, World!")
            // 생략...
            
            .scaleEffect(1 + currentAmount + lastAmount)
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        currentAmount = value - 1
                    }
                    .onEnded { value in
                        lastAmount += currentAmount
                        currentAmount = 0
                    }
            )
    }
}
```

    * 변경된 사이즈 저장
    1. 변경된 사이즈를 저장할 lastAmount 상태 변수 선언
    2. 제스처 조작 종료 시 변경된 사이즈를 저장
> 이제 .onEnded() 메서드를 추가하여 제스처 조작으로 바뀐 사이즈를 저장할 수 있게 되었다.
> 이전 제스처로 변경한 값을 저장해두고 최초 크기와 비교하는 계산법을 통해 다음 제스처 조작 시에 그 크기에서 변경이 시작될 수 있도록 한다.

-------------------------------------------------------

## 인스타그램 클론 예제
인스타그램 피드를 본따 확대 제스처를 적용해보자

* 기본 세팅

```Swift
struct MagnificationGestureBootcamp: View {
    @State private var currentAmount: CGFloat = 0
    
    var body: some View {
        VStack {
            HStack {
                Circle().frame(width: 35, height: 35)
                Text("Swain Yun")
                Spacer()
                Image(systemName: "ellipsis")
            }
            
            Rectangle().frame(height: 300)
            
            HStack {
                Image(systemName: "heart.fill")
                Image(systemName: "text.bubble.fill")
                Spacer()
            }
            .font(.headline)
            
            Text("This looks like Instagram feed!")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top)
        }
        .padding()
    }
}
```

    * 기본 세팅
    1. 인스타그램 피드처럼 꾸미기
> Rectangle() 부분을 인스타그램 피드에서 사진이 들어가는 곳이라고 생각하고 진행한다.

* 확대 제스처 연결

```Swift
struct MagnificationGestureBootcamp: View {
    @State private var currentAmount: CGFloat = 0
    
    var body: some View {
        VStack {
            // 생략...
            
            Rectangle().frame(height: 300)
                .scaleEffect(1 + currentAmount)
                .gesture(
                    MagnificationGesture()
                        .onChanged { value in
                            currentAmount = value - 1
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                currentAmount = 0
                            }
                        }
                )
            
            // 생략...
        }
        .padding()
    }
}
```

    * 확대 제스처 연결
    1. Rectangle()에 대하여 .scaleEffect 와 .gesture 수정자로 확대 제스처에 대해 적절한 처리
> .onChange() 메서드로 currentAmount를 변경, 변화량에 맞춰 사진을 줌인, 줌아웃 할 수 있다.
> 또한 .onEnded() 메서드로 확대 제스처가 끝날 때, 즉 손가락을 뗄 때 자연스러운 애니메이션과 함께 원래 크기로 돌아가도록 만들었다.

* 실제 인스타그램 피드와 다른 점
1. 실제 인스타그램 피드에서는 줌인 기능만 있고 줌아웃 하지는 못한다.
2. 사진을 줌인 시 그 확대비율에 따라 주변 화면이 검게 페이드아웃되는 효과가 있다.
3. 사진을 드래그하여 일시적으로 이동시킬 수 있다.
