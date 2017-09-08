//
//  PickableCell.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

open class PickableCell: UICollectionViewCell {
    public enum RegisterMode {
        case `class`
        case nib(UINib)
    }

    open class var registerMode: RegisterMode {
        return .`class`
    }

    open class var cellIdentifier: String {
        return String(describing: self)
    }

    private lazy var borderView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.layer.borderColor = self.selectedBorderColor.cgColor
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var selectedBorderColor: UIColor = .white {
        didSet {
            borderView.layer.borderColor = selectedBorderColor.cgColor
        }
    }

    var selectedBorderWidth: CGFloat = 4.0

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    open override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override open func prepareForReuse() {
        super.prepareForReuse()
        borderView.layer.borderWidth = 0
    }

    private func commonInit() {
        contentView.addSubview(borderView)
        borderView.layer.zPosition = 10
        borderView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        borderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        borderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        borderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    override open var isSelected: Bool {
        didSet {
            borderView.layer.borderWidth = isSelected ? selectedBorderWidth : 0
        }
    }
}
