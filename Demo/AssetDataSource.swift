//
//  AssetDataSource.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Pick
import Photos

extension PHAsset: Pickable {
    static func ==(lhs: PHAsset, rhs: PHAsset) -> Bool {
        return rhs.localIdentifier == lhs.localIdentifier
    }
}

final class AssetDataSource: NSObject, PickableDataSource {
    typealias Cell = AssetCell
    typealias Item = PHAsset

    var items: [PHAsset]
    var selectedItems: [PHAsset]

    init(selectedItems: [PHAsset] = []) {
        self.selectedItems = selectedItems
        self.items = []
        super.init()
        fetchCameraroll()
        PHPhotoLibrary.shared().register(self)
    }

    func fetchCameraroll() {
        guard let cameraroll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject else {
            return
        }
        let assets = PHAsset.fetchAssets(in: cameraroll, options: nil)
        items = assets.objects(at: IndexSet(0..<assets.count))
    }

    func configure(cell: Cell, at indexPath: IndexPath) {
        cell.configure(with: items[indexPath.item])
    }

    var numberOfItems: Int {
        return items.count
    }

    func pickItems(indexes: [Int]) -> [Item] {
        return indexes.map { items[$0] }
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
}

extension AssetDataSource: PHPhotoLibraryChangeObserver {
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.sync { [weak self] in
            guard let `self` = self else {
                return
            }

            self.fetchCameraroll()
            self.notifyUpdate()
        }
    }
}
