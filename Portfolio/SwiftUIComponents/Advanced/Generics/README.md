#  Generics
Swift에서 제네릭이 무엇인지, 그리고 제네릭을 사용하는 이유에 대해 알아보자.

## .removeAll() 메서드
.removeAll() 메서드로 배열 내의 값을 제거해본다.

* [String] 의 경우

```Swift
import SwiftUI

class GenericsViewModel: ObservableObject {
    @Published var dataArray: [String] = []
    
    init() {
        dataArray = ["one", "two", "three"]
    }
    
    func removeData() {
        dataArray.removeAll()
    }
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            ForEach(vm.dataArray, id: \.self) { item in
                Text(item)
                    .onTapGesture {
                        vm.removeData()
                    }
            }
        }
    }
}
```

    * [String] 의 경우
    1. 뷰에서 "one", "two", "three" 라는 텍스트를 터치하면 뷰 모델의 removeData() 메서드가 호출, 배열 내의 값을 제거
    2. 빈 배열이 되어 뷰에 표시할 데이터가 없으므로 뷰는 빈 화면으로 변경
> 이때 생각해보아야 할 것은 dataArray.removeAll() 라인에서 String 배열의 값을 제거한다고 지정해준 적이 없다는 것이다.

* [Bool] 의 경우

```Swift
class GenericsViewModel: ObservableObject {
    @Published var dataArray: [Bool] = []
    
    init() {
        dataArray = [true, false, true]
    }
    
    func removeData() {
        dataArray.removeAll()
    }
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            ForEach(vm.dataArray, id: \.self) { item in
                Text(item.description)
                    .onTapGesture {
                        vm.removeData()
                    }
            }
        }
    }
}
```

    * [Bool] 의 경우
    1. 뷰에서 "true", "false", "true" 라는 텍스트를 터치하면 뷰 모델의 removeData() 메서드가 호출, 배열 내의 값을 제거
    2. 빈 배열이 되어 뷰에 표시할 데이터가 없으므로 뷰는 빈 화면으로 변경
> 역시 Bool 배열의 값을 제거한다고 지정하지 않고, dataArray.removeAll() 코드를 그대로 사용할 수 있었다.
> 이유는 바로, Array는 일반적인 유형(제네릭 타입)을 허용하기 때문이다.

-----------------------------------------------------

## Generics
제네릭은 타입에 의존하지 않는 '일반적인 타입', '범용 타입'이다. 제네릭을 사용하면 타입에 제한되지 않게 되어 코드를 유연하게 작성하고 사용할 수 있다.

* 제네릭을 사용하지 않은 경우

```Swift
struct StringModel {
    let value: String?
    
    func removeValue() -> StringModel {
        StringModel(value: nil)
    }
}

class GenericsViewModel: ObservableObject {
    @Published var data = StringModel(value: "Hello, World!")
    
    func removeData() {
        data = data.removeValue()
    }
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            Text(vm.data.value ?? "Data not found")
                .onTapGesture {
                    vm.removeData()
                }
        }
    }
}
```

    * 변경점
    1. StringModel이라는 커스텀 구조체 선언
    2. 뷰에는 "Hello, World!" 텍스트가 표시
    3. 이를 터치하면 removeData() 함수를 호출하게 되어 "Data not found" 텍스트로 바뀜
> 만약 뷰에 표현할 내용으로 불리언 값을 다루고 싶어진다면 어떻게 할까?

```Swift
struct StringModel {
    // 생략...
}

struct BoolModel {
    let value: Bool?
    
    func removeValue() -> BoolModel {
        BoolModel(value: nil)
    }
}

class GenericsViewModel: ObservableObject {
    @Published var data = StringModel(value: "Hello, World!")
    @Published var data2 = BoolModel(value: true)
    
    func removeData() {
        data = data.removeValue()
        data2 = data2.removeValue()
    }
}

struct GenericsBootcamp: View {
    @StateObject private var vm = GenericsViewModel()
    
    var body: some View {
        VStack {
            Text(vm.data.value ?? "Data not found")
            Text(vm.data2.value?.description ?? "Data not found")
        }
        .onTapGesture {
            vm.removeData()
        }
    }
}
```

    * 변경점
    1. StringModel과 매우 유사한 형태로 BoolModel 구조체를 선언
    2. 뷰, 뷰 모델 각각 BoolModel을 활용하기 위한 코드를 매우 유사한 형태로 작성
> 이제 불리언 값을 추가로 다룰 수 있게 되었다. 그러나 과연 확장 가능성을 고려했을 때 이것이 좋은 코드인가? 그렇지 않을 것이다.
> 다른 타입의 모델이 추가될 때마다 새로운 구조체를 추가하고 유지해주어야 하기 때문이다.
> 우리가 원하는 것은 이용할 값과 제거하는 함수가 있는 모델일 뿐, 타입이 달라진다고 하여 구조체를 통째로 추가하는 것은 좋지 않다.

* 제네릭을 사용한 경우

```Swift
struct GenericModel<T> {
    let value: T?
    func removeValue() -> GenericModel {
        GenericModel(value: nil)
    }
}

class GenericsViewModel: ObservableObject {
    @Published var data = GenericModel(value: "Hello, World!")
    @Published var data2 = GenericModel(value: true)
    
    func removeData() {
        data = data.removeValue()
        data2 = data2.removeValue()
    }
}
```

    * 변경점
    1. 제네릭 타입 T를 사용하는 GenericModel 선언.
> 제네릭을 사용한 GenericModel 구조체에서 T는 특정한 타입이 아닌, 그저 타입이 들어올 자리를 나타낸다.
> GenericModel이 실제로 사용되어질 때, T는 String인지 Bool인지 대체되는 것이다.
