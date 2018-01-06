//
// Created by Michiaki Mizoguchi on 2018/01/06.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import Foundation

class ConsumerKeyPair {
    let consumerKey: String
    let consumerSecret: String

    private init(consumerKey: String, consumerSecret: String) {
        self.consumerKey = consumerKey
        self.consumerSecret = consumerSecret
    }

    static func load() -> ConsumerKeyPair? {
        if let path = Bundle.main.path(forResource: "Twitter", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) {
                let key = dict["CONSUMER_KEY"] as! String
                let secret = dict["CONSUMER_SECRET"] as! String
                return ConsumerKeyPair(consumerKey: key, consumerSecret: secret)
            }
        }

        print("Your consumer key/secret required in Twitter.plist!")
        return nil
    }
}
