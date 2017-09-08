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

final class AssetDataSource: NSObject, PickableDataSource {
    var assets: PHFetchResult<PHAsset>?
    override init() {
        super.init()
        fetchCameraroll()
        PHPhotoLibrary.shared().register(self)
    }

    func fetchCameraroll() {
        guard let cameraroll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).firstObject else {
            return
        }
        self.assets = PHAsset.fetchAssets(in: cameraroll, options: nil)
    }

    func configure(cell: AssetCell, at indexPath: IndexPath) {
        if let asset = assets?.object(at: indexPath.item) {
            cell.configure(with: asset)
        }
    }

    var numberOfItems: Int {
        return assets?.count ?? 0
    }

    func pickItems(indexes: [Int]) -> [PHAsset] {
        return assets?.objects(at: IndexSet(indexes)) ?? []
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

            guard let assets = self.assets else { return }
            guard let _ = changeInstance.changeDetails(for: assets) else { return }

            self.fetchCameraroll()
            self.notifyUpdate()
        }
    }
}
