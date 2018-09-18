//
//  CustomActionSheetItemView.swift
//  VideoStream
//
//  Created by Ô Chợ Việt on 9/22/17.
//  Copyright © 2017 Ô Chợ Việt. All rights reserved.
//

import UIKit
import DynamicColor

class CustomActionSheetItemView: UIView {
    
    typealias TapHandler = (() -> ())
    
    @IBOutlet var controlLabel: UILabel!
    @IBOutlet private var view: UIView!
    
    private var touchingDown: Bool = false {
        didSet {
            view.backgroundColor = touchingDown ?
                UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1) :
                UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    var item: MenuViewItem! {
        didSet {
            controlLabel.text = item.title
        }
    }
    
    var tapHandler: TapHandler?
    
    init(frame: CGRect, item: MenuViewItem, onTap tapHandler: TapHandler?) {
        super.init(frame: frame)
        
        self.tapHandler = tapHandler
        initSubViews(item: item)
    }
    
    required init?(coder aDecoder: NSCoder, item: MenuViewItem, onTap tapHandler: TapHandler?) {
        super.init(coder: aDecoder)
        
        self.tapHandler = tapHandler
        initSubViews(item: item)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews(item: MenuViewItem) {
        let nib = UINib(nibName: "CustomActionSheetItemView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        
        if item.type == .Cancel {
            let topBorderView = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 0.5))
            topBorderView.backgroundColor = UIColor(hex: 0xAAAAAA).withAlphaComponent(0.5)
            view.addSubview(topBorderView)
        }
        
        view.frame = bounds
        addSubview(view)
        self.item = item
    }
    
    private func isTouchesInsideView(touches: Set<UITouch>) -> Bool {
        if let touch = touches.first {
            let touchPoint = touch.location(in: view)
            return view.frame.contains(touchPoint)
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingDown = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingDown = isTouchesInsideView(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchingDown = false
        if isTouchesInsideView(touches: touches) {
            self.tapHandler?()
        }
    }
}
