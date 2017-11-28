//
//  PickerOptions.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import Foundation

public final class PickerOptions {
    public init() {}
    private static var defaultTintColor: UIColor {
        return UIView().tintColor
    }
    
    public var numberOfColumnsInRow: Int = 3
    public var limitOfSelection: Int = Int.max
    public var selectedBorderWidth: CGFloat = 4.0
    public var selectedBorderColor: UIColor = PickerOptions.defaultTintColor
    public var cancelButtonTitle: String = "Cancel"
    public var pickButtonTitle: String = "Pick"
    public var viewTitle: String = ""
    public var showsSelectedNumber: Bool = true
    public var selectedPositionTintColor: UIColor = .white
    public var selectedPositionTextColor: UIColor = PickerOptions.defaultTintColor
    public var isPrefetchingEnabled: Bool = false
}
