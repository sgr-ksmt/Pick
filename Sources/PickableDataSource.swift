//
//  PickableDataSource.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

public protocol PickableDataSource: class {
    associatedtype Cell: PickableCell
    associatedtype Item: Pickable

    var numberOfItems: Int { get }
    var items: [Item] { get set }
    var selectedItems: [Item] { get set }
    func configure(cell: Cell, at indexPath: IndexPath)
    func pickItems(indexes: [Int]) -> [Item]

    /// Optional
    func prefetch(indexPaths: [IndexPath])
    func cancelPrefetching(indexPaths: [IndexPath])
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

    public func prefetch(indexPaths: [IndexPath]) {
    }

    public func cancelPrefetching(indexPaths: [IndexPath]) {
    }
}
