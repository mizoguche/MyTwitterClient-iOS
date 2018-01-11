//
//  ViewController.swift
//  MyTwitterClient
//
//  Created by Michiaki Mizoguchi on 2018/01/03.
//  Copyright © 2018年 Cluster, Inc. All rights reserved.
//

import UIKit
import RxSwift

class TimelineViewController: UITableViewController {
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

        viewModel.tweets.subscribe(onNext: { [weak self] tweets in
            self?.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.login()
        let nib = UINib(nibName: "TimelineCell", bundle: Bundle.main)
        self.tableView.register(nib, forCellReuseIdentifier: TimelineCell.identifier)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func tableView(_ table: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.tweetsVar.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimelineCell.identifier) as! TimelineCell
        let tweet = self.viewModel.tweetsVar.value[indexPath.row]
        cell.show(tweet: tweet)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
