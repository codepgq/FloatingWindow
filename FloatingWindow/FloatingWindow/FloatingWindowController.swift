//
//  PersonalAlxeaController.swift
//  EIQSmart
//
//  Created by pgq on 2018/5/14.
//  Copyright © 2018年 pgq. All rights reserved.
//

import UIKit
import WebKit

class FloatingWindowController: UIViewController {
    
    var url = "https://www.jianshu.com/p/7cbcebb2dcbc"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        setUp()
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
//        view.backgroundColor = UIColor.cyan
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close_window")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(leftBarbuttonClick))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(rightBarButtonClick))
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fwBtnIsHidden = floatingWindowBtn.isHidden
        floatingWindowBtn.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        floatingWindowBtn.isHidden = fwBtnIsHidden
        
        webview.uiDelegate = nil
        webview.navigationDelegate = nil
        webview.stopLoading()
    }
    
    private func setUp() {
        
        webview.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        webview.uiDelegate = self
        webview.navigationDelegate = self
        webview.load(URLRequest(url: URL(string: url)!))
        view.addSubview(webview)
        webview.frame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64)
    }
    
    private lazy var configuretion: WKWebViewConfiguration = {
        
        let configuretion = WKWebViewConfiguration()
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        configuretion.processPool = WKProcessPool()
        configuretion.userContentController = WKUserContentController()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        configuretion.userContentController.add(self, name: "linkAccount")
        configuretion.userContentController.add(self, name: "skillrw_dsk_las_dp")
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = true
        return configuretion
    }()
    
    private lazy var webview: PQWebView = {
        
        let webview = PQWebView(frame: .zero, configuration: configuretion)
        
        return webview
    }()
    
    private var fwBtnIsHidden = false
}

extension FloatingWindowController: WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler {
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    // 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    //点击
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if !((navigationAction.targetFrame?.isMainFrame)!) {
            
            webView.evaluateJavaScript("var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}", completionHandler: nil)
        }
        
        if navigationAction.targetFrame == nil {
            
            webView.load(navigationAction.request)
        }
        
        decisionHandler(.allow)
    }
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    
    func webView(_ webView: WKWebView, shouldPreviewElement elementInfo: WKPreviewElementInfo) -> Bool {
        
        let requestURL = elementInfo.linkURL
        
        if requestURL?.scheme == "http" || requestURL?.scheme == "https" || requestURL?.scheme == "mailto" {
            
            return !UIApplication.shared.canOpenURL(requestURL!)
        }
        return true
    }
    // 创建一个新的WebView
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        
        UIApplication.shared.canOpenURL(navigationAction.request.url!)
        
        return nil
    }
    //输入框
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        completionHandler("http")
    }
    //确认框
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        completionHandler(true)
    }
    //警告框
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        completionHandler()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
}


extension FloatingWindowController{
    @objc private func leftBarbuttonClick(){

        navigationController?.popViewController(animated: true)
    }
    
    @objc private func rightBarButtonClick(){
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if fwBtnIsHidden == true {
            alert.addAction(UIAlertAction(title: "浮窗", style: .default, handler: {[weak self] (action) in
                self?.fwBtnIsHidden = false
                self?.leftBarbuttonClick()
            }))
        }else{
            alert.addAction(UIAlertAction(title: "取消浮窗", style: UIAlertActionStyle.default, handler: {[weak self] (action) in

                self?.fwBtnIsHidden = true
            }))
        }
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

extension FloatingWindowController: UINavigationControllerDelegate {

    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .push {
            return TransitionAnimator(isPush: true, animation: .overlay)
        }
        
        if operation == .pop && !fwBtnIsHidden {
            return TransitionAnimator(isPush: false, animation: .overlay)
        }
        
        return nil
    }
}



extension FloatingWindowController: UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool{
        
        return navigationController?.viewControllers.count == 1 ? false : true
    }
}
