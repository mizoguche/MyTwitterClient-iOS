//
//  ViewController.swift
//  MyTwitterClient
//
//  Created by Michiaki Mizoguchi on 2018/01/03.
//  Copyright © 2018年 Cluster, Inc. All rights reserved.
//

import UIKit
import RxSwift

class TimelineViewController: UIViewController {
    private let disposeBag = DisposeBag()

    var viewModel: TimelineViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.error.subscribe(onNext: { error in
            print(error)
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.login()
    }
}
