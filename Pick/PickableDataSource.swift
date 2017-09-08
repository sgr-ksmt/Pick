//
//  PickableDataSource.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

public protocol PickableDataSource {
    associatedtype Cell: PickableCell
    associatedtype Item

    var numberOfItems: Int { get }
    func configure(cell: Cell, at indexPath: IndexPath)
    func pickItems(indexes: [Int]) -> [Item]
}

extension PickableDataSource {
    func registerCell(in collectionView: UICollectionView) {
        switch Cell.registerMode {
        case .class:
            collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.cellIdentifier)
        case .nib(let nib):
            collectionView.register(nib, forCellWithReuseIdentifier: Cell.cellIdentifier)
        }
    }

    public func notifyUpdate() {
        NotificationCenter.default.post(name: .PickableDataSourceDidUpdate, object: nil)
    }
}
