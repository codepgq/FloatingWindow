//
//  PQWebView.swift
//  FloatingWindow
//
//  Created by 盘国权 on 2018/6/10.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import WebKit

class PQWebView: WKWebView {
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        
        super.init(frame: frame, configuration: configuration)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUp() {
        
        self.addSubview(progressView)
        
        self.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    }
    
    private lazy var progressView: UIProgressView = {
        
        let progressView = UIProgressView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 3))
        progressView.tintColor = .green
        return progressView
    }()
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if  keyPath == "estimatedProgress"{
            
            progressView.alpha = 1.0
            progressView.setProgress(Float(estimatedProgress), animated: true)
            if estimatedProgress >= 1.0 {
                
                print(estimatedProgress)
                
                UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
                    
                    self?.progressView.alpha = 0.0
                }) { [weak self] (finished) in
                    
                    self?.progressView.setProgress(0.0, animated: false)
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    func removeEstimatedProgressObsever() {
        
        self.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func removeAllDelegate() {
        
        self.navigationDelegate = nil
        self.uiDelegate = nil
    }
    
    deinit {
        
        removeEstimatedProgressObsever()
        removeAllDelegate()
    }

}
