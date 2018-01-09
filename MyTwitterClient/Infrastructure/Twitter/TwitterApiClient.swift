//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import TwitterKit
import Alamofire
import RxSwift
import SwiftyJSON

class NoDataError: Error {
}

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

    func get(path: String, session: TWTRSession) -> Observable<JSON> {
        let url = createUrlString(path: "/1.1/statuses/home_timeline.json")
        let headers = createAuthorizationHeader(url: url, session: session)
        return Observable.create { observer in
            Alamofire.request(url, headers: headers).response { response in
                guard response.error == nil else {
                    observer.onError(response.error!)
                    return
                }

                guard let data = response.data else {
                    observer.onError(NoDataError())
                    return
                }

                do {
                    let json = try JSON(data: data)
                    observer.onNext(json)
                    observer.onCompleted()

                } catch {
                    observer.onError(NoDataError())
                }
            }
            return Disposables.create()
        }
    }
}
