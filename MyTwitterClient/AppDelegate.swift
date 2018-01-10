//
//  AppDelegate.swift
//  MyTwitterClient
//
//  Created by Michiaki Mizoguchi on 2018/01/03.
//  Copyright © 2018年 Cluster, Inc. All rights reserved.
//

import UIKit
import TwitterKit
import SwinjectStoryboard

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DependencyRegistry.setup()

        let keys = DependencyRegistry.defaultContainer.resolve(ConsumerKeyPair.self)!
        TWTRTwitter.sharedInstance().start(withConsumerKey: keys.consumerKey, consumerSecret: keys.consumerSecret)

        createRootViewController()

        return true
    }

    private func createRootViewController() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let storyboard = SwinjectStoryboard.create(name: "Timeline", bundle: nil, container: DependencyRegistry.defaultContainer)
        window.rootViewController = storyboard.instantiateInitialViewController()
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
}
