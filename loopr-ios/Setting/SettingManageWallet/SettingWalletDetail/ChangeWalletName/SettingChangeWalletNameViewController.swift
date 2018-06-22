//
//  SettingChangeWalletNameViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/10/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingChangeWalletNameViewController: UIViewController, UITextFieldDelegate {

    var appWallet: AppWallet!
    var nameTextField: UITextField = UITextField()
    var nameFieldUnderLine: UIView = UIView()
    var saveButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        // let screenHeight = screensize.height
        
        let originY: CGFloat = 30
        let padding: CGFloat = 15
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = NSLocalizedString("Change Wallet Name", comment: "")
        setBackButton()
        
        nameTextField.delegate = self
        nameTextField.tag = 0
        nameTextField.font = FontConfigManager.shared.getLabelENFont()
        nameTextField.theme_tintColor = GlobalPicker.textColor
        nameTextField.placeholder = "Enter your wallet name"
        nameTextField.contentMode = UIViewContentMode.bottom
        nameTextField.frame = CGRect(x: padding, y: originY, width: screenWidth-padding*2, height: 40)
        self.view.addSubview(nameTextField)
        
        nameFieldUnderLine.frame = CGRect(x: padding, y: nameTextField.frame.maxY, width: screenWidth - padding * 2, height: 1)
        nameFieldUnderLine.backgroundColor = UIColor.black
        self.view.addSubview(nameFieldUnderLine)
        
        saveButton.setupRoundBlack()
        saveButton.setTitle(NSLocalizedString("Save", comment: ""), for: .normal)
        saveButton.frame = CGRect(x: padding, y: nameFieldUnderLine.frame.maxY + padding*2 + 10, width: screenWidth - padding*2, height: 47)
        saveButton.addTarget(self, action: #selector(pressedSaveButton), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        nameTextField.text = appWallet.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func pressedSaveButton(_ sender: Any) {
        print("pressedSwitchTokenBButton: \(appWallet)")
        print("wallet Name is: \(appWallet.name)")
        
        if nameTextField.text?.count != 0 {
            appWallet.name = nameTextField.text!
            let dataManager = AppWalletDataManager.shared
            dataManager.updateAppWalletsInLocalStorage(newAppWallet: appWallet)
            self.navigationController?.popViewController(animated: true)
        } else {
            
            let alertController = UIAlertController(title: "New wallet name can't be empty", message: nil, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }

    }
}
