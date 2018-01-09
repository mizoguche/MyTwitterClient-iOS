//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

class Tweets {
    private let value: [Tweet]

    var description: String {
        return value.map { t in
            "@\(t.user.screenName.value): \(t.text.value)"
        }.joined(separator: "\n")
    }

    init(tweets: [Tweet] = []) {
        self.value = tweets
    }
}
