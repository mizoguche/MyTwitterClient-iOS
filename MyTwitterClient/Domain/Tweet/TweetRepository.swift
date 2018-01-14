//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift

protocol TweetRepository {
    func getHomeTimeline(session: Session) -> Observable<Tweets>
    func like(tweet: Tweet, session: Session) -> Observable<Void>
    func getLatest(tweets: Tweets) -> Observable<Tweets>
}
