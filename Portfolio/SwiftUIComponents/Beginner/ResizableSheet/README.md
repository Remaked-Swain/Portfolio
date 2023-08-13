#  ResizableSheet
iOS16+ 부터는 기존 .sheet 수정자의 API를 크게 변경하지 않고도 크기를 커스터마이징 할 수 있는 시트를 만들 수 있게 되었다.

## 기존 Sheet
기존에 사용하던 Sheet 형태부터 복습한다.

```Swift
fileprivate struct SheetView: View {
    var body: some View {
        Text("Hello, world!")
    }
}

import SwiftUI

struct ResizableSheetBootcamp: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        Button("Click here!") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            SheetView()
        }
    }
}
```

    * 기존의 .sheet 수정자 사용
    1. sheet를 트리거링할 상태변수 showSheet: Bool을 선언한다.
    2. 버튼의 액션으로 토글할 수 있도록 연결하고 .sheet 수정자를 통해 트리거링 기준이 될 상태변수와 시트로 표시할 뷰를 선언한다.
    3. 다른 곳에서 SheetView를 선언한 적이 있었던 건지 재선언 에러메시지가 나오길래 찾아서 fileprivate 키워드를 붙혔더니 해결되었다.
> 기존 Sheet 사용의 경우에는 약간의 공간을 남긴(아마도 safeArea) 시트의 뷰가 화면을 덮게 된다.

-------------------------

## PresentationDetents
직역하자면 '표현 고정쇠', 시트의 크기를 어느 수준으로 고정시킬 수 있게 만들어준다.

```Swift
struct ResizableSheetBootcamp: View {
    @State private var showSheet: Bool = false
    
    var body: some View {
        Button("Click here!") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            SheetView()
                .presentationDetents([.large, .medium, .fraction(0.33), .height(UIScreen.main.bounds.height / 4)])
                .presentationDragIndicator(.hidden)
                .interactiveDismissDisabled()
        }
    }
}
```

    * PresentationDetents
    1. 시트로 표시할 뷰에 대하여 .presentationDetents 수정자를 붙힌다.
    2. 표현 고정쇠를 설정할 수 있는 옵션은 크게 네 가지로 구분된다.
        2-1. large -> 일반적인 시트의 크기(약간의 공간을 남긴 풀스크린 커버)
        2-2. medium -> large 크기의 반 정도되는 크기
        2-3. fraction(_ : CGFloat) -> 시트의 높이를 비율값으로 전달 가능, 예를 들어 전체화면의 1/3 정도로만 시트를 나타내고 싶다면 0.33 정도를 전달하면 됨
        2-4. height(_ height: CGFloat) -> 시트의 높이를 픽셀값으로 전달 가능, 예를 들어 전체화면의 1/4 정도로만 시트를 나타내고 싶다면 전체 화면 세로 사이즈를 4등분한 값을 전달하면 됨
    
    * PresentationDragIndicator()
    1. 시트에는 상, 하로 드래그 할 수 있음을 표현하는 인디케이터가 붙어있는데 이를 명시적으로 숨길 수 있음.

    * InteractiveDismissDisabled()
    1. 시트는 인디케이터를 통해 화면 하단 끝까지 내려서 닫을 수 있는데, 이런 대화형 해제 장치를 비활성화하여 사용자가 시트를 내리거나 올리는 동작을 하지 못하게 할 수 있음.

-------------------------

## PresentationDetent's Selection
표현 고정쇠를 뷰 본문 밖에서 상태변수로 관리하면 어떻게 될까?

* detents selection 추가

```Swift
struct ResizableSheetBootcamp: View {
    @State private var showSheet: Bool = false
    @State private var detents: PresentationDetent = .large
    
    var body: some View {
        Button("Click here!") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            SheetView(detents: $detents)
                .presentationDetents([.large, .medium, .fraction(0.1)], selection: $detents)
        }
    }
}

fileprivate struct SheetView: View {
    @Binding var detents: PresentationDetent
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Button("Large state") {
                    detents = .large
                }
                
                Button("Medium state") {
                    detents = .medium
                }
                
                Button("Fraction 0.1 state") {
                    detents = .fraction(0.1)
                }
            }
        }
    }
}
```

* detents set 자체를 상수로 설정해두고 바인딩 걸어서 쓰기

```Swift
struct ResizableSheetBootcamp: View {
    @State private var showSheet: Bool = false
    @State private var detents: PresentationDetent = .large
    
    let selectableDetents: Set<PresentationDetent> = [.large, .medium, .fraction(0.1)]
    
    var body: some View {
        Button("Click here!") {
            showSheet.toggle()
        }
        .sheet(isPresented: $showSheet) {
            SheetView(detents: $detents, selectableDetents: selectableDetents)
                .presentationDetents(selectableDetents, selection: $detents)
//                .presentationDragIndicator(.hidden) // 시트의 드래그 인디케이터를 숨김
//                .interactiveDismissDisabled() // 시트를 화면 하단 끝까지 내려서 시트를 닫는 대화형 해제 장치를 비활성화
        }
    }
}

fileprivate struct SheetView: View {
    @Binding var detents: PresentationDetent
    
    let selectableDetents: Set<PresentationDetent>
    
    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Button("Large state") {
                    detents = .large
                }
                
                Button("Medium state") {
                    detents = .medium
                }
                
                Button("Fraction 0.1 state") {
                    detents = .fraction(0.1)
                }
            }
        }
    }
}
```

    * PresentationDetents selection parameter
    1. selection 파라미터를 추가하고 표현 고정쇠를 뷰 본문 밖에서 상태변수로 만들어서 이 selection에 전달한다.
    2. 상태변수가 되었기 때문에 시트로 표현될 뷰로 바인딩 할 수 있다.
    3. 곧 시트 뷰에서 시트 뷰 자체의 사이즈를 프로그래밍 방식으로 조절할 수 있게 된다.
> 단, 표현 고정쇠 Set으로 선언되지 않은 고정쇠에 대해 시트 뷰에서 대입, 변경하려 했다가는 의도한대로 동작하지 않을 수 있다. 
> 따라서 두 번째 코드처럼, 사용할 표현 고정쇠 Set만을 지원한다는 확실한 코드 표현이나 안전장치를 마련하는 것도 방법이다.
