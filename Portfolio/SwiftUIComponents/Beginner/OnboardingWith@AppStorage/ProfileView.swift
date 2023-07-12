//
//  ProfileView.swift
//  Portfolio
//
//  Created by Swain Yun on 2023/07/12.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("name") var currentUserName: String?
    @AppStorage("age") var currentUserAge: Int?
    @AppStorage("gender") var currentUserGender: String?
    @AppStorage("signed_in") var currentUserSignedIn: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                
                Text(currentUserName ?? "User Name")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("\(currentUserAge ?? 0) years old")
                    .font(.title3)
                Text(currentUserGender ?? "Unknown")
                    .font(.title3)
            }
            .padding()
            .foregroundColor(.red)
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            
            VStack {
                Spacer()
                Text("Sign Out")
                    .font(.headline)
                    .foregroundColor(.red)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .onTapGesture {
                        signOut()
                    }
            }
            .padding()
        }
    }
    
    func signOut() {
        currentUserName = nil
        currentUserAge = nil
        currentUserGender = nil
        currentUserSignedIn = false
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
