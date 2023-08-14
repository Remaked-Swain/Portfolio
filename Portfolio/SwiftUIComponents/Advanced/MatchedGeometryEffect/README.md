#  MatchedGeometryEffect
matchedGeometryEffect 수정자를 사용하여 도형과 다른 도형이 마치 연결되어 있는 듯한 애니메이션 효과를 만들어낼 수 있다.

## 도형을 화면에서 위, 아래로 이동시키는 예제
만약 도형을 화면을 기준으로 위, 아래로 이동시키는 동작을 원한다고 가정해보자.

* 비교적 단순한 방법

```Swift
struct MatchedGeometryEffectBootcamp: View {
    @State private var isClicked: Bool = false
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 100, height: 100)
                .offset(y: isClicked ? UIScreen.main.bounds.height * 0.8 : 0)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isClicked.toggle()
                    }
                }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
```

    * 비교적 단순한 방법
    1. 위, 아래로 동작하는 상태 값을 추적하기 위해 isClicked: Bool 상태 변수를 선언
    2. 도형을 탭하면 애니메이션 효과와 함께 도형이 이동하게 됨
> 이 경우에는 offset_y의 값을 모든 기기, 모든 상황에 동일하게 동작하도록 만들기 어렵다.
> Spacer()를 제거한다던지, 프레임을 맞춰준다던지에 따라 다를 것이고 특히 원하는 지점으로 정확히 이동시키기려면 복잡한 계산이 필요해진다.

* 일치 기하학 효과를 사용한 방법

```Swift
struct MatchedGeometryEffectBootcamp: View {
    @State private var isClicked: Bool = false
    
    @Namespace private var roundedRectangle
    
    var body: some View {
        VStack {
            if !isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 100, height: 100)
                    .matchedGeometryEffect(id: "id", in: roundedRectangle)
            }
            
            Spacer()
            
            if isClicked {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 100, height: 100)
                    .matchedGeometryEffect(id: "id", in: roundedRectangle)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onTapGesture {
            withAnimation(.easeInOut) {
                isClicked.toggle()
            }
        }
    }
}
```

    * 일치 기하학 효과를 사용한 방법
    1. 상태변수 isClicked로 탭제스처에 반응하도록 사용하는 것은 동일함
    2. matchedGeometryEffect 수정자를 사용하는데 도형을 식별하기 위한 id값과 그것이 보관될 이름공간이 필요
        2-1. 이름공간은 위의 코드처럼 @Namespace 래퍼와 변수명으로 선언한다.
        2-2. id값은 대상 객체를 아우를 수 있는 이름으로 정하는 것이 좋다. (이 예제에서는 단순하게 "id"로 하였음.)
    3. 상태변수 isClicked의 값에 맞춰서 표현할 수 있도록 적절한 조건문으로 감싸줌.
> 이 경우에는 VStack 내에 존재하는 둥근사각형 두 개가, 'id'라는 식별값을 가진 하나의 도형으로 인식되게 되는 효과가 있다.
> 결국에 isClicked가 변경되면 조건문이 서로 반대로 바뀌게 되고, 도형은 서로 깜빡이면서 나타나는게 아니라 마치 하나의 몸으로 위치만을 바꾸게 되어 이동하는 것처럼 보인다.

------------------------------------

## 커스텀 탭바 예제
내가 matchedGeometryEffect 수정자를 주로 사용하는 때는 탭바나 메뉴와 같은 Picker식 UI에 자연스러운 애니메이션을 넣을 때이다.

```Swift
struct MatchedGeometryEffectBootcamp: View {
    @State private var selectedCategory: String = "Home"
    @Namespace private var namespace
    
    private let categories: [String] = ["Home", "Popular", "Saved"]
    
    var body: some View {
        HStack {
            ForEach(categories, id: \.self) { category in
                ZStack {
                    if selectedCategory == category {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.green.opacity(0.3))
                            .matchedGeometryEffect(id: "id", in: namespace)
                    }
                    
                    Text(category)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedCategory = category
                    }
                }
            }
        }
        .padding()
    }
}
```

> 이렇게 일치 기하학 효과를 사용하여 아주 자연스러운 애니메이션 효과를 직접 만들 수 있다.
