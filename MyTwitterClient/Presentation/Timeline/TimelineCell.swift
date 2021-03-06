//
// Created by Michiaki Mizoguchi on 2018/01/10.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import RxCocoa
import RxSwift

class TimelineCell: UITableViewCell {
    static let identifier = "TimelineCell"
    private let disposeBag = DisposeBag()

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var screenName: UILabel!
    @IBOutlet var textBody: UILabel!
    @IBOutlet var likeButton: UIButton!

    var onLike: Observable<Void>!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.onLike = self.likeButton.rx.tap.map { _ in
        }
    }

    func show(tweet: Tweet) {
        name.text = tweet.user.name.value
        screenName.text = "@\(tweet.user.screenName.value)"
        textBody.text = tweet.text.value
        textBody.sizeToFit()

        Alamofire.request(tweet.user.profileImageUrl).responseImage { [weak self] response in
            if let image = response.result.value {
                self?.profileImageView.image = image
            }
        }
    }
}
