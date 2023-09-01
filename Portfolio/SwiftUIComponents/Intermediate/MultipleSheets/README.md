# Multiple Sheets from a single view
동일 계층에서 .sheet 수정자는 단 하나만 존재해야한다. 그렇다면 하나의 sheet을 재사용해서 다양한 분기를 이루는 방법은 무엇이 있을지 알아보자.

## `.sheet()` 수정자에 대한 논리적 분기와 시트 모달 방법

* 기본 세팅
```Swift
import SwiftUI

struct RandomModel: Identifiable {
    let id = UUID().uuidString
    let title: String
}

struct MultipleSheetsBootcamp: View {
    @State private var selectedModel: RandomModel = RandomModel(title: "초기 제목")
    @State private var showSheet: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Button("버튼 #1") {
                selectedModel = RandomModel(title: "제목 #1")
                showSheet.toggle()
            }
            
            Button("버튼 #2") {
                selectedModel = RandomModel(title: "제목 #2")
                showSheet.toggle()
            }
        }
        .sheet(isPresented: $showSheet) {
            SheetScreen(selectedModel: selectedModel)
        }
    }
}

fileprivate struct SheetScreen: View {
    let selectedModel: RandomModel
    
    var body: some View {
        Text(selectedModel.title)
            .font(.largeTitle)
    }
}
```

    * 기본 세팅
    1. SheetScreen(이하 하위 뷰 또는 시트)에서 다뤄질 데이터로 RandomModel이라는 구조체를 선언
    2. MultipleSheetsView(이하 상위 뷰)에 존재하는 버튼 두 개를 이용해 각각 다른 데이터를 갖는 시트로 분기할 예정
> 이 코드는 에러메시지의 태클 없이 쉽게 작성되었고 또 우리가 이해하기도 쉽다.
> 그러나 가끔 버튼을 눌러 시트로 이동하면 각기 알맞은 데이터가 아니라 "초기 제목" 이라는 초기값이 나타날 때가 있다.
> 이렇게 동일 계층에서 논리적인 `.sheet()` 분기에 따른 버그는 스택오버플로에서도 많이 다뤄진 문제이다.
> 원인에 대해서는 다양한 의견을 찾을 수 있었지만 이번 예제의 경우에 내가 생각하기에는,
    * **추측**: 버그 발생 원인
    1. 상위 뷰가 나타날 때 `.sheet()` 수정자도 로드 되었으나 아직 하위 뷰의 호출(또는 생성)이 없는 단계임
    2. 따라서 현재 데이터는 "초기 제목"이라는 값으로 초기화 상태
    3. 하위 뷰에 `selectedModel` 값을 전달하는 것은 하위 뷰가 생성될 때 이루어짐
    4. 따라서 최초에 하위 뷰로 이동하려고 시도할 시 만큼은 초기값이 나타나는 것으로 추츠
> 따라서 동일 계층에 `.sheet()` 수정자는 단 하나만 존재해야하며 그 시트에 논리적인 분기를 기대해서는 안된다고 한다.
> 그러면 최대한 코드를 재사용해서 다양한 시트를 구성하려면 어떻게 해야 할까?
