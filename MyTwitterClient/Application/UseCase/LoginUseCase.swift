//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift

class LoginUseCase {
    private let sessionRepository: SessionRepository

    init(sessionRepository: SessionRepository) {
        self.sessionRepository = sessionRepository
    }

    func login() -> Observable<Void> {
        return Observable.create { [weak self] observer in
            _ = self?.sessionRepository.get().subscribe(
                    onNext: { session in
                        print("logged in as @\(session.screenName.value)")
                        observer.onNext(())
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
