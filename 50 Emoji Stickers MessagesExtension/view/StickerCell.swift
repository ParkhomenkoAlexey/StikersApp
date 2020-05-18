//
//  StickerCell.swift


import UIKit
import Messages

class StickerCell: UICollectionViewCell {
    
    @IBOutlet weak var stickerView: MSStickerView!
    @IBOutlet weak var lockButton: UIButton!
    
    private var allStickersUnlocked:Bool{
        return UserData().productPurchased
    }
    
    func configure(_ object: StickerObject) {
        
        if let sticker = object.sticker {
            stickerView.sticker = sticker
//            if stickerCanAnimate(sticker: sticker) {
//                stickerView.startAnimating()
//            }
            stickerView.isUserInteractionEnabled = (object.isFree || allStickersUnlocked)
        }
        
        lockButton.isHidden = object.isFree || allStickersUnlocked
    }
    
//    func stickerCanAnimate(sticker: MSSticker) -> Bool {
//        guard let stickerImageSource = CGImageSourceCreateWithURL(sticker.imageFileURL as CFURL, nil) else { return false }
//        let stickerFrameCount = CGImageSourceGetCount(stickerImageSource)
//        return stickerFrameCount > 1
//    }
}
