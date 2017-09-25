//
//  PickerCollectionView.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/25.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

final class PickerCollectionView: UICollectionView {
    var orderedIndexPathsForSelectedItems: [IndexPath] = [] {
        didSet {
            print(orderedIndexPathsForSelectedItems)
        }
    }

    override func reloadData() {
        orderedIndexPathsForSelectedItems = []
        super.reloadData()
    }
}
