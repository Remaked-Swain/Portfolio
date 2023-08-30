#  Typealias
Typealias 키워드에 대해 알아보자.

## 영화 컨텐츠 앱의 경우
넷플릭스나 왓챠, 티빙처럼 영화 컨텐츠를 다루는 앱이 있다고 가정해보자

* 기본 세팅

```Swift
import SwiftUI

struct MovieModel {
    let title: String
    let director: String
    let rating: Int
}

struct TypealiasBootcamp: View {
    @State private var item: MovieModel = MovieModel(title: "Title", director: "Joe", rating: 5)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("영화 제목: \(item.title)")
            Text("감독 이름: \(item.director)")
            Text("평점: \(item.rating)")
        }
        .frame(width: 200, height: 200)
        .background(.thickMaterial)
        .cornerRadius(24)
    }
}
```

    * 기본 세팅
    1. 영화 앱에서 영화를 표현할 MovieModel 구조체를 선언
    2. 영화에 대한 정보를 간단히 표현하는 뷰가 존재
> 이 영화 컨텐츠 앱에서는 위와 같은 영화 모델을 사용하여 영화 객체를 표현한다.
> 앱 전체에 걸쳐 수백, 수만 번의 영화 모델 사용 기회가 존재할 것이다.
> 만약 앱에 영화 컨텐츠가 아니라 드라마 컨텐츠도 추가하고 싶다고 가정해보자.

* 드라마 컨텐츠 추가

```Swift
struct DramaModel {
    let title: String
    let director: String
    let rating: Double
}

struct TypealiasBootcamp: View {
//    @State private var item: MovieModel = MovieModel(title: "Title", director: "Joe", rating: 5)
    @State private var item: DramaModel = DramaModel(title: "Drama", director: "Emily", rating: 2)
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("영화 제목: \(item.title)")
            Text("감독 이름: \(item.director)")
            Text("평점: \(item.rating)")
        }
        .frame(width: 200, height: 200)
        .background(.thickMaterial)
        .cornerRadius(24)
    }
}
```

    * 드라마 컨텐츠 추가
    1. 동일한 구성의 DramaModel 구조체 추가
> 이제 영화 컨텐츠에 이어 드라마 컨텐츠도 표현할 수 있게 되었다.
> 그러나 영화 컨텐츠를 기반으로 하는 앱 내의 다양한 기능이 있다면, 드라마 컨텐츠도 다룰 수 있도록 다시 새롭게 작성해야 할 것이다.
> 타입이 다르기 때문에 기능을 재사용하는 것이 아니라 새롭게 작성하는 것이다.
> 또한 모델이 바뀐다면 다시 모든 사용처로 이동하여 코드를 수정해 주어야 하는 상황도 생길 것이다.

------------------------------------------------------

## Typealias 키워드 사용
typealias 키워드를 사용해보자

* typealias 키워드 사용으로 얻는 이점
    * 가독성 향상: 길고 복잡한 타입명을 간단한 별칭으로 대체하여 코드 가독성을 높일 수 있다.
    * 유지 보수 용이: 코드 전체에 걸쳐있는 타입명을 변경하고자 할 때 선언부에서 수정하면 typealias로 사용된 모든 곳에서 변경이 적용된다.
    * 추상화: 특정 타입에 대한 의미를 별칭으로 추상화하거나 일반화 할 수 있다.
> 기본적으로 typealias는 기존 데이터 타입의 별칭을 정의하는데 사용되는 키워드이다.
> 따라서 기존 데이터 타입의 기능이나 성질을 바꾸지 않고 이름을 더 편리하고 가독성 높게 유지하는데 사용한다.

* typealias 사용 예제 #1

`typealias DramaModel = MovieModel` 처럼 사용한다.
DramaModel의 생성은 MovieModel의 생성자를 그대로 빌려 쓰기 때문에 동일한 프로퍼티를 갖는다.

* typealias 사용 예제 #2

```Swift
enum GradeType {
    case a, b, c, d, f
}

var db: [String:[String:GradeType]] = [String:[String:GradeType]]()
```

    * 사용 예제 #2
    1. 성적의 종류를 나타내는 GradeType 열거형 존재
    2. 학적부를 나타내는 db 변수는 딕셔너리가 두 번 중첩된 타입으로 선언
> 나는 학적부를 사용할 때마다 `[String:[String:GradeType]]` 타입을 매번 타이핑하기가 싫었다.
> 왜냐하면 어느샌가 버그가 발생해 문제를 살펴보면 항상 타입 명시 부분의 오타가 원인이었기 때문이다.

```Swift
// 생략...

typealias Database = [String:[String:GradeType]]

var db: Database = Database()
```

> typealias 키워드 덕분에 오타로 인한 에러 발생을 현저히 줄이고 내 정신건강도 챙길 수 있게 되었다.
