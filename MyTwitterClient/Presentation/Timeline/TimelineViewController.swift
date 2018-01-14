//
//  ViewController.swift
//  MyTwitterClient
//
//  Created by Michiaki Mizoguchi on 2018/01/03.
//  Copyright © 2018年 Cluster, Inc. All rights reserved.
//

import UIKit
import RxSwift
import ESPullToRefresh

class TimelineViewController: UITableViewController {
    private let disposeBag = DisposeBag()
    private var subscription = [TimelineCell: [Disposable]]()

    var viewModel: TimelineViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.es.addPullToRefresh { () in
        }

        viewModel.isProcessing.subscribe(onNext: { [weak self] isProcessing in
            if !isProcessing {
                self?.tableView.es.stopPullToRefresh()
            }
        }).disposed(by: disposeBag)

        viewModel.error.subscribe(onNext: { [weak self] error in
            self?.tableView.es.stopPullToRefresh()
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
        subscribeButtons(tweet: tweet, cell: cell)
        return cell
    }

    private func subscribeButtons(tweet: Tweet, cell: TimelineCell) {
        if let subscriptions = subscription[cell] {
            subscriptions.forEach { disposable in
                disposable.dispose()
            }
        }
        subscription[cell] = []
        subscription[cell]?.append(cell.onLike.subscribe(onNext: { [weak self, tweet] _ in self?.viewModel.like(tweet: tweet) }))
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    deinit {
        subscription.forEach { _, value in
            value.forEach { disposable in
                disposable.dispose()
            }
        }
    }
}
