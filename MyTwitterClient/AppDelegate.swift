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

struct ConsumerKeyPair {
    let consumerKey: String
    let consumerSecret: String

    init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private func loadKeys() -> ConsumerKeyPair? {
        if let path = Bundle.main.path(forResource: "Twitter", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                let key = dict["CONSUMER_KEY"] as! String
                let secret = dict["CONSUMER_SECRET"] as! String
                return ConsumerKeyPair(consumerKey: key, consumerSecret: secret)
            }
        }
        return nil
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        DependencyRegistry.setup()

        guard let keys = loadKeys() else {
            print("Your consumer key/secret required in Twitter.plist!")
            return true
        }
        TWTRTwitter.sharedInstance().start(withConsumerKey: keys.consumerKey, consumerSecret: keys.consumerSecret)

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let storyboard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: DependencyRegistry.defaultContainer)
        window.rootViewController = storyboard.instantiateInitialViewController()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }
}
