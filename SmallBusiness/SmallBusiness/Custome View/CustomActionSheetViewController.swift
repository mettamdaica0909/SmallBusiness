//
//  CustomActionSheetViewController.swift
//  SmallBusiness
//
//  Created by Duy Le on 9/15/18.
//  Copyright © 2018 Duy Le. All rights reserved.
//

import Foundation
import UIKit

class CustomActionSheetViewController: UIViewController {
    
    var menuView: UIView!
    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    let menuHeight: CGFloat = 50
    var items: [MenuViewItem]!
    var isPresenting: Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(items: [MenuViewItem]?) {
        super.init(nibName: nil, bundle: nil)
        
        self.items = items ?? []
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuViewHeight = CGFloat(items.count) * menuHeight
        menuView = UIView(frame: CGRect(x: 0, y: view.bounds.height - menuViewHeight, width: view.bounds.width, height: menuViewHeight))
        
        let customActionSheetItemViews: [CustomActionSheetItemView] = self.items.enumerated().map { t in
            let y = CGFloat(t.offset) * menuHeight
            
            return CustomActionSheetItemView(frame: CGRect(x: 0.0, y: y, width: view.bounds.width, height: menuHeight), item: t.element, onTap: {
                self.dismiss(animated: true, completion: nil)
                t.element.tapHandler?()
            })
        }
        
        customActionSheetItemViews.forEach() {
            menuView.addSubview($0)
        }
        
        view.addSubview(backdropView)
        view.addSubview(menuView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CustomActionSheetViewController.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.view === backdropView {
            dismiss(animated: true, completion: nil)
        }
    }
}
// MARK: TransitionDelegate
extension CustomActionSheetViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            menuView.frame.origin.y += menuView.frame.height
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuView.frame.height
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuView.frame.height
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
        
    }
}
