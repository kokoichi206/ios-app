//
//  SignInGoogleHelper.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/30.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
}

final class SignInGoogleHelper {

    @MainActor
    func signIn(viewController: UIViewController? = nil) async throws -> GoogleSignInResultModel {
        guard let topVC = viewController ?? topViewController() else {
            throw URLError(.cannotFindHost)
        }

        // async one.
        // waiting the modal result...
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString

        let token = GoogleSignInResultModel(idToken: idToken, accessToken: accessToken)
        return token
    }

    // https://stackoverflow.com/questions/26667009/get-top-most-uiviewcontroller
    @MainActor
    func topViewController(controller: UIViewController? = nil) -> UIViewController? {

        let controller = controller ?? UIApplication.shared.keyWindow?.rootViewController

        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
