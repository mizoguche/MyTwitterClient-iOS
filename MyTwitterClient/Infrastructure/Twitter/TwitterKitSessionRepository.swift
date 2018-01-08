//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class LoginFailedError: Error {
}

class TwitterKitSessionRepository: SessionRepository {
    private let twitter: TWTRTwitter

    init(twitter: TWTRTwitter) {
        self.twitter = twitter
    }

    var currentSession: Session? = nil

    func get() -> Observable<Session> {
        return Observable.create { [weak self] observer in
            if self?.twitter.sessionStore.existingUserSessions().count == 0 {
                self?.twitter.logIn { (session, error) in
                    if let error = error {
                        observer.onError(error)
                        return
                    }

                    guard let session = session, let wself = self else {
                        observer.onError(LoginFailedError())
                        return
                    }
                    wself.currentSession = Session(screenName: ScreenName(value: session.userName))
                    observer.onNext(wself.currentSession!)
                    observer.onCompleted()
                }

                observer.onError(LoginFailedError())
                return Disposables.create()
            }

            guard let session = self?.twitter.sessionStore.existingUserSessions()[0] as? TWTRSession else {
                observer.onError(LoginFailedError())
                return Disposables.create()
            }

            if let wself = self {
                wself.currentSession = Session(screenName: ScreenName(value: session.userName))
                observer.onNext(wself.currentSession!)
                observer.onCompleted()
                return Disposables.create()
            }

            observer.onError(LoginFailedError())
            return Disposables.create()
        }
    }
}
