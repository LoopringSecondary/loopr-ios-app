//
//  TradeFAQDetailViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/29/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class TradeFAQDetailViewController: UIViewController {
    
    var tradeFAQPage: TradeFAQPage!

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        contentTextView.contentInset = UIEdgeInsets.init(top: 0, left: 24, bottom: 0, right: 24)
        
        let fileName: String
        if SettingDataManager.shared.getCurrentLanguage().name == "zh-Hans" {
            fileName = "\(tradeFAQPage.fileName)_zh-Hans"
        } else if SettingDataManager.shared.getCurrentLanguage().name == "en" {
            fileName = "\(tradeFAQPage.fileName)_en"
        } else {
            fileName = tradeFAQPage.fileName
        }

        if let url = Bundle.main.url(forResource: fileName, withExtension: "md"), let md = SwiftyMarkdown(url: url ) {
            if SettingDataManager.shared.getCurrentLanguage().name == "zh-Hans" {
                md.h1.fontName = "PingfangSC-Medium"
                md.body.fontName = "PingfangSC-Regular"
            } else {
                md.h1.fontName = "DINNextLTPro-Medium"
                md.body.fontName = "DINNextLTPro-Regular"
            }

            md.h1.fontSize = 18
            md.h1.color = UIColor.init(rgba: "#32384C")
            md.body.fontSize = 14
            md.body.color = UIColor.init(rgba: "#32384C")
                        
            contentTextView.attributedText = md.attributedString()
        } else {
            print("no found")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("Trade FAQ", comment: ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

}
