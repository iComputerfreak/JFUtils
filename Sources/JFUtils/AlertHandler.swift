//
//  AlertHandler.swift
//  
//
//  Created by Jonas Frey on 10.12.21.
//

#if canImport(UIKit)
import Foundation
import UIKit
import SwiftUI

/// Represents a utility struct that displays Alerts
@available(iOS 13.0, *)
public struct AlertHandler {
    /// Triggers an Alert on the top most view controller in the window
    /// - Parameter alert: The Alert Controller
    public static func presentAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            // UI Changes always have to be on the main thread
            DispatchQueue.main.async {
                controller.present(alert, animated: true)
            }
        }
    }
    
    /// Shows a simple alert with a title, a message and an "Ok" button
    public static func showSimpleAlert(title: String?, message: String?) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .default))
        presentAlert(alert: controller)
    }
    
    /// Shows an error with the given title
    public static func showError(title: String?, error: Error) {
        self.showSimpleAlert(title: title ?? "Error", message: error.localizedDescription)
    }
    
    /// Shows an alert with yes/no buttons
    public static func showYesNoAlert(title: String?, message: String?, yesAction: ((UIAlertAction) -> Void)? = nil, noAction: ((UIAlertAction) -> Void)? = nil) {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        controller.addAction(.init(title: "Yes", style: .default, handler: yesAction))
        controller.addAction(.init(title: "No", style: .cancel, handler: noAction))
        presentAlert(alert: controller)
    }
    
    // MARK: - Private functions

    private static func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter { $0.activationState == .foregroundActive }
        .compactMap { $0 as? UIWindowScene }
        .first?.windows.filter { $0.isKeyWindow }.first
    }

    private static func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private static func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }
    
}

#endif
