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
    private let likeTweetUseCase: LikeTweetUseCase
    private let getLatestTweetsUseCase: GetLatestTweetsUseCase
    private let getEarlierTweetsUseCase: GetEarlierTweetsUseCase

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

    let tweetsVar = Variable<Tweets>(Tweets())
    var tweets: Observable<Tweets> {
        return tweetsVar.asObservable()
    }

    init(
            loginUseCase: LoginUseCase,
            getHomeTimelineUseCase: GetHomeTimelineUseCase,
            likeTweetUseCase: LikeTweetUseCase,
            getLatestTweetsUseCase: GetLatestTweetsUseCase,
            getEarlierTweetsUseCase: GetEarlierTweetsUseCase
    ) {
        self.loginUseCase = loginUseCase
        self.getHomeTimelineUseCase = getHomeTimelineUseCase
        self.likeTweetUseCase = likeTweetUseCase
        self.getLatestTweetsUseCase = getLatestTweetsUseCase
        self.getEarlierTweetsUseCase = getEarlierTweetsUseCase
    }

    func login() {
        isProcessingVar.value = true
        self.loginUseCase.login().subscribe(
                onNext: { [weak self] session in
                    self?.sessionVar.value = session
                },
                onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                },
                onCompleted: { [weak self] in
                    self?.isProcessingVar.value = false
                }
        ).disposed(by: disposeBag)
    }

    func getHomeTimeline() {
        guard let sess = sessionVar.value else {
            return
        }

        isProcessingVar.value = true
        self.getHomeTimelineUseCase.get(session: sess)
                .subscribe(
                        onNext: { [weak self] tweets in
                            self?.tweetsVar.value = tweets
                        },
                        onError: { [weak self] error in
                            self?.errorSubject.onNext(error)
                        },
                        onCompleted: { [weak self] in
                            self?.isProcessingVar.value = false
                        }
                ).disposed(by: disposeBag)
    }

    func like(tweet: Tweet) {
        guard let sess = sessionVar.value else {
            return
        }
        self.likeTweetUseCase.like(tweet: tweet, session: sess)
                .subscribe(
                        onError: { [weak self] error in
                            self?.errorSubject.onNext(error)
                        }
                ).disposed(by: disposeBag)
    }

    func getLatest() {
        isProcessingVar.value = true
        updateTweets(observable: self.getLatestTweetsUseCase.get(tweets: tweetsVar.value))
    }

    func getEarlier() {
        isProcessingVar.value = true
        updateTweets(observable: self.getEarlierTweetsUseCase.get(tweets: tweetsVar.value))
    }

    private func updateTweets(observable: Observable<Tweets>) {
        return observable.subscribe(
                onNext: { [weak self] tweets in
                    self?.tweetsVar.value = tweets
                },
                onError: { [weak self] error in
                    self?.errorSubject.onNext(error)
                },
                onCompleted: { [weak self] in
                    self?.isProcessingVar.value = false
                }
        ).disposed(by: disposeBag)
    }
}
