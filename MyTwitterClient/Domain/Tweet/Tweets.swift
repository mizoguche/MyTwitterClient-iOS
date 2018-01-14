//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

class Tweets {
    private var value: [Tweet]
    let session: Session

    var description: String {
        return value.map { t in
            "@\(t.user.screenName.value): \(t.text.value)"
        }.joined(separator: "\n")
    }

    var count: Int {
        return value.count
    }

    var latestId: TweetId {
        return value[0].id
    }

    init(tweets: [Tweet] = [], session: Session = Session.Empty) {
        self.value = tweets
        self.session = session
    }

    subscript(index: Int) -> Tweet {
        get {
            return self.value[index]
        }
    }

    func appendAll(tweets: Tweets) {
        self.value.append(contentsOf: tweets.value)
    }
}
