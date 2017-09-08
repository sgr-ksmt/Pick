//
//  AssetCell.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Photos
import Pick

final class AssetCell: PickableCell {
    private lazy var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static let fetchOption: PHImageRequestOptions = {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.resizeMode = .exact
        return options
    }()
    
    private var asset: PHAsset?
    func configure(with asset: PHAsset) {
        self.asset = asset
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFill, options: type(of: self).fetchOption) { [weak self] (image, _) in
            if self?.asset?.localIdentifier == asset.localIdentifier {
                self?.imageView.image = image
            }
        }
    }
}
