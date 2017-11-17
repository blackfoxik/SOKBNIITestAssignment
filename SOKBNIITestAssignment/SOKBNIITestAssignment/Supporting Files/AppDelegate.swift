//
//  AppDelegate.swift
//  SOKBNIITestAssignment
//
//  Created by Anton on 15.11.17.
//  Copyright © 2017 Anton. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: DefaultsKeys.MAIN_STORYBOARD_NAME, bundle: nil)
        self.window?.rootViewController = storyboard.instantiateInitialViewController()
        
        if let splitViewController = self.window?.rootViewController as? UISplitViewController,
            let navigationController = splitViewController.viewControllers.last  as? UINavigationController {
            navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
            navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
            splitViewController.delegate = self
            splitViewController.preferredDisplayMode = .allVisible
        }
        self.window?.makeKeyAndVisible()
        return true
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        guard let secondaryAsNav = secondaryViewController as? UINavigationController,
            let topAsDetail = secondaryAsNav.topViewController as? TestObjectDetailInfoViewController,
            topAsDetail.testObject == nil else {return false}
        return true
    }
    
}
extension DefaultsKeys {
    static let MAIN_STORYBOARD_NAME = "Main"
}
