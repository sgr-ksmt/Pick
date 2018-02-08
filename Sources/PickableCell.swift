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

    public static var defaultNib: UINib {
        return UINib(nibName: String(describing: self), bundle: nil)
    }

    private lazy var borderView: UIView = {
        let view = UIView(frame: .zero)
        view.clipsToBounds = true
        view.layer.borderColor = self.selectedBorderColor.cgColor
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var positionLabel: PaddingLabel = {
        let label = PaddingLabel(frame: .zero)
        label.textAlignment = .center
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        label.font = .systemFont(ofSize: 12.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var selectedBorderColor: UIColor = .white {
        didSet {
            borderView.layer.borderColor = selectedBorderColor.cgColor
        }
    }

    public var selectedPositionTintColor: UIColor = .white {
        didSet {
            positionLabel.backgroundColor = selectedPositionTintColor
        }
    }

    public var selectedPositionTextColor: UIColor = .white {
        didSet {
            positionLabel.textColor = selectedPositionTextColor
        }
    }

    var selectedBorderWidth: CGFloat = 4.0

    internal(set) public var selectedPosition: Int = -1 {
        didSet {
            updateSelectedPosition()
        }
    }
    
    var showsSelectedPosition: Bool = false {
        didSet {
            updateSelectedPosition()
        }
    }

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

        contentView.addSubview(positionLabel)
        positionLabel.layer.zPosition = 10
        positionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8.0).isActive = true
        positionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8.0).isActive = true
        positionLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        positionLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 20.0).isActive = true
        positionLabel.isHidden = true

    }

    private func updateSelectedPosition() {
        if showsSelectedPosition && selectedPosition != -1 {
            positionLabel.text = "\(selectedPosition)"
            positionLabel.isHidden = false
        } else {
            positionLabel.isHidden = true
        }
    }

    override open var isSelected: Bool {
        didSet {
            borderView.layer.borderWidth = isSelected ? selectedBorderWidth : 0
            updateSelectedPosition()
        }
    }
}
