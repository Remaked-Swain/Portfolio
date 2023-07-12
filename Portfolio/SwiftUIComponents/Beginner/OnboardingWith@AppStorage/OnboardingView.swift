//
//  OnboardingView.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/07/12.
//

import SwiftUI

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

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel()
    
    var body: some View {
        ZStack {
            // Onboarding Course
            ZStack {
                switch vm.onboardingState {
                case 0: welcomeSection
                        .transition(vm.transitionEffect)
                case 1: addNameSection
                        .transition(vm.transitionEffect)
                case 2: addAgeSection
                        .transition(vm.transitionEffect)
                case 3: addGenderSection
                        .transition(vm.transitionEffect)
                default:
                    Text("no scene")
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .background(RadialGradient(colors: [.pink, .orange], center: .topLeading, startRadius: 5, endRadius: UIScreen.main.bounds.height))
    }
}

// MARK: COMPONENTS
extension OnboardingView {
    private var bottomButton: some View {
        Text(vm.bottomButtonText())
            .font(.headline)
            .foregroundColor(.red)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(10)
            .onTapGesture {
                vm.handleNextButtonPressed()
            }
            .animation(nil, value: vm.onboardingState)
            .disabled(vm.isButtonDisabled())
    }
    
    private var welcomeSection: some View {
        VStack(spacing: 40) {
            Text("Onboarding")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Image(systemName: "person.3.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text("Find your match.")
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text("This is the #1 app for finding your match online! In this tutorial we are practicing using @AppStorage and other SwiftUI techniques.")
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.leading)
        .padding()
    }
    
    private var addNameSection: some View {
        VStack(spacing: 20) {
            Text("What's your name?")
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            TextField("Your name here...", text: $vm.userName)
                .font(.headline)
                .frame(height: 55)
                .padding(.horizontal)
                .background(Color.white)
                .cornerRadius(10)
        }
        .multilineTextAlignment(.leading)
        .padding()
    }
    
    private var addAgeSection: some View {
        VStack(spacing: 20) {
            Text("What's your age?")
            
            Text(String(format: "%.0f", vm.age))
            
            Slider(value: $vm.age, in: 18...100, step: 1)
                .tint(.white)
        }
        .font(.largeTitle)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding()
    }
    
    private var addGenderSection: some View {
        VStack(spacing: 20) {
            Text("what's your gender?")
            
            Picker(selection: $vm.gender) {
                Text("Male")
                    .tag("Male")
                Text("Female")
                    .tag("Female")
                Text("Non-Binary")
                    .tag("Non-Binary")
            } label: {
                Text("Select a gender")
            }
            .pickerStyle(.segmented)

        }
        .font(.largeTitle)
        .fontWeight(.semibold)
        .foregroundColor(.white)
        .padding()
    }
}
