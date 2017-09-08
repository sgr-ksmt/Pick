//
//  ColorCell.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import Pick

final class ColorCell: PickableCell {
    override class var registerMode: RegisterMode {
        return .nib(defaultNib)
    }

    @IBOutlet private weak var label: UILabel!

    func configure(with color: UIColor) {
        backgroundColor = color

        let components = color.cgColor.components
        let r = Int((components?[0] ?? 0.0) * 255.0)
        let g = Int((components?[1] ?? 0.0) * 255.0)
        let b = Int((components?[2] ?? 0.0) * 255.0)
        label.text = "R: \(r)\nG: \(g)\nB: \(b)"
    }
}
