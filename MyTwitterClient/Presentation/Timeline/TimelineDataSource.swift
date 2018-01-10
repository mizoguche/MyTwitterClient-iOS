//
// Created by Michiaki Mizoguchi on 2018/01/10.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import UIKit

class TimelineDataSource: NSObject, UITableViewDataSource {
    private let tweets: Tweets

    init(tweets: Tweets) {
        self.tweets = tweets
    }

    func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        print(tweets.count)
        return tweets.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.identifier) as! TimelineCell
        let tweet = tweets[indexPath.row]
        cell.show(tweet: tweet)
        return cell
    }
}
