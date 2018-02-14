//
//  PickerViewController.swift
//  Pick
//
//  Created by suguru-kishimoto on 2017/09/08.
//  Copyright © 2017年 Suguru Kishimoto. All rights reserved.
//

import UIKit

public final class PickerViewController<DataSource: PickableDataSource>: UIViewController {

    public var options: PickerOptions = PickerOptions() {
        didSet {
            if isViewLoaded {
                syncOption()
                updateBarButton()
                collectionView.reloadData()
            }
        }
    }

    var isLimited: Bool {
        return dataSource.selectedItems.count >= options.limitOfSelection
    }

    private lazy var delegateProxy: PickerViewDelegateProxy = {
        let proxy = PickerViewDelegateProxy(options: self.options)
        proxy.reloadCellsHandler = { [weak self] collectionView, indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? DataSource.Cell else { return }
            self?.updateCellSelectedStyle(cell: cell, indexPath: indexPath)
        }
        proxy.didSelectHandler = { [weak self] index in
            guard let `self` = self else { return }
            guard !self.dataSource.selectedItems.contains(self.dataSource.items[index.row]) else { return }
            self.dataSource.selectedItems.append(self.dataSource.items[index.row])
            self.updateBarButton()
        }
        proxy.didDeselectHandler = { [weak self] index in
            guard let `self` = self else { return }
            guard let selectedIndex = self.dataSource.selectedItems.index(where: { $0 == self.dataSource.items[index.item] }) else { return }
            self.dataSource.selectedItems.remove(at: selectedIndex)
            self.updateBarButton()
        }
        proxy.isLimited = { [weak self] in
            guard let `self` = self else { return false }
            return self.isLimited
        }
        return proxy
    }()

    private lazy var dataSourceProxy: PickerViewDataSourceProxy = {
        let proxy = PickerViewDataSourceProxy()
        proxy.numberOfItems = { [weak self] in
            return self?.dataSource.numberOfItems ?? 0
        }
        proxy.cellGenerator = { [weak self] collectionView, indexPath in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DataSource.Cell.cellIdentifier, for: indexPath) as! DataSource.Cell
            if let options = self?.options {
                cell.selectedBorderColor = options.selectedBorderColor
                cell.selectedBorderWidth = options.selectedBorderWidth
                cell.selectedPositionTintColor = options.selectedPositionTintColor
                cell.selectedPositionTextColor = options.selectedPositionTextColor
            }
            self?.dataSource.configure(cell: cell, at: indexPath)
            self?.updateCellSelectedStyle(cell: cell, indexPath: indexPath)
            return cell
        }
        proxy.prefetchHandler = { [weak self] indexPaths in
            self?.dataSource.prefetch(indexPaths: indexPaths)
        }
        proxy.cancelPrefetchingHandler = { [weak self] indexPaths in
            self?.dataSource.cancelPrefetching(indexPaths: indexPaths)
        }

        return proxy
    }()

    private(set) lazy var collectionView: PickerCollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let view = PickerCollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        view.backgroundColor = .white
        view.delegate = self.delegateProxy
        view.dataSource = self.dataSourceProxy
        view.allowsSelection = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pickBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: self.pickButtonTitle, style: .plain, target: self, action: #selector(self.pick))
        return button
    }()

    private lazy var cancelBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: self.options.cancelButtonTitle, style: .plain, target: self, action: #selector(cancel))
        return button
    }()

    public typealias PickItemsHandler = ([DataSource.Item]) -> Void
    public var pickItemsHandler: PickItemsHandler?

    private var token: NSObjectProtocol?

    let dataSource: DataSource
    public init(dataSource: DataSource) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func loadView() {
        super.loadView()
        self.view.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        dataSource.registerCell(in: collectionView)
        syncOption()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBarButton
        navigationItem.rightBarButtonItem = pickBarButton
        updateBarButton()

        token = NotificationCenter.default.addObserver(forName: .PickableDataSourceDidUpdate, object: nil, queue: .main) { [weak self] _ in
            self?.updateBarButton()
            self?.collectionView.reloadData()
        }
    }

    @objc private func cancel() {
        navigationController?.dismiss(animated: true, completion: nil)
    }

    @objc private func pick() {
        guard !dataSource.selectedItems.isEmpty else { return }
        pickItemsHandler?(dataSource.selectedItems)
    }

    private var pickButtonTitle: String {
        if options.limitOfSelection <= 1 {
            return options.pickButtonTitle
        } else {
            let selectedCount = dataSource.selectedItems.count
            if selectedCount == 0 {
                return options.pickButtonTitle
            } else {
                return "\(options.pickButtonTitle)(\(selectedCount))"
            }
        }
    }

    private func syncOption() {
        title = options.viewTitle
        delegateProxy.options = options
        collectionView.allowsMultipleSelection = options.limitOfSelection > 1
        collectionView.prefetchDataSource = options.isPrefetchingEnabled ? self.dataSourceProxy : nil
    }

    private func updateBarButton() {
        pickBarButton.title = pickButtonTitle
        pickBarButton.isEnabled = !self.dataSource.selectedItems.isEmpty
        cancelBarButton.title = options.cancelButtonTitle
    }

    private func updateCellSelectedStyle(cell: PickableCell, indexPath: IndexPath) {
        if !collectionView.allowsMultipleSelection {
            cell.alpha = 1.0
            cell.showsSelectedPosition = false
            return
        }
        let isSelected = dataSource.selectedItems.contains { $0 == dataSource.items[indexPath.item] }
        if self.isLimited {
            cell.alpha = isSelected ? 1.0 : 0.55
        } else {
            cell.alpha = 1.0
        }
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        cell.isSelected = isSelected
        cell.showsSelectedPosition = options.showsSelectedNumber
        cell.selectedPosition = dataSource.selectedItems.index { $0 == dataSource.items[indexPath.item] }.map { $0 + 1 } ?? -1
    }

    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
