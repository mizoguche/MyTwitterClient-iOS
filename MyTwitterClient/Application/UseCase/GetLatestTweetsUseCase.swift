//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class GetLatestTweetsUseCase {
    private let tweetRepository: TweetRepository

    init(tweetRepository: TweetRepository) {
        self.tweetRepository = tweetRepository
    }

    func get(tweets: Tweets) -> Observable<Tweets> {
        return tweetRepository.getLatest(tweets: tweets)
    }
}
