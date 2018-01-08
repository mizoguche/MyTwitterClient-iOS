//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import TwitterKit
import Alamofire
import RxSwift

class TwitterApiClient {
    let config: TWTRAuthConfig

    init(key: ConsumerKeyPair) {
        config = TWTRAuthConfig(consumerKey: key.consumerKey, consumerSecret: key.consumerSecret)
    }

    private func createUrlString(path: String) -> String {
        return "https://api.twitter.com\(path)"
    }

    private func createAuthorizationHeader(url: String, session: TWTRSession) -> HTTPHeaders {
        let sign = TWTROAuthSigning(authConfig: config, authSession: session)
        let error = NSErrorPointer(nilLiteral: ())
        let authorization = sign.oAuthEchoHeaders(forRequestMethod: "GET", urlString: url, parameters: nil, error: error)[TWTROAuthEchoAuthorizationHeaderKey]
        var headers = HTTPHeaders()
        headers["Authorization"] = authorization as? String
        return headers
    }

    func get(path: String, session: TWTRSession) -> Observable<Any> {
        let url = createUrlString(path: "/1.1/statuses/home_timeline.json")
        let headers = createAuthorizationHeader(url: url, session: session)
        return Observable.create { observer in
            Alamofire.request(url, headers: headers).responseJSON { response in
                guard response.error != nil else {
                    observer.onError(response.error!)
                    return
                }

                guard response.result.error != nil else {
                    observer.onError(response.result.error!)
                    return
                }

                // I don't know when this force unwrap fails
                observer.onNext(response.result.value!)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
