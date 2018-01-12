//
// Created by Michiaki Mizoguchi on 2018/01/07.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit

class TimelineViewModel {
    private let disposeBag = DisposeBag()
    private let loginUseCase: LoginUseCase
    private let getHomeTimelineUseCase: GetHomeTimelineUseCase

    private let isProcessingVar = Variable<Bool>(false)
    var isProcessing: Observable<Bool> {
        return isProcessingVar.asObservable()
    }

    private let errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        return errorSubject
    }

    private let sessionVar = Variable<Session?>(nil)
    var session: Observable<Session?> {
        return sessionVar.asObservable()
    }

    let tweetsVar = Variable<Tweets>(Tweets(tweets: []))
    var tweets: Observable<Tweets> {
        return tweetsVar.asObservable()
    }

    init(loginUseCase: LoginUseCase, getHomeTimelineUseCase: GetHomeTimelineUseCase) {
        self.loginUseCase = loginUseCase
        self.getHomeTimelineUseCase = getHomeTimelineUseCase
    }

    func login() {
        isProcessingVar.value = true
        self.loginUseCase.login().subscribe(
                onNext: { [weak self] session in
                    self?.isProcessingVar.value = false
                    self?.sessionVar.value = session
                },
                onError: { [weak self] error in
                    self?.isProcessingVar.value = false
                    self?.errorSubject.onNext(error)
                }
        ).disposed(by: disposeBag)
    }

    func getHomeTimeline() {
        guard let sess = sessionVar.value else {
            return
        }
        self.getHomeTimelineUseCase.get(session: sess)
                .subscribe(
                        onNext: { [weak self] tweets in
                            self?.tweetsVar.value = tweets
                        },
                        onError: { [weak self] error in
                            self?.errorSubject.onNext(error)
                        }
                ).disposed(by: disposeBag)
    }

    func like(tweet: Tweet) {
        // TODO: like tweet
        print("like \(tweet)")
    }
}
