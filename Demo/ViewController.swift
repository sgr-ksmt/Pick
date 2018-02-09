//
//  ViewController.swift
//  Demo
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit
import Pick
import Photos

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func showColorPicker(sender: AnyObject) {
        let nav = PickerNavigationController(dataSource: ColorDataSource())
        nav.options = {
            let options = PickerOptions()
            options.limitOfSelection = 10
            options.isPrefetchingEnabled = true
            options.viewTitle = "Color Picker"
            return options
        }()

        nav.pickItemsHandler = { items in
            nav.dismiss(animated: true, completion: nil)
            print(items, items.count)
        }

        present(nav, animated: true, completion: nil)
    }

    @IBAction func showPhotoPicker(sender: AnyObject) {

        PHPhotoLibrary.requestAuthorization { status in
            DispatchQueue.main.async { [weak self] in
                if status == .authorized {
                    self?._showPhotoPicker()
                }
            }
        }
    }

    private func _showPhotoPicker() {
        let nav = PickerNavigationController(dataSource: AssetDataSource())
        nav.options = {
            let options = PickerOptions()
            options.limitOfSelection = 3
            options.viewTitle = "Camera Roll"
            return options
        }()
        nav.pickItemsHandler = { assets in
            nav.dismiss(animated: true, completion: nil)
            print(assets)
        }

        present(nav, animated: true, completion: nil)
    }
}

