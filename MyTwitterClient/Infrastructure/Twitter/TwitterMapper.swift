//
// Created by Michiaki Mizoguchi on 2018/01/09.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import SwiftyJSON

class TwitterMapper {
    static func mapToTweets(json: JSON, session: Session) -> Tweets {
        return Tweets(
                tweets: json.map { (_, json) in
                    mapToTweet(json: json)
                },
                session: session)
    }

    static func mapToTweet(json: JSON) -> Tweet {
        return Tweet(
                id: TweetId(value: json["id"].intValue),
                text: TweetText(value: json["text"].stringValue),
                user: mapToUser(json: json["user"]),
                createdAt: Date()
        )
    }

    static func mapToUser(json: JSON) -> User {
        return User(
                id: UserId(value: json["id"].intValue),
                name: UserName(value: json["name"].stringValue),
                screenName: ScreenName(value: json["screen_name"].stringValue),
                location: json["location"].stringValue,
                url: json["url"].stringValue,
                description: json["description"].stringValue,
                isProtected: json["protected"].boolValue,
                isVerified: json["verified"].boolValue,
                profileImageUrl: json["profile_image_url_https"].stringValue,
                profileBannerUrl: json["profile_background_image_url_https"].stringValue
        )
    }
}
