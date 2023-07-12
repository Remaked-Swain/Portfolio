#  Onboarding with @AppStorage & transitions
앱을 처음 시작하는 경우 표시할 온보딩 과정을 작성하고 @AppStorage 를 이용해 그 상태를 저장해두기.

<!-- IntroView -->
```Swift
import SwiftUI

struct IntroView: View {
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {
        ZStack {
            // Background Layer
            RadialGradient(
                gradient: Gradient(colors: [.pink, .orange]),
                center: .topLeading,
                startRadius: 5,
                endRadius: UIScreen.main.bounds.height)
            .ignoresSafeArea()
            
            if currentUserSignedIn {
                Text("Profile View")
            } else {
                Text("Onboarding View")
            }
        }
    }
}
```
> @AppStorage 에 "signed_in" 이라는 키 값으로 유저가 가입한 이력이 있는지 Bool 값으로 저장하고,
> 가입한 이력이 true 라면 바로 유저의 프로파일을 보여주는 뷰가 나타나고 아니라면 가입절차를 거치기 위해 온보딩 페이지가 나타난다.

--------------------

<!-- OnboardingView -->
```Swift
struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            // Onboarding Course
            ZStack {
                switch vm.onboardingState {
                case 0: welcomeSection
                case 1: addNameSection
                case 2: addAgeSection
                case 3: addGenderSection
                default:
                    Text("no")
                }
            }
            
            // Sign in button
            VStack {
                Spacer()
                bottomButton
            }
            .padding()
        }
    }
}
```
Onboarding 과정은 다음과 같다.
1. 환영인사와 간략한 소개 페이지
2. 이름을 설정하는 페이지
3. 나이를 설정하는 페이지
4. 성별을 설정하는 페이지
설정을 마친 단계를 넘어갈 수 있는 버튼도 마련해주었다.

> 이름, 나이, 성별을 설정하기 위해서 TextField, Slider, Picker 를 사용했다.
>> 그렇다면 그 데이터는 어떻게 관리하는 것이 좋을까?

```Swift
class OnboardingViewModel: ObservableObject {
    @AppStorage("name") var currentUserName: String?
    @AppStorage("age") var currentUserAge: Int?
    @AppStorage("gender") var currentUserGender: String?
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    @Published var onboardingState: Int = 0
    @Published var userName: String = ""
    @Published var age: Double = 50
    @Published var gender: String = "Male"
    
    let transitionEffect: AnyTransition = .asymmetric(
        insertion: .move(edge: .trailing),
        removal: .move(edge: .leading)
    )
    
    func bottomButtonText() -> String {
        switch onboardingState {
        case 0: return "Sign Up"
        case 1: return isButtonDisabled() ? "Name must be longer then 3 characters" : "Next"
        case 2: return "Next"
        case 3: return "Get Started"
        default: return "Error"
        }
    }
    
    func isButtonDisabled() -> Bool {
        if onboardingState == 1 {
            guard userName.count >= 4 else { return true }
        }
        return false
    }
    
    func handleNextButtonPressed() {
        withAnimation(.easeInOut) {
            if onboardingState < 3 {
                onboardingState += 1
            } else {
                signIn()
            }
        }
    }
    
    // @AppStorage
    func signIn() {
        currentUserName = userName
        currentUserAge = Int(age)
        currentUserGender = gender
        currentUserSignedIn = true
    }
}
```
강의에서는 몇 개 안되는 소스이기에 뷰 내에서 @State 변수로 관리했지만 나는 따로 모아두는게 예쁠 것 같아서 VM 을 만들어두었다.
> @AppStorage 에 설정사항을 저장할 수 있도록 signIn() 함수를 다음과 같이 만들었다. 최종단계에서 버튼을 누르면 가입절차가 완료될 것이다.
