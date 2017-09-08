//
//  PickerViewDataSourceProxy.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

final class PickerViewDataSourceProxy: NSObject, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {

    var numberOfItems: () -> Int = { 0 }
    var cellGenerator: (UICollectionView, IndexPath) -> UICollectionViewCell = { _, _  in fatalError() }
    var prefetchHandler: ([IndexPath]) -> Void = { _ in }
    var cancelPrefetchingHandler: ([IndexPath]) -> Void = { _ in }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cellGenerator(collectionView, indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchHandler(indexPaths)
    }

    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        cancelPrefetchingHandler(indexPaths)
    }
}
