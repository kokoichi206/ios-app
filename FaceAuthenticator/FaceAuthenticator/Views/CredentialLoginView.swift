//
//  CredentialLoginView.swift
//  FaceAuthenticator
//
//  Created by Takahiro Tominaga on 2022/01/20.
//

import SwiftUI

struct CredentialLoginView: View {
    @EnvironmentObject var authenticationManager: AuthenticationManager
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        VStack(spacing: 40) {
            Title()
            
            TextField("Username", text: $username)
            
            SecureField("Password", text: $password)
            
            PrimaryButton(showImage: false, text: "Login")
                .onTapGesture {
                    authenticationManager.authenticateWithCredentials(username: username, password: password)
                }
        }
        .textFieldStyle(.roundedBorder)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(colors: [.blue,
            .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct CredentialLoginView_Previews: PreviewProvider {
    static var previews: some View {
        CredentialLoginView()
            .environmentObject(AuthenticationManager())
    }
}
