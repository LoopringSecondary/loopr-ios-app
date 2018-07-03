//
//  LoginResultViewController.swift
//  loopr-ios
//
//  Created by kenshin on 2018/6/11.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

class LoginResultViewController: UIViewController {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var customNavBar: UINavigationBar!
    
    var result: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        statusBar.backgroundColor = GlobalPicker.themeColor
        self.navigationController?.isNavigationBarHidden = true
        
        customNavBar.backgroundColor = UIColor.tokenestBackground
        customNavBar.isTranslucent = true
        customNavBar.setBackgroundImage(UIImage(), for: .default)
        customNavBar.shadowImage = UIImage()
        customNavBar.topItem?.title = "授权结果"
        
        resultLabel.textColor = UIColor.tokenestTableFont
        resultLabel.font = FontConfigManager.shared.getLabelSCFont(size: 40, type: "Bold")
        detailLabel.font = FontConfigManager.shared.getLabelSCFont(size: 21)
        detailLabel.textColor = UIColor.tokenestTip
        
        doneButton.title = LocalizedString("Done", comment: "")
        doneButton.layer.shadowColor = UIColor.tokenestBackground.cgColor
        doneButton.layer.shadowOpacity = 0.3
        doneButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        doneButton.layer.shadowRadius = 8
        doneButton.clipsToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if result {
            resultLabel.text = LocalizedString("Authorze Successfully", comment: "")
            detailLabel.text = LocalizedString("Login Authorzation Successful! Please transfer to our website to continue.", comment: "")
        } else {
            resultLabel.text = LocalizedString("Authorze Failed", comment: "")
            detailLabel.text = LocalizedString("Login Authorzation failed! Please review your signing address and try again later.", comment: "")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pressedDoneButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
