//
//  PickerNavigationController.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

open class PickerNavigationController<DataSource: PickableDataSource>: UINavigationController {
    let pickerViewController: PickerViewController<DataSource>

    public init(dataSource: DataSource) {
        pickerViewController = PickerViewController(dataSource: dataSource)
        super.init(nibName: nil, bundle: nil)
        viewControllers = [pickerViewController]
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public var options: PickerOptions {
        get {
            return pickerViewController.options
        }
        set {
            pickerViewController.options = newValue
        }
    }

    public var pickItemsHandler: PickerViewController<DataSource>.PickItemsHandler? {
        get {
            return pickerViewController.pickItemsHandler
        }
        set {
            pickerViewController.pickItemsHandler = newValue
        }
    }
}
