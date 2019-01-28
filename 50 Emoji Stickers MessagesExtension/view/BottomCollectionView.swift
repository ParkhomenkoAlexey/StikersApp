//
//  FooterView.swift
//  50 Emoji Stickers MessagesExtension
//
//  Created by Anna Tikanova on 1/24/19.
//  Copyright © 2019 Anna Tikanova. All rights reserved.
//

import UIKit

class BottomCollectionView: UICollectionReusableView {
    
    weak var delegate:MessageExtensionDelegate?
    var dataSource = MoreAppsDataManager.shared.dataSource
    
    let cellItemSideLength:CGFloat = 75
    var visibleCellsPerRow = 3
    let padding:CGFloat = 16
    let infiniteSize = 10000 //Use as a collectionView size to simulate infinite scroll
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        configure()
    }
    
    func configure(){
        collectionView.register(UINib(nibName: Storyboard.bottomCollectionCell, bundle: nil), forCellWithReuseIdentifier: Storyboard.bottomCollectionCellId)
        
        visibleCellsPerRow = Int(collectionView.frame.width/(cellItemSideLength + padding))
        print(visibleCellsPerRow)
    }
    
}

extension BottomCollectionView: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print()
        return dataSource.count/2 > visibleCellsPerRow ? infiniteSize : dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.bottomCollectionCellId, for: indexPath) as! BottomCollectionCell
        let itemToShow = dataSource[indexPath.row % dataSource.count].values.first
        cell.appIconImageView.image = itemToShow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let appId = dataSource[indexPath.row].keys.first{
            delegate?.openStoreApp(id: appId)
        }
    }
}

extension BottomCollectionView: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: cellItemSideLength, height: cellItemSideLength)
    }
}
