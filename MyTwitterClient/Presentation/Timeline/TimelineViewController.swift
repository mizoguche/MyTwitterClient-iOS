//
//  ViewController.swift
//  MyTwitterClient
//
//  Created by Michiaki Mizoguchi on 2018/01/03.
//  Copyright © 2018年 Cluster, Inc. All rights reserved.
//

import UIKit
import TwitterKit

class TimelineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        TWTRTwitter.sharedInstance().logIn { [weak self] (session, error) in
            print("login callback")
            if let error = error, let weakSelf = self {
                print(error)
            } else if let session = session, let weakSelf = self {
                print(session.authToken)
                print(session.authTokenSecret)
            }
        }
    }

}
