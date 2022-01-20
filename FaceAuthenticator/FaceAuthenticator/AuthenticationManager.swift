//
//  AuthenticationManager.swift
//  FaceAuthenticator
//
//  Created by Takahiro Tominaga on 2022/01/20.
//

import Foundation
import LocalAuthentication

class AuthenticationManager: ObservableObject {
    // https://developer.apple.com/documentation/localauthentication/lacontext
    private(set) var context = LAContext()
    
    // https://developer.apple.com/documentation/localauthentication/lacontext/2867583-biometrytype
    @Published private(set) var biometryType: LABiometryType = .none
    private(set) var canEvaluatePolicy = false
    
    init() {
        getBiometryType()
    }
    
    func getBiometryType() {
        canEvaluatePolicy = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        biometryType = context.biometryType
    }
}
