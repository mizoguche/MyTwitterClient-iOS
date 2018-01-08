//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import Foundation
import RxSwift

struct TweetId {
    let value: Int
}

struct TweetText {
    let value: String
}

struct Tweet {
    let id: TweetId
    let text: TweetText
    let user: User
    let createdAt: Date

    // TODO: implement entities
    // let entities: Entities
}
