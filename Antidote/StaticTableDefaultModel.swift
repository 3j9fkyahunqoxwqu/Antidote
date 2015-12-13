//
//  StaticTableDefaultModel.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 08/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import Foundation

class StaticTableDefaultModel: StaticTableSelectableModel {
    var title: String?
    var value: String?

    var rightButton: String?
    var rightButtonHandler: (Void -> Void)?

    var showArrow: Bool = true

    var userInteractionEnabled: Bool = true
}
