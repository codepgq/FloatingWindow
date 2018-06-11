//
//  FloatingWindowView.swift
//  FloatingWindow
//
//  Created by 盘国权 on 2018/6/10.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

class FloatingWindowView: UIButton {
    
    
    
    convenience init(frame: CGRect, image: UIImage?) {
        self.init(frame: frame)
        self.image = image
        drawArcImage()
    }
    
    var image: UIImage?{
        didSet{
            drawArcImage()
        }
    }
    
    private func drawArcImage(){
        //裁减为圆角图片
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, UIScreen.main.scale)
        
        image?.draw(in: self.bounds)
        
        UIBezierPath(ovalIn: self.bounds).addClip()
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        setImage(newImage, for: .normal)
    }
    
    private var lastPoint: CGPoint = .zero
}

// MARK: move
extension FloatingWindowView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let superView = self.superview else { return }
        lastPoint = touch.location(in: superView)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let superView = self.superview else { return }
        let point = touch.location(in: superView)
 
        self.frame.origin.x = point.x - frame.width * 0.5
        self.frame.origin.y = point.y - frame.height * 0.5
        
        
        let convertPoint = touch.location(in: hideWindowView)
        let isHiddenBtn = hideWindowView.point(inside: convertPoint, with: event)
        
        // show hide floating window view
        UIView.animate(withDuration: 0.2) {
            hideWindowView.frame.origin = CGPoint(x: UIScreen.main.bounds.width - hideWindowView.frame.width, y: UIScreen.main.bounds.height - hideWindowView.frame.height)
            hideWindowView.moreRedBackground(isHiddenBtn)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let superView = superview else { return }
        
        if lastPoint == touch.location(in: superView) { //push
            let controller = UIApplication.shared.keyWindow?.rootViewController
            var nav = controller?.navigationController
            if nav == nil {
                nav = controller?.childViewControllers.first?.navigationController
            }
            
            UIView.animate(withDuration: 0.2) {
                hideWindowView.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
            }
            
            nav?.pushViewController(fwController, animated: true)
            return
        }
        
        let convertPoint = touch.location(in: hideWindowView)
        
        let isHiddenBtn = hideWindowView.point(inside: convertPoint, with: event)
        
        let currentPointX = frame.origin.x + frame.width * 0.5
        let screenW = UIScreen.main.bounds.width
        
        let pointX = (currentPointX > screenW * 0.5) ? (screenW - frame.width) - margin : margin
        
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = pointX
            
            //限制y的位置，保证显示完整
            self.frame.origin.y = self.frame.origin.y < 0 ? 0 : self.frame.origin.y
            self.frame.origin.y = self.frame.origin.y > (UIScreen.main.bounds.height - self.frame.height) ? (UIScreen.main.bounds.height - self.frame.height) : self.frame.origin.y
        }
        // show hide floating window view
        UIView.animate(withDuration: 0.2) {
            hideWindowView.frame.origin = CGPoint(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height)
            self.isHidden = isHiddenBtn
        }
    }
    
    private func containsInHideWindow(_ lastPoint: CGPoint) -> Bool{
        let btnFrame = CGRect(origin: lastPoint, size: self.frame.size)
        print(btnFrame,hideWindowView.frame)
        if hideWindowView.frame.contains(btnFrame) {
            print("xiaoshi")
        }else{
            print("xiaoshi==")
        }
        return false
    }
}
