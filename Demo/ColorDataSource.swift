//
//  ColorDataSource.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import Pick

class ColorDataSource: NSObject, PickableDataSource {
    private var colors: [UIColor] = []
    override init() {
        super.init()
        (0..<100).forEach { _ in colors.append(UIColor.random) }
    }

    var numberOfItems: Int {
        return colors.count
    }

    func configure(cell: ColorCell, at indexPath: IndexPath) {
        cell.configure(with: colors[indexPath.item])
    }

    func pickItems(indexes: [Int]) -> [UIColor] {
        return indexes.map { colors[$0] }
    }
}
