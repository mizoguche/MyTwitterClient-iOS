//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class TimelineViewModel {
    private let disposeBag = DisposeBag()
    private let loginUseCase: LoginUseCase

    private let isProcessingVar = Variable<Bool>(false)
    var isProcessing: Observable<Bool> {
        return isProcessingVar.asObservable()
    }

    private let errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        return errorSubject
    }

    init(loginUseCase: LoginUseCase) {
        self.loginUseCase = loginUseCase
    }

    func login() {
        isProcessingVar.value = true
        self.loginUseCase.login().subscribe(
                onNext: { [weak self] _ in
                    self?.isProcessingVar.value = false
                },
                onError: { [weak self] error in
                    self?.isProcessingVar.value = false
                    self?.errorSubject.onNext(error)
                }
        ).disposed(by: disposeBag)
    }
}
