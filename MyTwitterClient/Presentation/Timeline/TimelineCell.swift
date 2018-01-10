//
// Created by Michiaki Mizoguchi on 2018/01/10.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import UIKit

class TimelineCell: UITableViewCell {
    static let identifier = "TimelineCell"

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var screenName: UILabel!
    @IBOutlet var textBody: UILabel!

    func show(tweet: Tweet) {
        name.text = tweet.user.name.value
        screenName.text = "@\(tweet.user.screenName.value)"
        textBody.text = tweet.text.value
    }
}
