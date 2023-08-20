#  Weak Self
weak self 키워드와 그것을 왜 사용하는지 알아보자

## Auto Reference Counting (ARC)

* ARC란?
    * ARC는 Swift, Objective-C에서 사용되는 메모리 관리 방식이다.
    * 객체가 생성되면 1이 증가, 참조가 필요없어지면 1이 감소한다.
    * 이 때 Strong Reference Count가 0이 되면 객체는 메모리에서 해제되고, 0이 아니라면 어디선가 참조되고 있는 것을 유지, 객체는 메모리에 상주한다.
    * Swift는 ARC를 통해 메모리 관리를 자동으로 처리하는데, 때로는 개발자가 명시적으로 조치를 취해야 하는 상황이 존재한다.
    
* ARC의 문제점 - Circular Reference (순환 참조)
    * 순환 참조는 두 개의 객체가 서로를 강하게 참조하는 경우 발생한다.
    * 이로 인해 각 객체의 Strong Reference Count가 0이 되지 않아 메모리에서 해제되지 않는 상황이 발생할 수 있다.
    * 이러한 순환 참조 문제를 해결하기 위해서 Weak Reference를 사용하는데, 여기서 [weak self] 키워드가 사용된다.

--------------------------------------

## Strong Reference VS Weak Reference
강한 참조 간 발생하는 문제를 파악하고 약한 참조가 이것을 어떻게 해소시키는지 알아보자

* 기본 세팅

```Swift
import SwiftUI

class NextScreenViewModel: ObservableObject {
    @Published var data: String? = nil
    
    init() {
        print("Initialized")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount + 1, forKey: "count")
        getData()
    }
    
    deinit {
        print("Deinitialized")
        let currentCount = UserDefaults.standard.integer(forKey: "count")
        UserDefaults.standard.set(currentCount - 1, forKey: "count")
    }
    
    func getData() {
        data = "New Data"
    }
}

fileprivate struct NextScreen: View {
    @StateObject var vm = NextScreenViewModel()
    
    var body: some View {
        Text("Subview")
            .font(.largeTitle)
            .foregroundColor(.red)
        
        if let data = vm.data {
            Text(data)
        }
    }
}

struct WeakSelfBootcamp: View {
    @AppStorage("count") var count: Int?
    
    init() {
        count = 0
    }
    
    var body: some View {
        NavigationStack {
            NavigationLink("Navigate") {
                NextScreen()
                    .navigationTitle("Screen 1")
            }
            .navigationTitle("Upper View")
        }
        .overlay(
            Text("\(count ?? 0)")
                .padding()
                .background(Color.green.cornerRadius(14))
            , alignment: .topTrailing
        )
    }
}
```

    * 기본 세팅
    1. 상위 뷰에는 하위 뷰로 이동할 수 있는 네비게이션 링크가 있음
    2. 하위 뷰가 표시되면 뷰 모델이 생성되었다는 출력물과 함께 "New Data" 라는 텍스트 등장
    3. UserDefault를 이용하여 ARC가 동작하는 것과 같은 원리로 화면에 참조 상태를 볼 수 있음
> 상위 뷰 등장 시 카운트는 0으로 시작한다.
> 하위 뷰로 이동하면 하위 뷰 객체가 생성되어 카운트가 1 증가하게 된다.
> 하위 뷰를 빠져나오면 하위 뷰 객체가 소멸되어 카운트가 1 감소하게 된다.
> 현재 코드로는 카운트가 1을 초과할 일이 없다. 그러나 다음의 코드는 어떨까?

* 지연 작업 추가

```Swift
class NextScreenViewModel: ObservableObject {
    // 생략...
    
    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 100) {
            self.data = "New Data"
        }
    }
}
```

    * 변경점
    1. 하위 뷰 모델의 생성과 함께 호출되는 메서드를 100초의 지연 후에 이루어지도록 함
> 이 경우에는 비동기 작업 때문에 self.data 캡쳐에 강한 참조가 발생한다.
> 왜냐하면 하위 뷰를 빠져나가게 되어도 100초라는 간격 사이에 getData() 메서드가 완료되지 않았으므로 안전하게 비동기 작업이 이루어질 수 있도록
> 하위 뷰 모델 '자신(self)'에 대한 참조를 강하게 유지해야하기 때문이다.
> 이미 하위 뷰를 빠져나온 상황에서 하위 뷰에 표시할 텍스트를 위해 뷰 모델 레퍼런스와 비동기 작업을 살려놓아야 한다는 것은 비효율적이다.

* Weak self 키워드 사용

```Swift
class NextScreenViewModel: ObservableObject {
    // 생략...
    
    func getData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 100) { [weak self] in
            self?.data = "New Data"
        }
    }
}
```

    * 변경점
    1. 메서드의 비동기 작업으로 인한 자신의 캡쳐를 약하게 이루어지도록 만듦
> 이렇게 하면 메서드의 완료 후 종료 여부와는 상관없다는 의미가 된다.
> 즉 getData() 메서드가 완료되지 않아도 deinit() 해제자를 통해 하위 뷰의 메모리 해제가 이루어진다.
> 객체를 필히 살려두지 않아도 된다는 것, 이것이 약한 참조이다.
> 인터넷으로부터 데이터를 받아오는 등의 작업은 때때로 시간이 걸릴 수도 있고 그 과정에서 다른 변수가 발생하여 작업이 정상적으로 완료되지 않을 수 있다.
> 이럴 경우 약한 참조를 사용하여 상황에 맞게 객체를 유지하거나 메모리를 해제하여 앱의 동작 효율을 올릴 수 있다.
