//
// Created by Michiaki Mizoguchi on 2018/01/08.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import TwitterKit
import Alamofire
import RxSwift
import SwiftyJSON

struct NoDataError: Error {
}

struct TwitterErrorEntity {
    let code: Int
    let message: String

    init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
}

struct TwitterError: Error {
    let errors: [TwitterErrorEntity]?

    init(errors: [TwitterErrorEntity]?) {
        self.errors = errors
    }
}

class TwitterApiClient {
    let config: TWTRAuthConfig

    init(key: ConsumerKeyPair) {
        config = TWTRAuthConfig(consumerKey: key.consumerKey, consumerSecret: key.consumerSecret)
    }

    private func createUrlString(path: String) -> String {
        return "https://api.twitter.com\(path)"
    }

    private func createAuthorizationHeader(session: TWTRSession, method: HTTPMethod, url: String, parameters: Parameters? = nil) -> HTTPHeaders {
        let sign = TWTROAuthSigning(authConfig: config, authSession: session)
        let error = NSErrorPointer(nilLiteral: ())
        let authorization = sign.oAuthEchoHeaders(forRequestMethod: method.rawValue.uppercased(), urlString: url, parameters: parameters, error: error)[TWTROAuthEchoAuthorizationHeaderKey]
        var headers = HTTPHeaders()
        headers["Authorization"] = authorization as? String
        return headers
    }

    func get(path: String, session: TWTRSession, parameters: Parameters? = nil) -> Observable<JSON> {
        return request(path: path, session: session, method: .get, parameters: parameters)
    }

    func post(path: String, session: TWTRSession, parameters: Parameters) -> Observable<JSON> {
        return request(path: path, session: session, method: .post, parameters: parameters)
    }

    private func request(path: String, session: TWTRSession, method: HTTPMethod, parameters: Parameters? = nil) -> Observable<JSON> {
        let url = createUrlString(path: path)
        let headers = createAuthorizationHeader(session: session, method: method, url: url, parameters: parameters)
        return Observable.create { observer in
            Alamofire.request(url, method: method, parameters: parameters, headers: headers).response { response in
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

                    if response.response?.statusCode != nil && response.response!.statusCode > 399 {
                        let errors = json["errors"].array
                        let es = errors.map { js in
                            js.map { json in
                                TwitterErrorEntity(code: json["code"].intValue, message: json["message"].stringValue)
                            }
                        }
                        observer.onError(TwitterError(errors: es))
                        return
                    }
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
