//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift

protocol TweetRepository {
    func getHomeTimeline() -> Observable<Tweets>
}
