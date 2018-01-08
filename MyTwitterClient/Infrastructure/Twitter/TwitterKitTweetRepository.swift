//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import RxSwift
import TwitterKit
import Alamofire

private typealias Element = (key: AnyHashable, value: Any)

class TwitterKitTweetRepository: TweetRepository {
    private let twitter: TWTRTwitter

    init(twitter: TWTRTwitter) {
        self.twitter = twitter
    }

    func getHomeTimeline() -> Observable<Tweets> {
        let session = self.twitter.sessionStore.existingUserSessions()[0] as? TWTRSession
        return Observable.create { observer in
            let key = ConsumerKeyPair.load()!
            let config = TWTRAuthConfig(consumerKey: key.consumerKey, consumerSecret: key.consumerSecret)
            let sign = TWTROAuthSigning(authConfig: config, authSession: session!)
            let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
            let error = NSErrorPointer(nilLiteral: ())
            let authorization = sign.oAuthEchoHeaders(forRequestMethod: "GET", urlString: url, parameters: nil, error: error)[TWTROAuthEchoAuthorizationHeaderKey]
            var headers = HTTPHeaders()
            headers["Authorization"] = authorization as? String
            Alamofire.request(url, headers: headers).responseJSON { response in
                if let json = response.result.value {
                    print("JSON: \(json)")
                }
            }
            return Disposables.create()
        }
    }
}
