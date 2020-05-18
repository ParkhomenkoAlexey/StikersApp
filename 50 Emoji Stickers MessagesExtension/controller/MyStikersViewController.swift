//
//  MyStikersViewController.swift
//  CollectionTest
//
//  Created by Алексей Пархоменко on 15.05.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import UIKit
import Messages
import StoreKit

class MyStikersViewController: UIViewController {
    
    var collectionView: UICollectionView! = nil
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInserts = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    var cellWidth: CGFloat = 0
    
    var isHideButtons: Bool = false
    
    var dataSource = [StickerObject]()
    var userData = UserData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObservers()
        setupElements()
        setupConstraints()
        loadStickerData()
    }
    
    private func addObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseSuccessNotificationHandler), name: .SuccessPurchaseNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(purchaseFailedNotificationHandler), name: .FailedPurchaseNotification, object: nil)
    }
    
    /*
     * Parse data from StickerData.plist and create data source for sticker collection view
     */
    private func loadStickerData() {
        if let path = Bundle.main.path(forResource: "StickerData", ofType: ".plist") {
            if let data = NSArray(contentsOfFile: path) as? [Dictionary<String, Any>]{
                data.forEach { (item) in
                    let id = item["id"] as! Int
                    let name = item["name"] as! String
                    let isFree = item["isFree"] as! Bool
                    
                    let stickerObject = StickerObject(id: id, name: name, isFree: isFree)
                    dataSource.append(stickerObject)
                }
            }
        }
    }
    
    func purchaseProduct() {
        ActivityIndicatorManager.shared.startActivityIndicator(on: self)
        IAPHelper.shared.requestProducts { (success, products) in
            products?.forEach({ (product) in
                print("product buy")
                IAPHelper.shared.buyProduct(product)
            })
        }
    }
    
    @objc func purchaseSuccessNotificationHandler(){
        ActivityIndicatorManager.shared.stopActivityIndicator()
        unlockAllItems()
    }
    
    @objc func purchaseFailedNotificationHandler(){
        ActivityIndicatorManager.shared.stopActivityIndicator()
    }
    
    func unlockAllItems(){
        userData.productPurchased = true
        collectionView.reloadData()
    }
    
}

// MARK: - Setup View
extension MyStikersViewController {
    func setupElements() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(MyStickerCell.self, forCellWithReuseIdentifier: MyStickerCell.reuseId)
        
        collectionView.register(CollectionFooterView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: CollectionFooterView.reuseId)
    }
}

// MARK: - Setup Constraints
extension MyStikersViewController {
    func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension MyStikersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyStickerCell.reuseId, for: indexPath) as! MyStickerCell
        cell.configure(dataSource[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !dataSource[indexPath.row].isFree || userData.productPurchased{
            purchaseProduct()
        }
    }
    
    // MARK: - animate stikers
    func stickerCanAnimate(sticker: MSSticker) -> Bool {
        guard let stickerImageSource = CGImageSourceCreateWithURL(sticker.imageFileURL as CFURL, nil) else { return false }
        let stickerFrameCount = CGImageSourceGetCount(stickerImageSource)
        return stickerFrameCount > 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.reuseIdentifier == MyStickerCell.reuseId {
            let stickerCell = cell as! MyStickerCell
            if stickerCanAnimate(sticker: stickerCell.stickerView.sticker!) {
                stickerCell.stickerView.startAnimating()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.reuseIdentifier == MyStickerCell.reuseId {
            let stickerCell = cell as! MyStickerCell
            if stickerCell.stickerView.isAnimating() {
                stickerCell.stickerView.stopAnimating()
            }
        }
    }
    
    
    // MARK: - footer view setup
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionFooterView.reuseId, for: indexPath) as! CollectionFooterView
        footerView.delegate = self
        footerView.messageDelegate = self
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        
        let collectionViewHeight = cellWidth * 2 + sectionInserts.left
        let fullHeight = 328 + collectionViewHeight
        
        if MoreAppsDataManager.shared.dataSource.count == 0{
            return CGSize.zero
        } else {
            if isHideButtons {
                return .init(width: view.frame.width, height: fullHeight - 160)
            } else {
                return .init(width: view.frame.width, height: fullHeight)
            }
        }
    }
}

// MARK: - HideButtonsDelegate
extension MyStikersViewController: HideButtonsDelegate {
    func unlockButtonPressed() {
        isHideButtons = !isHideButtons
        collectionView.reloadData()
        
        purchaseProduct()
    }
    
    func restoreButtonPressed() {
        isHideButtons = !isHideButtons
        collectionView.reloadData()
        
        ActivityIndicatorManager.shared.startActivityIndicator(on: self)
        IAPHelper.shared.restorePurchases()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MyStikersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (17 * (itemsPerRow - 1)) + sectionInserts.left + sectionInserts.left
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        self.cellWidth = widthPerItem
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

// MARK: - MessageExtensionDelegate
extension MyStikersViewController: MessageExtensionDelegate {
    
    func openStoreApp(id: String){
        if let idNumber = Int(id){
            openStoreProductWithiTunesItemIdentifier(idNumber)
        }
    }
    
    private func openStoreProductWithiTunesItemIdentifier(_ identifier: Int) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters, completionBlock: nil)
        present(storeViewController, animated: true, completion: nil)
    }
}

// MARK: - SKStoreProductViewControllerDelegate
extension MyStikersViewController: SKStoreProductViewControllerDelegate{
    
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
