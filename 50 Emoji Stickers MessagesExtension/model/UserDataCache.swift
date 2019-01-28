//
//  UserDataCache.swift
//  Poly
//
//  Created by Anna Tikanova on 4/3/18.
//  Copyright © 2018 Anna Tikanova. All rights reserved.
//

import Foundation
struct UserData {
    
    private let userDefaults:UserDefaults

    var productPurchased:Bool{
        get {
            return userDefaults.bool(forKey: IAPHelper.unlockAllProductId)
        }
        set {
            userDefaults.set(newValue, forKey: IAPHelper.unlockAllProductId)
        }
    }
    

    init() {
        self.userDefaults = Foundation.UserDefaults()
        userDefaults.register(defaults: [
                IAPHelper.unlockAllProductId: false])
    }

}
