//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift

struct Session {
    static let Empty = Session(screenName: ScreenName(value: ""))

    let screenName: ScreenName
}
