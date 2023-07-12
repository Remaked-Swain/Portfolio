#  Sheet & FullScreenCover

#### Sheet
sheet 는 일반적으로 화면하단에서 올라오면서 연출되는 뷰로, 다른 정보를 추가로 제공하는 등의 목적으로 자주 사용됨.

<!-- SheetsBootcamp -->
```Swift
struct SheetsBootcamp: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            Button {
                showSheet.toggle()
            } label: {
                Text("Sheet 열기")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10, y: 10)
            }
            .sheet(isPresented: $showSheet) {
                SheetView(showSheet: $showSheet)
            }
        }
    }
}
```
sheet 가 연결된 뷰인데, .sheet(isPresented:) 수정자를 통해 sheet 가 열릴 트리거를 바인딩 해주면 된다.
내용에는 당연하게도 sheet 로 새로 열릴 뷰를 선언하면 된다.

<!-- SheetView -->
```Swift
struct SheetView: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        ZStack {
            Color.yellow
                .ignoresSafeArea()
            
            Button {
                showSheet.toggle()
            } label: {
                Text("Sheet 닫기")
                    .foregroundColor(.yellow)
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10, y: 10)
            }
        }
    }
}
```
상위 뷰에서 sheet 의 트리거로 선언된 상태값을 바인딩해주어 sheet 를 닫고 다시 상위 뷰로 돌아갈 수 있도록 했다.

#### FullScreenCover

```Swift
struct SheetsBootcamp: View {
    @State var showSheet: Bool = false
    
    var body: some View {
        ZStack {
            Color.green
                .edgesIgnoringSafeArea(.all)
            
            Button {
                showSheet.toggle()
            } label: {
                Text("Sheet 열기")
                    .foregroundColor(.green)
                    .font(.headline)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10, y: 10)
            }
            .fullScreenCover(isPresented: $showSheet) {
                SheetView(showSheet: $showSheet)
            }
        }
    }
}
```
FullScreenCover 역시 위처럼 작성할 수 있다. 
sheet 와 다른 점은 sheet 가 팝업됐을 때, 최상단에 약간의 공간을 남기지않고(아마도 safeArea 만한 크기의) 세그웨이가 나타난다는 것이다.

##### 주의
```Swift
.sheet(isPresented: $showSheet) {
    if true {
        sheet1
    } else {
        sheet2
    }
    
    // do not try this at home
}
```
절대 sheet 내에서 조건부 논리식을 통해 다른 sheet이나 fullScreenCover 를 표시하려해선 안된다!
같은 계층 내에서 sheet 는 단 하나만 존재해야한다.
그렇지 않으면 에러가 발생할 것이다!
