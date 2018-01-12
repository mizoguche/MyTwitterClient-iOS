//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class LikeTweetUseCase {
    private let tweetRepository: TweetRepository

    init(tweetRepository: TweetRepository) {
        self.tweetRepository = tweetRepository
    }

    func like(tweet: Tweet, session: Session) -> Observable<Void> {
        return tweetRepository.like(tweet: tweet, session: session)
    }
}
