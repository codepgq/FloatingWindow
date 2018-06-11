//
//  TransitionAnimator.swift
//  FloatingWindow
//
//  Created by 盘国权 on 2018/6/10.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

enum TransitionAnimation: Int {
    case system
    case overlay
}

class TransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private(set) var isPush: Bool = false
    private(set) var animation: TransitionAnimation = .system
    convenience init(isPush: Bool = true, animation: TransitionAnimation = .system){
        self.init()
        self.isPush = isPush
        self.animation = animation
    }

    /// 动画时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval{
        return 0.35
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning){
        switch animation {
        case .system:
            system(transitionContext)
        case .overlay:
            overlay(transitionContext)
        }
    }
    
    private func overlay(_ transitionContext: UIViewControllerContextTransitioning){
        
        let containerView = transitionContext.containerView
        var animationView: UIView? = nil
        
        var toView = transitionContext.view(forKey: .to)
        if toView == nil {
            toView = transitionContext.viewController(forKey: .to)?.view
        }
        if isPush {
            
            containerView.addSubview(toView!)
            animationView = toView
            animationView?.layer.cornerRadius = 20
            animationView?.clipsToBounds = true
            animationView?.frame = floatingWindowBtn.frame
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                animationView?.frame = containerView.bounds
            }) { (_) in
                UIView.animate(withDuration: 0.01, animations: {
                    animationView?.layer.cornerRadius = 0
                    animationView?.clipsToBounds = false
                })
                transitionContext.completeTransition(true)
            }
            
        }else{
            var fromView = transitionContext.view(forKey: .from)
            if fromView == nil {
                fromView = transitionContext.viewController(forKey: .from)?.view
            }
            
            containerView.insertSubview(toView!, belowSubview: fromView!)
            
            let blackView = UIView(frame: containerView.bounds)
            blackView.backgroundColor = .black
            containerView.insertSubview(blackView, belowSubview: fromView!)
            
            animationView = fromView
            
            animationView?.layer.cornerRadius = 20
            animationView?.clipsToBounds = true
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                animationView?.frame = floatingWindowBtn.frame
                blackView.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0.01, animations: {
                    animationView?.layer.cornerRadius = 0
                    animationView?.clipsToBounds = false
                })
                blackView.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
            
        }
        
        
        
    }
    
    private func system(_ transitionContext: UIViewControllerContextTransitioning){
        
        let containerView = transitionContext.containerView
        var animationView: UIView? = nil
        
        // to view
        var toView = transitionContext.view(forKey: .to)
        if toView == nil {
            toView = transitionContext.viewController(forKey: .to)?.view
        }
        
        if isPush {
            containerView.addSubview(toView!)
            animationView = toView
            animationView?.frame.origin.x = UIScreen.main.bounds.width
        }else{
            
            var fromView = transitionContext.view(forKey: .from)
            if fromView == nil {
                fromView = transitionContext.viewController(forKey: .from)?.view
            }
            
            containerView.insertSubview(toView!, belowSubview: fromView!)
            animationView = fromView
            floatingWindowBtn.alpha = 0
        }
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            if !self.isPush {
                animationView?.frame.origin.x = UIScreen.main.bounds.width
            }else{
                animationView?.frame.origin.x = 0
                floatingWindowBtn.alpha = 1
            }
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
    
    private func addAnimation(from value: Any, to toValue: Any, transitionContext: UIViewControllerContextTransitioning) -> CABasicAnimation{
        let animation = CABasicAnimation(keyPath: "path")
        
        animation.fromValue = value
        animation.toValue = toValue
        animation.duration = transitionDuration(using: transitionContext)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.delegate = self;
        animation.isRemovedOnCompletion = false;
        animation.fillMode = kCAFillModeForwards;
        
        animation.setValue(transitionContext, forKey: "transitionContext")
        return animation
    }

}

extension TransitionAnimator: CAAnimationDelegate{
    public func animationDidStart(_ anim: CAAnimation){
        
    }
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool){
        if let transitionContext = anim.value(forKey: "transitionContext") as? UIViewControllerContextTransitioning{
            transitionContext.completeTransition(true)
        }
    }
}
