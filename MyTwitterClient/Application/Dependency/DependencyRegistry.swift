//
// Created by Michiaki Mizoguchi on 2018/01/06.
// Copyright (c) 2018 Cluster, Inc. All rights reserved.
//

import Swinject
import SwinjectStoryboard
import UIKit

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
        defaultContainer.register(ConsumerKeyPair.self) { r in
            ConsumerKeyPair.load()!
        }.inObjectScope(.container)
    }

    static private func setupRepositories() {
    }

    static private func setupUseCases() {
    }

    static private func setupViewModels() {
        defaultContainer.register(TimelineViewModel.self) { r in
            TimelineViewModel()
        }.inObjectScope(.transient)
    }

    static private func setupViewControllers() {
        defaultContainer.storyboardInitCompleted(TimelineViewController.self) { r, controller in
            controller.viewModel = r.resolve(TimelineViewModel.self)
        }
    }
}