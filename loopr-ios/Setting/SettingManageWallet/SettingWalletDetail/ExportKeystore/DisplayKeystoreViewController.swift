//
//  DisplayKeystoreViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/7/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class DisplayKeystoreViewController: UIViewController {
    
    var keystore: String = ""
    
    @IBOutlet weak var keystoreTextView: UITextView!
    @IBOutlet weak var seperateLine: UIView!
    @IBOutlet weak var copyButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        keystoreTextView.text = keystore
        
        keystoreTextView.contentInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
        
        keystoreTextView.font = UIFont.init(name: FontConfigManager.shared.getLight(), size: 12.0)
        keystoreTextView.backgroundColor = UIColor.white
        keystoreTextView.textColor = UIColor.black
        keystoreTextView.isEditable = false
        keystoreTextView.borderColor = UIColor.init(rgba: "#8997F3")
        keystoreTextView.borderWidth = 0.5

        seperateLine.backgroundColor = UIColor(red: 205.0/255, green: 206.0/255, blue: 210.0/255, alpha: 1)

        copyButton.setTitle(LocalizedString("Copy", comment: ""), for: .normal)
        copyButton.setTitleColor(UIColor.init(rgba: "#3658ED"), for: .normal)
        copyButton.setTitleColor(UIColor.init(rgba: "#3658ED").withAlphaComponent(0.3), for: .highlighted)
        copyButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 17)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keystoreTextView.scrollRectToVisible(CGRect.zero, animated: false)
    }

    @IBAction func pressedCopyButton(_ sender: Any) {
        print("pressedCopyButton")
        UIPasteboard.general.string = keystore
        let banner = NotificationBanner.generate(title: "Copy keystore to clipboard successfully!", style: .success)
        banner.duration = 0.3
        banner.show()
    }
    
}
