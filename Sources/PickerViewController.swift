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

    private lazy var delegateProxy: PickerViewDelegateProxy = {
        let proxy = PickerViewDelegateProxy(options: self.options)
        proxy.reloadCellsHandler = { [weak self] collectionView, indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? DataSource.Cell else { return }
            self?.updateCellSelectedStyle(cell: cell, indexPath: indexPath)
        }
        proxy.didSelectHandler = { [weak self] _ in
            self?.updateBarButton()
        }
        proxy.didDeselectHandler = { [weak self] _ in
            self?.updateBarButton()
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
                cell.selectedNumberTintColor = options.selectedNumberTintColor
                cell.selectedNumberTextColor = options.selectedNumberTextColor
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
        let selectedIndexPaths = collectionView.orderedIndexPathsForSelectedItems
        if selectedIndexPaths.isEmpty { return }
        pickItemsHandler?(dataSource.pickItems(indexes: selectedIndexPaths.map { $0.item }))
        navigationController?.dismiss(animated: true, completion: nil)
    }

    private var pickButtonTitle: String {
        if options.limitOfSelection <= 1 {
            return options.pickButtonTitle
        } else {
            let selectedCount = collectionView.orderedIndexPathsForSelectedItems.count
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
    }

    private func updateBarButton() {
        pickBarButton.title = pickButtonTitle
        pickBarButton.isEnabled = !collectionView.orderedIndexPathsForSelectedItems.isEmpty
        cancelBarButton.title = options.cancelButtonTitle
    }

    private var isLimited: Bool {
        return collectionView.orderedIndexPathsForSelectedItems.count >= options.limitOfSelection
    }

    private func updateCellSelectedStyle(cell: PickableCell, indexPath: IndexPath) {
        if !collectionView.allowsMultipleSelection {
            cell.alpha = 1.0
            cell.showsSelectedPosition = false
            return
        }

        if self.isLimited {
            cell.alpha = collectionView.orderedIndexPathsForSelectedItems.contains(indexPath) ? 1.0 : 0.55
        } else {
            cell.alpha = 1.0
        }

        cell.showsSelectedPosition = options.showsSelectedNumber
        cell.selectedPosition = collectionView.orderedIndexPathsForSelectedItems.index(of: indexPath).map { $0 + 1 } ?? -1
    }

    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
}
