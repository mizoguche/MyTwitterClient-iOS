//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class LoginFailedError: Error {
}

class LoginUseCase {
    private let twitter: TWTRTwitter

    init(twitter: TWTRTwitter) {
        self.twitter = twitter
    }

    func login() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            if self?.twitter.sessionStore.existingUserSessions().count == 0 {
                self?.twitter.logIn { (session, error) in
                    if let error = error {
                        observer.onError(error)
                    }
                }

                observer.onNext(())
                return Disposables.create()
            }

            guard let session = self?.twitter.sessionStore.existingUserSessions()[0] as? TWTRSession else {
                observer.onError(LoginFailedError())
                return Disposables.create()
            }

            print(session)
            observer.onNext(())
            return Disposables.create()
        }
    }
}
