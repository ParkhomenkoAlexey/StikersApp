//
//  StickerCell.swift
//  50 Emoji Stickers MessagesExtension
//
//  Created by Anna Tikanova on 1/23/19.
//  Copyright © 2019 Anna Tikanova. All rights reserved.
//

import UIKit
import Messages

class StickerCell: UICollectionViewCell {
    
    @IBOutlet weak var stickerView: MSStickerView!
    @IBOutlet weak var lockButton: UIButton!
    
    private var allStickersUnlocked:Bool{
        return UserData().productPurchased
    }
    
    func configure(_ object: StickerObject){
        if let sticker = object.sticker{
            stickerView.sticker = sticker
            stickerView.isUserInteractionEnabled = (object.isFree || allStickersUnlocked)
        }
        lockButton.isHidden = object.isFree || allStickersUnlocked
    }
}
