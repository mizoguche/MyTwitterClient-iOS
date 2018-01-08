//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit
import Alamofire

private typealias Element = (key: AnyHashable, value: Any)

class TwitterKitTweetRepository: TweetRepository {
    private let twitter: TWTRTwitter
    private let client: TwitterApiClient

    init(twitter: TWTRTwitter, client: TwitterApiClient) {
        self.twitter = twitter
        self.client = client
    }

    func getHomeTimeline() -> Observable<Tweets> {
        let session = self.twitter.sessionStore.existingUserSessions()[0] as! TWTRSession
        return Observable.create { observer in
            _ = self.client.get(path: "/1.1/statuses/home_timeline.json", session: session)
                    .subscribe(
                            onNext: { jsonArray in
                                print(jsonArray)
                                observer.onCompleted()
                            },
                            onError: { error in
                                observer.onError(error)
                            })
            return Disposables.create()
        }
    }
}
