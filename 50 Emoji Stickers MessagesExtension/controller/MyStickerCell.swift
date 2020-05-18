//
//  MyStickerCell.swift
//  StikersApp MessagesExtension
//
//  Created by Алексей Пархоменко on 18.05.2020.
//  Copyright © 2020 Alexey Parkhomenko. All rights reserved.
//

import UIKit
import Messages

class MyStickerCell: UICollectionViewCell {
    
    static let reuseId = "MyStickerCell"
    
    var stickerView = MSStickerView()
    var lockButton = UIButton()
    
    private var allStickersUnlocked:Bool{
        return UserData().productPurchased
    }
    
    func configure(_ object: StickerObject) {
            
            if let sticker = object.sticker {
                stickerView.sticker = sticker
                stickerView.isUserInteractionEnabled = (object.isFree || allStickersUnlocked)
            }
            
            lockButton.isHidden = object.isFree || allStickersUnlocked
        }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lockButton.setImage(#imageLiteral(resourceName: "lock_icn"), for: .normal)
        
        stickerView.translatesAutoresizingMaskIntoConstraints = false
        lockButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stickerView)
        addSubview(lockButton)
        
        NSLayoutConstraint.activate([
            stickerView.topAnchor.constraint(equalTo: topAnchor),
            stickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            lockButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            lockButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
