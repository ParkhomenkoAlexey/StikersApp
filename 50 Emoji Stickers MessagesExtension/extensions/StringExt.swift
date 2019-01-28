//
//  StringExt.swift
//  50 Emoji Stickers MessagesExtension
//
//  Created by Anna Tikanova on 1/25/19.
//  Copyright © 2019 Anna Tikanova. All rights reserved.
//

import Foundation

extension String{
    
    var numericAppIdPart: String?{
        get{
            let idString = "id"
            guard self.contains(idString) else{
                return nil
            }
            return self.replacingOccurrences(of: idString, with: "")
        }
    }
}
