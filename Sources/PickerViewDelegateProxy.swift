//
//  PickerViewDelegateProxy.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

final class PickerViewDelegateProxy: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public var options: PickerOptions

    var reloadCellsHandler: (UICollectionView, IndexPath) -> Void = { _, _ in }
    var didSelectHandler: (IndexPath) -> Void = { _ in }
    var didDeselectHandler: (IndexPath) -> Void = { _ in }
    var isLimited: () -> Bool = { false }

    init(options: PickerOptions) {
        self.options = options
        super.init()
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if collectionView.allowsMultipleSelection {
            return !isLimited()
        }
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectHandler(indexPath)
        if collectionView.allowsMultipleSelection {
            collectionView.indexPathsForVisibleItems.forEach { reloadCellsHandler(collectionView, $0) }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        didDeselectHandler(indexPath)
        if collectionView.allowsMultipleSelection {
            collectionView.indexPathsForVisibleItems.forEach { reloadCellsHandler(collectionView, $0) }
        }
    }

    private var margin: CGFloat {
        let numberOfColumnsInRow: CGFloat = CGFloat(self.options.numberOfColumnsInRow)
        return UIScreen.main.bounds.width.truncatingRemainder(dividingBy: numberOfColumnsInRow) == 0 ? 1 : 1.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return margin
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumnsInRow: CGFloat = CGFloat(self.options.numberOfColumnsInRow)
        let spacing: CGFloat = margin * (numberOfColumnsInRow - 1)
        let side: CGFloat = (UIScreen.main.bounds.width - spacing) / numberOfColumnsInRow
        return CGSize(width: side, height: side)
    }
}
