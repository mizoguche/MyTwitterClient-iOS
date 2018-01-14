//
// Created by Michiaki Mizoguchi on 2018/01/14.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift

class GetEarlierTweetsUseCase {
    private let tweetRepository: TweetRepository

    init(tweetRepository: TweetRepository) {
        self.tweetRepository = tweetRepository
    }

    func get(tweets: Tweets) -> Observable<Tweets> {
        return tweetRepository.getEarlier(tweets: tweets)
    }
}
