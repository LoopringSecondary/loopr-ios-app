//
//  AssetTransactionWebViewController.swift
//  loopr-ios
//
//  Created by kenshin on 2018/4/25.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit
import WebKit

class DefaultWebViewController: UIViewController {

    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var customNaviBar: UINavigationBar!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!

    var url: URL?
    var navigationTitle: String = ""
    var showProgressView: Bool = true
    private var progressKVOhandle: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressBar.backgroundColor = GlobalPicker.themeColor
        setBackButtonAndUpdateTitle(customizedNavigationBar: customNaviBar, title: navigationTitle)
        
        progressView.tintColor = UIColor.tokenestBackground
        progressView.setProgress(0, animated: false)
        progressView.alpha = 0.0
        
        let request = URLRequest(url: url!)
        wkWebView.navigationDelegate = self
        wkWebView.load(request)
        
        wkWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil) // add observer for key path
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        progressView.progress = Float(wkWebView.estimatedProgress)
    }

}

extension DefaultWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if showProgressView {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            progressView.alpha = 0.0
            UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut, animations: {
                self.progressView.alpha = 1.0
            })
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showProgressView = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        progressView.alpha = 1.0
        UIView.animate(withDuration: 0.33, delay: 0.0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0.0
        })
    }
}
