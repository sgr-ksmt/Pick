# Pick
Protocol-Oriented PickerViewController.  
You can pick whatever you want from defined data source by you.

[![GitHub release](https://img.shields.io/github/release/sgr-ksmt/Pick.svg)](https://github.com/sgr-ksmt/Pick/releases)
![Language](https://img.shields.io/badge/language-Swift%204-orange.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods](https://img.shields.io/badge/Cocoa%20Pods-✓-4BC51D.svg?style=flat)](https://cocoapods.org/pods/Pick)
[![CocoaPodsDL](https://img.shields.io/cocoapods/dt/Pick.svg)](https://cocoapods.org/pods/Pick)

## Feature
- Can pick single(multiple) item(s).
- Can use flexible DataSource.
- Automatic register/dequeue cell inside picker view.
- Support Pre-fetching.
- Can customize using options.

## How to use

### Define Cell
Create Cell that inherit `PickableCell`.

```swift
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
```

**NOTE**: If you want to use custom cell using xib, add code below.

```swift
final class AssetCell: PickableCell {
    override class var registerMode: RegisterMode {
        return .nib(defaultNib)
    }

    // or

    override class var registerMode: RegisterMode {
        return .nib(UINib(nibName: "AssetCell", bundle: nil))
    }
}
```

### Define DataSource
Create DataSource that adapts `PickableDataSource`.  
You have to implement:

- `typealias Cell`
- `typealias Item`
- `configure(cell: Cell, at indexPath: IndexPath)`
- `var numberOfItems: Int`
- `pickItems(indexes: [Int]) -> [Item]`

```swift
final class AssetDataSource: NSObject, PickableDataSource {
    typealias Cell = AssetCell
    typealias Item = PHAsset

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

    func configure(cell: Cell, at indexPath: IndexPath) {
        if let asset = assets?.object(at: indexPath.item) {
            cell.configure(with: asset)
        }
    }

    var numberOfItems: Int {
        return assets?.count ?? 0
    }

    func pickItems(indexes: [Int]) -> [Item] {
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
```

In order to update picker view after updating datasource, call `notifyUpdate()`

```swift
final class SomeDataSource: NSObject, PickableDataSource {
    private var list: [Int] = []
    func update() {
        list = ...
        notifyUpdate()
    }
}
```

### Setup ViewController
Set data source to PickerViewController(PickerNavigationController).  
Also you can customize using `PickerOptions`.

```swift
let nav = PickerNavigationController(dataSource: AssetDataSource())
nav.options = {
    let options = PickerOptions()
    options.limitOfSelection = 3
    options.selectedBorderColor = .red
    options.viewTitle = "Camera Roll"
    return options
}()

nav.pickItemsHandler = { assets in
    print(assets)
}

viewController.present(nav, animated: true, completion: nil)
```

enjoy 😄

## Todo
- [ ] Document comment.

## Requirements
- iOS 10.0+
- Xcode 9+
- Swift 4+

## Installation

### Carthage

- Add the following to your *Cartfile*:

```bash
github "sgr-ksmt/Pick" ~> 0.1
```

- Run `carthage update`
- Add the framework as described.
<br> Details: [Carthage Readme](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)


### CocoaPods

**Pick** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Pick', '~> 0.1'
```

and run `pod install`

### Manually Install
Download all `*.swift` files and put your project.

## Change log
Change log is [here](https://github.com/sgr-ksmt/Pick/blob/master/CHANGELOG.md).

## Communication
- If you found a bug, open an issue.
- If you have a feature request, open an issue.
- If you want to contribute, submit a pull request.:muscle:

## License

**Pick** is under MIT license. See the [LICENSE](LICENSE) file for more info.