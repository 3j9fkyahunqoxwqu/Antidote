//
//  ProfileMainController.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 02/11/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

protocol ProfileMainControllerDelegate: class {
    func profileMainControllerLogout(controller: ProfileMainController)
}

class ProfileMainController: StaticTableController {
    weak var delegate: ProfileMainControllerDelegate?

    init(theme: Theme, submanagerUser: OCTSubmanagerUser) {
        let avatar = StaticTableAvatarModel()
        let logoutButton = StaticTableButtonModel()

        super.init(theme: theme, model: [
            [
                avatar,
                logoutButton,
            ]
        ])

        // avatar.avatar = 
        avatar.userInteractionEnabled = false

        logoutButton.title = String(localized: "logout_button")
        logoutButton.didSelectHandler = logout
    }

    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileMainController {
    func logout() {
        delegate?.profileMainControllerLogout(self)
    }
}
