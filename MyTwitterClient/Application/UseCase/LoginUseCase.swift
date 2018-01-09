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
        return self.sessionRepository.get()
    }
}
