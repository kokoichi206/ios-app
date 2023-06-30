//
//  AuthenticationView.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/28.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViweModel: ObservableObject {

    func signInGoogle() async throws {

        let helper = SignInGoogleHelper()
        let token = try await helper.signIn()
        try await AuthenticationManager.shared.signInWithGoogle(token: token)
    }
}

struct AuthenticationView: View {

    @StateObject private var viewModel = AuthenticationViweModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            NavigationLink {
                SignInEmailView(showSignInView: $showSignInView)
            } label: {
                Text("Sigh in with email")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            
            GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .wide, state: .normal)) {
                Task {
                    do {
                        try await viewModel.signInGoogle()
                        showSignInView = false
                    } catch {
                        print("ERROR \(error)")
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Sign in")
    }
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AuthenticationView(showSignInView: .constant(false))
        }
    }
}
