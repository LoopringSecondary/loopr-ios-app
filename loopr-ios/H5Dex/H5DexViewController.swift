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

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    
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
        webView.navigationDelegate = self
        webView.scrollView.delegate = self
        self.webView.translatesAutoresizingMaskIntoConstraints = false
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
        let request = URLRequest(url: url!)
        webView.load(request)
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
