//
//  PaddingLabel.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/25.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

final class PaddingLabel: UILabel {
    let padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }

    override var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += (padding.left + padding.right)
        intrinsicContentSize.height += (padding.top + padding.bottom)
        return intrinsicContentSize
    }
}
