//
//  AppCoordinator.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 07/10/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var activeCoordinator: TopCoordinatorProtocol!
    private var theme: Theme

    init(window: UIWindow) {
        self.window = window

        let filepath = NSBundle.mainBundle().pathForResource("default-theme", ofType: "yaml")!
        let yamlString = try! NSString(contentsOfFile:filepath, encoding:NSUTF8StringEncoding) as String

        theme = try! Theme(yamlString: yamlString)
        applyTheme(theme)
    }
}

// MARK: CoordinatorProtocol
extension AppCoordinator: TopCoordinatorProtocol {
    func startWithOptions(options: CoordinatorOptions?) {
        // if UserDefaultsManager().isUserLoggedIn {
        //     activeCoordinator = createActiveSessionCoordinator()
        // }
        // else {
            activeCoordinator = createLoginCoordinator()
        // }

        activeCoordinator.startWithOptions(nil)
    }

    func handleLocalNotification(notification: UILocalNotification) {
        activeCoordinator.handleLocalNotification(notification)
    }

    func handleInboxURL(url: NSURL) {
        activeCoordinator.handleInboxURL(url)
    }
}

extension AppCoordinator: ActiveSessionCoordinatorDelegate {
    func activeSessionCoordinatorDidLogout(coordinator: ActiveSessionCoordinator, importToxProfileFromURL: NSURL?) {
        UserDefaultsManager().isUserLoggedIn = false

        let coordinator = createLoginCoordinator()

        activeCoordinator = coordinator
        activeCoordinator.startWithOptions(nil)

        if let url = importToxProfileFromURL {
            coordinator.handleInboxURL(url)
        }
    }

    func activeSessionCoordinatorDeleteProfile(coordinator: ActiveSessionCoordinator) {
        let userDefaults = UserDefaultsManager()
        let profileManager = ProfileManager()

        let name = userDefaults.lastActiveProfile!

        do {
            try profileManager.deleteProfileWithName(name)

            userDefaults.lastActiveProfile = nil
            userDefaults.isUserLoggedIn = false

            activeCoordinator = createLoginCoordinator()
            activeCoordinator.startWithOptions(nil)
        }
        catch let error as NSError {
            handleErrorWithType(.DeleteProfile, error: error)
        }
    }

    func activeSessionCoordinatorRecreateCoordinatorsStack(coordinator: ActiveSessionCoordinator, options: CoordinatorOptions) {
        activeCoordinator = createActiveSessionCoordinator()
        activeCoordinator.startWithOptions(options)
    }
}

extension AppCoordinator: LoginCoordinatorDelegate {
    func loginCoordinatorDidLogin(coordinator: LoginCoordinator, manager: OCTManager) {
        UserDefaultsManager().isUserLoggedIn = true

        activeCoordinator = createActiveSessionCoordinator(withManager: manager)
        activeCoordinator.startWithOptions(nil)
    }
}

// MARK: Private
private extension AppCoordinator {
    func applyTheme(theme: Theme) {
        let linkTextColor = theme.colorForType(.LinkText)

        UIButton.appearance().tintColor = linkTextColor
        UISwitch.appearance().onTintColor = linkTextColor
        UINavigationBar.appearance().tintColor = linkTextColor
    }

    func createActiveSessionCoordinator(withManager manager: OCTManager? = nil) -> ActiveSessionCoordinator {
        let coordinator: ActiveSessionCoordinator

        if let manager = manager {
            coordinator = ActiveSessionCoordinator(theme: theme, window: window, toxManager: manager)
        }
        else {
            let profile = UserDefaultsManager().lastActiveProfile!
            coordinator = ActiveSessionCoordinator(theme: theme, window: window, profileName: profile)
        }

        coordinator.delegate = self
        return coordinator
    }

    func createLoginCoordinator() -> LoginCoordinator {
        let coordinator = LoginCoordinator(theme: theme, window: window)
        coordinator.delegate = self

        return coordinator
    }
}

