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
        return Observable.create { observer in
            guard let twitterSession = self.sessionRepository.findBy(session: session) else {
                observer.onError(NoSessionError(requestedSession: session))
                return Disposables.create()
            }

            _ = self.client.get(path: "/1.1/statuses/home_timeline.json", session: twitterSession)
                    .subscribe(
                            onNext: { json in
                                observer.onNext(self.mapToTweets(json: json))
                                observer.onCompleted()
                            },
                            onError: { error in
                                observer.onError(error)
                            })
            return Disposables.create()
        }
    }

    private func mapToTweets(json: JSON) -> Tweets {
        return Tweets(tweets: json.map { (_, json) in
            mapToTweet(json: json)
        })
    }

    private func mapToTweet(json: JSON) -> Tweet {
        return Tweet(
                id: TweetId(value: json["id"].intValue),
                text: TweetText(value: json["text"].stringValue),
                user: mapToUser(json: json["user"]),
                createdAt: Date()
        )

    }

    private func mapToUser(json: JSON) -> User {
        return User(
                id: UserId(value: json["id"].intValue),
                name: UserName(value: json["name"].stringValue),
                screenName: ScreenName(value: json["screen_name"].stringValue),
                location: json["location"].stringValue,
                url: json["url"].stringValue,
                description: json["description"].stringValue,
                isProtected: json["protected"].boolValue,
                isVerified: json["verified"].boolValue,
                profileImageUrl: json["profile_image_url_https"].stringValue,
                profileBannerUrl: json["profile_background_image_url_https"].stringValue
        )
    }
}
