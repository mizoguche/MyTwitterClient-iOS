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

        viewModel.isProcessing.subscribe(onNext: { isProcessing in
            // TODO: Show activity indicator
            print("isProcessing: \(isProcessing)")
        }).disposed(by: disposeBag)

        viewModel.error.subscribe(onNext: { error in
            // TODO: Show alert dialog
            print(error)
        }).disposed(by: disposeBag)

        viewModel.session.filter {
            $0 != nil
        }.subscribe(onNext: { [weak self] _ in
            self?.viewModel.getHomeTimeline()
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.login()
    }
}
