//
//  ViewController.swift
//  FloatingWindow
//
//  Created by 盘国权 on 2018/6/9.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    var titles: [String] = ["百度弹窗", "简书弹窗"]
    var urls: [String] = ["www.baidu.com", "www.jianshu.com"]

    @IBAction func showFloatinWindowBtnClick(_ sender: UIButton) {
        showFloatingWindowBtn()
    }
}

extension ViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return TransitionAnimator(isPush: true, animation: .overlay)
        }
        return nil
    }
}
