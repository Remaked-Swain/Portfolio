#  DragGesture
드래그하는 동작을 통해 UI 반응을 표현하고 사용자와 상호작용할 수 있다.

## 카드 넘기기
드래그 제스처를 감지하고 그에 따라 뭔가를 처리하게 할 수 있다.

```Swift
import SwiftUI

struct DragGestureBootcamp: View {
    @State private var offset: CGSize = .zero
    
    var body: some View {
        ZStack {
            VStack {
                Text("")
            }
            
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 300, height: 500)
                .offset(offset)
                .scaleEffect(getScaleAmount())
                .rotationEffect(Angle(degrees: getRotationAmount()))
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            offset = value.translation
                        })
                        .onEnded({ _ in
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        })
            )
        }
    }
    
    func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percent = currentAmount / max
        return 1.0 - min(percent, 0.5) * 0.5
    }
    
    func getRotationAmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset.width
        let percent = currentAmount / max
        let maxAngle: Double = 10
        return Double(percent) * maxAngle
    }
}
```

    * .gesture()
    1. .gesture 수정자를 통해 어떤 제스처를 감지하고 싶다는 것을 알려준다.
    2. 이 문서는 DragGesture를 다룰 것이므로 당연하게도 DragGesture()를 선언했다.
    3. 다음으로 .onChanged, onEnded 메서드를 통해 각각 드래그 제스처의 동작 중, 동작 후의 변화량에 따라 원하는 작업을 할 수 있다.
> 이 예제에서는 드래그 제스처를 통해 도형의 offset을 변경하고 scale, rotation 속성에 영향을 주도록 했다.
> 특히 withAnimation()으로 감싼 범위에 따라 자연스러운 애니메이션 효과도 기대할 수 있다.
> 마치 틴더같은 데이팅앱에서 상대방과의 매칭을 수락하거나 거절하는 카드 넘기기 화면 UI와 비슷하다.

-------------------------------------------------------

## 회원가입 시트
마찬가지로 드래그 제스처를 통해 ZStack 내에서 겹쳐져있는 뷰를 끌어당겨오는 듯한 효과를 만들어보자.

```Swift
import SwiftUI

struct DragGestureBootcamp2: View {
    @State private var startOffsetY: CGFloat = UIScreen.main.bounds.height * 0.83
    @State private var endOffsetY: CGFloat = .zero
    @State private var currentDragOffsetY: CGFloat = .zero
    
    var body: some View {
        ZStack {
            Color.green.opacity(0.3).ignoresSafeArea()
            
            SignUpView()
                .offset(y: startOffsetY)
                .offset(y: currentDragOffsetY)
                .offset(y: endOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            withAnimation(.spring()) {
                                currentDragOffsetY = value.translation.height
                            }
                        })
                        .onEnded({ value in
                            withAnimation(.spring()) {
                                if currentDragOffsetY < -150 {
                                    endOffsetY = -startOffsetY
                                } else if endOffsetY != 0 && currentDragOffsetY > 150 {
                                    endOffsetY = .zero
                                }
                                
                                currentDragOffsetY = .zero
                            }
                        })
                )
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

struct SignUpView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chevron.up")
                .imageScale(.large)
                .padding(.top)
            
            Text("가입하기")
                .font(.headline).fontWeight(.semibold)
            
            Image(systemName: "flame.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            
            Text("드래그 제스처를 통해 ZStack 내에서 겹쳐져 있던 뷰를 끌어당겨오는 듯한 효과를 줄 수 있습니다.\n이 뷰는 회원가입을 위한 계정 생성 단계를 시트처럼 표현한 예제입니다.")
                .multilineTextAlignment(.center)
            
            Text("계정 생성하기!")
                .foregroundColor(.white)
                .font(.headline)
                .padding()
                .padding(.horizontal)
                .background(Color.black.cornerRadius(25))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(30)
    }
}
```

    * 계정 생성 시트
    1. 시트로 나타날 뷰인 SignUpView를 취향껏 꾸며준다.
    2. SignUpView에 드래그 제스처를 붙혀주고 시트 뷰의 시작 위치, 종료 위치, 그리고 드래그 제스처로 추적할 위치를 선언한다.
    3. 시트를 드래그할 때 전체 화면 높이 간에 일정 사이즈가 될 정도로 드래그 되면 시트를 펼친 상태로 고정하거나 닫힌 상태로 고정하는 작업을 만들어주었다.
        3-1. 기종 별로 화면 높이가 다를 수 있으므로 150 을 하드코딩 하지 않고 동적으로 설정해주는 것도 고려해볼만 하다.
