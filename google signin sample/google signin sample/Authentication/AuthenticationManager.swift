//
//  AuthenticationManager.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/29.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid :String
    let email: String?
    let photoUrl: String?
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}

final class AuthenticationManager {

    // singleton pattern?
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> AuthDataResultModel {
        // Check if the user logged in or not LOCALLY!!!
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        return AuthDataResultModel(user: user)
    }

    func signout() throws {
        try Auth.auth().signOut()
    }
}

// MARK: Sign in Email
extension AuthenticationManager {
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authReslt = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authReslt.user)
    }

    func getPovider() throws {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }
        
        for provider in providerData {
            print(provider.providerID)
        }
    }

    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authReslt = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authReslt.user)
    }
}

// MARK: Sign in sso
extension AuthenticationManager {
    @discardableResult
    func signInWithGoogle(token: GoogleSignInResultModel) async throws -> AuthDataResultModel {
        let credential = GoogleAuthProvider.credential(withIDToken: token.idToken, accessToken: token.accessToken)
        return try await signIn(credential: credential)
    }

    func signIn(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authReslt = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authReslt.user)
    }
}
