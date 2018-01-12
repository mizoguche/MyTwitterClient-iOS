//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit
import Alamofire
import SwiftyJSON

class NoSessionError: Error {
    let requestedSession: Session

    init(requestedSession: Session) {
        self.requestedSession = requestedSession
    }
}

class TwitterKitTweetRepository: TweetRepository {
    private let sessionRepository: TwitterKitSessionRepository
    private let client: TwitterApiClient

    init(client: TwitterApiClient, sessionRepository: TwitterKitSessionRepository) {
        self.client = client
        self.sessionRepository = sessionRepository
    }

    func getHomeTimeline(session: Session) -> Observable<Tweets> {
        guard let twitterSession = self.sessionRepository.findBy(session: session) else {
            return Observable.error(NoSessionError(requestedSession: session))
        }

        return self.client.get(path: "/1.1/statuses/home_timeline.json", session: twitterSession)
                .map {
                    TwitterMapper.mapToTweets(json: $0)
                }
    }

    func like(tweet: Tweet, session: Session) -> Observable<Void> {
        guard let twitterSession = self.sessionRepository.findBy(session: session) else {
            return Observable.error(NoSessionError(requestedSession: session))
        }

        var params = Alamofire.Parameters()
        params["id"] = tweet.id.value.description
        // TODO: update tweet like progress
        return self.client.post(path: "/1.1/favorites/create.json", session: twitterSession, parameters: params)
                .do(onNext: { _ in
                    // TODO: update tweet like status
                    // TODO: update tweet like progress
                })
                .map { _ in
                }
    }
}
