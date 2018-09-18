//
//  MenuViewItem.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/15/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation

struct MenuViewItem {
    
    enum ItemType {
        case Normal
        case Cancel
    }
    
    typealias TapHandler = (() -> ())
    
    var title: String? = nil
    var type: ItemType = .Normal
    var tapHandler: TapHandler?
    
    init(title: String?, onTap tapHandler: TapHandler?) {
        self.title = title
        self.tapHandler = tapHandler
    }
    
    init(title: String?, type: ItemType) {
        self.title = title
        self.type = type
    }
}
