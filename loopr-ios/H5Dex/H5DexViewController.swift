//
//  H5DexViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/13/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit
import WebKit
import JavaScriptCore

class H5DexViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, UIScrollViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var urlTextField: UITextField!
    
    var webView: WKWebView!
    var dexRequest: DexRequest!
    var start = Date()
    var end = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.isNavigationBarHidden = true
        H5DexDataManager.shared.sendClosure = self.sendDataToHtml
        urlTextField.delegate = self
        urlTextField.returnKeyType = UIReturnKeyType.done
    }

    func createWebView(url: URL) {
        let contentController = WKUserContentController()
        contentController.add(self, name: "nativeCallbackHandler")
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: config)
        let request = URLRequest(url: url)
        webView.load(request)
        self.view.addSubview(webView)
        // Auto Layout
        let topConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: UIApplication.shared.statusBarFrame.height)
        let botConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        let leftConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let rigthConst = NSLayoutConstraint(item: self.webView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([topConst, botConst, leftConst, rigthConst])
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        return false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start = Date()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let url = URL(string: textField.text!)
        self.createWebView(url: url!)
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        // start = Date()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished navigating to url")
        // sendDataToHtml()
        end = Date()
        let timeInterval: Double = end.timeIntervalSince(start)
        print("Time to _keystore: \(timeInterval) seconds")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("userContentController didReceive message")
        if message.name == "nativeCallbackHandler" {
            if let objStr = message.body as? String {
                let data: Data = objStr.data(using: .utf8)!
                let json = JSON(data)
                self.dexRequest = DexRequest(json: json)
                H5DexDataManager.shared.handle(request: dexRequest)
            }
        }
    }

    func sendDataToHtml(json: JSON) {
        if let jsonString = json.rawString(.utf8), let callback = self.dexRequest.callback {
            self.webView.evaluateJavaScript("\(callback)(\(jsonString))") { _, error in
                guard error == nil else {
                    print(error!)
                    return
                }
            }
        }
    }
}
