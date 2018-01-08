//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit
import Alamofire

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
