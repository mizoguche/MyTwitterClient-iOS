//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

struct UserId {
    let value: Int
}

struct UserName {
    let value: String
}

struct ScreenName {
    let value: String
    static let Empty = ScreenName(value: "")
}

struct User {
    let id: UserId
    let name: UserName
    let screenName: ScreenName

    let location: String
    let url: String
    let description: String
    let isProtected: Bool
    let isVerified: Bool
    let profileImageUrl: String
    let profileBannerUrl: String
}
