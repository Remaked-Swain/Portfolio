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
 
 - Throws: Person
 
 - Returns: 반환 값에 대한 설명은 이곳에 적기
 
 - Important: 중요한 내용은 이곳에 적기
 
 - Note: 뭔가를 기록해야하는 것은 이곳에 적기 [마크업에 대한 추가 자료 링크](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html#//apple_ref/doc/uid/TP40016497-CH2-SW1)
 
 - Version: 버전 정보에 대해 적기
 
 - Precondition:
 
 - Postcondition:
 
 - Requires:
 
 - Invariant:
 
 - Complexity:
 
 - Warning:
 
 - Copyright:
 
 - Authors:
 
 - Date:
 
 - SeeAlso:
 
 - Since:
 
 - Attention:
 
 - Bug:
 
 - Experiment:
 
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
