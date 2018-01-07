//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class TimelineViewModel {
    private var errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        return errorSubject
    }

    func login() {
        let twitter = TWTRTwitter.sharedInstance()
        if twitter.sessionStore.existingUserSessions().count == 0 {
            twitter.logIn { [weak self] (session, error) in
                if let error = error {
                    self?.errorSubject.onNext(error)
                }
            }
            return
        }

        guard let session = twitter.sessionStore.existingUserSessions()[0] as? TWTRSession else {
            return
        }

        print(session.authToken)
        print(session.authTokenSecret)
    }
}
