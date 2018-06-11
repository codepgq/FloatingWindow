//
//  GlobalFuction.swift
//  FloatingWindow
//
//  Created by 盘国权 on 2018/6/10.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

/*
         view.backgroundColor = .blue
         let dd = HideFloatingWindowView(frame: CGRect(x: 0, y: 0, width: 160, height: 160))
         view.addSubview(dd)
         dd.center = view.center
 
         let btn =
         view.addSubview(btn)
 */
var margin: CGFloat = 20
let floatingWindowBtn = FloatingWindowView(frame: CGRect(x: UIScreen.main.bounds.width - 50 - margin , y: (UIScreen.main.bounds.height - 50) * 0.5, width: 50, height: 50), image: UIImage(named: "head"))

let hideFrame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: 160, height: 160)
let hideWindowView = HideFloatingWindowView(frame: hideFrame)

var fwController: FloatingWindowController = FloatingWindowController()

/// show btn
public func showFloatingWindowBtn(){
    
    floatingWindowBtn.isHidden = false
    
    if hideWindowView.superview == nil {
        UIApplication.shared.keyWindow?.addSubview(hideWindowView)
    }
    
    if floatingWindowBtn.superview == nil {
        UIApplication.shared.keyWindow?.addSubview(floatingWindowBtn)
    }
    
    
}

