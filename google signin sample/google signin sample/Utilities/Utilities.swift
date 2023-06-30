//
//  Utilities.swift
//  google signin sample
//
//  Created by Takahiro Tominaga on 2023/06/29.
//

import Foundation
import UIKit

final class Utilities {

    static let shared = Utilities()
    private init() {}

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
