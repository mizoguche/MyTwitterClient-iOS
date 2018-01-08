//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class LoginUseCase {
    private let sessionRepository: SessionRepository

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    func login() -> Observable<Session> {
        return Observable.create { observer in
            _ = self.sessionRepository.get().subscribe(
                    onNext: { session in
                        observer.onNext(session)
                        observer.onCompleted()
                    },
                    onError: { error in
                        observer.onError(error)
                    }
            )
            return Disposables.create()
        }
    }
}
