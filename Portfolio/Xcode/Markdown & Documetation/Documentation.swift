import Foundation

/**
 [링크는 이렇게](https://github.com/Remaked-Swain)
 
 일반 텍스트
 `곧은 텍스트`
 *이탤릭체*
 **볼드체**
 
 개행은 엔터 두 번 (서로 한 줄 이상 띄우기)
 
 * 별 표시에 한 칸 띄우고 목차 제목을 적으면 됨.
 * 바로 이렇게
 
 ```
 // BackQuote 3개 사이에 코드를 작성할 수 있음
 func someFunction(name: String, age: Int) -> Person
 ```
 
 - Parameters:
    - name: 이름
    - age: 나이
 
 - Throws: 오류를 던질 수 있다면 이곳에 작성하기, 없다면 생략하거나 "없음"으로 표시
 
 - Returns: 반환 값에 대한 설명은 이곳에 적기
 
 - Important: 중요한 내용은 이곳에 적기
 
 - Note: 뭔가를 기록해야하는 것은 이곳에 적기 [마크업에 대한 추가 자료 링크](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497-CH2-SW1)
 
 - Version: 버전 정보에 대해 적기
 
 - Precondition: 호출 또는 사용 전에 인지해야 할 정보를 이곳에 작성 (예: `age` 매개변수는 0보다 크거나 같아야 합니다.)
 
 - Postcondition: 호출 또는 사용 후 인지해야 할 정보를 이곳에 작성 (예: 반환된 `Person` 객체의 `name`, `age` 프로퍼티 값은 입력된 매개변수와 동일해야 합니다.)
 
 - Requires: 이 객체가 필요로 하는 외부 의존성 같은 것이 있다면 이곳에 작성
 
 - Invariant: 이 객체의 동작이 바꾸지 않는 것이 있다면 이곳에 작성
 
 - Complexity: 시간복잡도 또는 공간복잡도에 대한 설명을 이곳에 작성
 
 - Warning: 주의해야할 사항을 안내하고자 하려면 이곳에 작성
 
 - Copyright: 저작권 관련 고지를 하고자 한다면 이곳에 작성
 
 - Authors: 작성자에 대해 알리고자 한다면 이곳에 작성
 
 - Date: 날짜 정보를 이곳에 작성
 
 - SeeAlso: 추가로 참고하기 좋은 내용이 있다면 이곳에 작성
 
 - Since: 문서화 주석의 작성 시점이나 그외의 기간 정보를 이곳에 작성
 
 - Attention: Warning, Note 등과 다른 성격으로 인지하여야 할 사항을 이곳에 작성
 
 - Bug: 알려진 버그를 이곳에 작성
 
 - Experiment: 실험적 기능에 대한 설명을 이곳에 작성
 
 - Remark:
 */
struct Person {
    let name: String
    let age: Int
    
    func someFunction(name: String, age: Int) -> Person {
        return Person(name: name, age: age)
    }
}

/**
 퀵헬프 대상 개체 밑에 작성하는 주석은 Description 부분에 표기됨.
*/
