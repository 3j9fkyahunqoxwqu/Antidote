//
//  StaticTableButtonCell.swift
//  Antidote
//
//  Created by Dmytro Vorobiov on 02/12/15.
//  Copyright © 2015 dvor. All rights reserved.
//

import UIKit

private struct Constants {
    static let VerticalOffset = 12.0
}

class StaticTableButtonCell: StaticTableBaseCell {
    private var label: UILabel!

    override func setupWithTheme(theme: Theme, model: StaticTableBaseModel) {
        super.setupWithTheme(theme, model: model)

        guard let buttonModel = model as? StaticTableButtonModel else {
            assert(false, "Wrong model \(model) passed to cell \(self)")
            return
        }

        label.text = buttonModel.title
        label.textColor = theme.colorForType(.NormalText)
    }

    override func createViews() {
        super.createViews()

        label = UILabel()
        customContentView.addSubview(label)
    }

    override func installConstraints() {
        super.installConstraints()

        label.snp_makeConstraints{ (make) -> Void in
            make.left.right.equalTo(customContentView)
            make.top.equalTo(customContentView).offset(Constants.VerticalOffset)
            make.bottom.equalTo(customContentView).offset(-Constants.VerticalOffset)
        }
    }
}
