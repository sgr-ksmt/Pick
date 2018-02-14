//
//  ColorDataSource.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation
import Pick

extension UIColor: Pickable { }

class ColorDataSource: NSObject, PickableDataSource {
    internal var items: [UIColor] = []
    var selectedItems: [UIColor]

    init(selectedItems: [UIColor] = []) {
        self.items = []
        self.selectedItems = selectedItems
        super.init()
        (0..<100).forEach { _ in items.append(UIColor.random) }
    }

    var numberOfItems: Int {
        return items.count
    }

    func configure(cell: ColorCell, at indexPath: IndexPath) {
        cell.configure(with: items[indexPath.item])
    }

    func pickItems(indexes: [Int]) -> [UIColor] {
        return indexes.map { items[$0] }
    }
}
