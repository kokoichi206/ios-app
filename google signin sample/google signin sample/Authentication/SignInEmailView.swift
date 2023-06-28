//
//  SignInEmailView.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/29.
//

import SwiftUI

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("email or password is empty")
            return
        }

        let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
        print("success!")
        print(returnedUserData)

//        Task {
//            do {
//                let returnedUserData = try await AuthenticationManager.shared.createUser(email: email, password: password)
//                print("success!")
//                print(returnedUserData)
//            } catch {
//                print("Error: \(error)")
//            }
//        }
    }

    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("email or password is empty")
            return
        }

        let returnedUserData = try await AuthenticationManager.shared.signInUser(email: email, password: password)
        print("success!")
        print(returnedUserData)
    }
}

struct SignInEmailView: View {

    @StateObject private var viewModel = SignInEmailViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            TextField("Eamil...", text: $viewModel.email)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            SecureField("Password...", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.4))
                .cornerRadius(10)
            
            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("Error \(error)")
                    }

                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        return
                    } catch {
                        print("Error \(error)")
                    }
                }
            } label: {
                Text("Sigh in")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign in with email")
    }
}

struct SignInEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SignInEmailView(showSignInView: .constant(false))
        }
    }
}
