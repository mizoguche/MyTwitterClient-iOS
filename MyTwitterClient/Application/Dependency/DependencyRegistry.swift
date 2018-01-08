//
// Created by Michiaki Mizoguchi on 2018/01/06.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import UIKit
import TwitterKit

class DependencyRegistry {
    static let defaultContainer = SwinjectStoryboard.defaultContainer

    static func setup() {
        setupInfrastructure()
        setupRepositories()
        setupUseCases()
        setupViewModels()
        setupViewControllers()
    }

    static private func setupInfrastructure() {
        defaultContainer.register(TWTRTwitter.self) { r in
            TWTRTwitter.sharedInstance()
        }.inObjectScope(.container)

        defaultContainer.register(ConsumerKeyPair.self) { r in
            ConsumerKeyPair.load()!
        }.inObjectScope(.container)

        defaultContainer.register(TwitterApiClient.self) { r in
            TwitterApiClient.init(key: r.resolve(ConsumerKeyPair.self)!)
        }.inObjectScope(.container)
    }

    static private func setupRepositories() {
        defaultContainer.register(TwitterKitSessionRepository.self) { r in
            TwitterKitSessionRepository(twitter: r.resolve(TWTRTwitter.self)!)
        }.inObjectScope(.container)

        defaultContainer.register(SessionRepository.self) { r in
            TwitterKitSessionRepository(twitter: r.resolve(TWTRTwitter.self)!)
        }.inObjectScope(.container)

        defaultContainer.register(TweetRepository.self) { r in
            TwitterKitTweetRepository(client: r.resolve(TwitterApiClient.self)!, sessionRepository: r.resolve(TwitterKitSessionRepository.self)!)
        }.inObjectScope(.container)
    }

    static private func setupUseCases() {
        defaultContainer.register(LoginUseCase.self) { r in
            LoginUseCase(sessionRepository: r.resolve(SessionRepository.self)!)
        }.inObjectScope(.container)

        defaultContainer.register(GetHomeTimelineUseCase.self) { r in
            GetHomeTimelineUseCase(tweetRepository: r.resolve(TweetRepository.self)!)
        }.inObjectScope(.container)
    }

    static private func setupViewModels() {
        defaultContainer.register(TimelineViewModel.self) { r in
            TimelineViewModel(loginUseCase: r.resolve(LoginUseCase.self)!, getHomeTimelineUseCase: r.resolve(GetHomeTimelineUseCase.self)!)
        }.inObjectScope(.transient)
    }

    static private func setupViewControllers() {
        defaultContainer.storyboardInitCompleted(TimelineViewController.self) { r, controller in
            controller.viewModel = r.resolve(TimelineViewModel.self)
        }
    }
}