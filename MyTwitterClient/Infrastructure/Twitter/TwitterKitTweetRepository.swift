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

        var params = Parameters()
        params["count"] = 20.description
        return self.client.get(path: "/1.1/statuses/home_timeline.json", session: twitterSession, parameters: params)
                .map {
                    TwitterMapper.mapToTweets(json: $0, session: session)
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

    func getLatest(tweets: Tweets) -> Observable<Tweets> {
        guard let twitterSession = self.sessionRepository.findBy(session: tweets.session) else {
            return Observable.error(NoSessionError(requestedSession: tweets.session))
        }

        var params = Parameters()
        params["count"] = 20.description
        params["since_id"] = tweets.latestId.value.description
        return self.client.get(path: "/1.1/statuses/home_timeline.json", session: twitterSession, parameters: params)
                .map {
                    let latest = TwitterMapper.mapToTweets(json: $0, session: tweets.session)
                    latest.appendAll(tweets: tweets)
                    return latest
                }
    }

    func getEarlier(tweets: Tweets) -> Observable<Tweets> {
        guard let twitterSession = self.sessionRepository.findBy(session: tweets.session) else {
            return Observable.error(NoSessionError(requestedSession: tweets.session))
        }

        var params = Parameters()
        params["count"] = 20.description
        params["max_id"] = tweets.earliestId.value.description
        return self.client.get(path: "/1.1/statuses/home_timeline.json", session: twitterSession, parameters: params)
                .map {
                    let earlier = TwitterMapper.mapToTweets(json: $0, session: tweets.session)
                    if earlier.count > 1 {
                        tweets.appendWithoutFirst(tweets: earlier)
                    }
                    return tweets
                }
    }
}
