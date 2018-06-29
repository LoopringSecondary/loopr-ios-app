//
//  SettingChangeWalletNameViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/10/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingChangeWalletNameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    var appWallet: AppWallet!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        view.backgroundColor = UIColor.init(rgba: "#F3F6F8")
        
        nameTextField.delegate = self
        nameTextField.tag = 0
        nameTextField.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        nameTextField.theme_tintColor = GlobalPicker.textColor
        nameTextField.placeholder = NSLocalizedString("New Wallet Name", comment: "")
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Complete", comment: ""), style: .plain, target: self, action: #selector(pressedSaveButton))
        doneBarButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor(rgba: "#4350CC"),
            NSAttributedStringKey.font: FontConfigManager.shared.getLabelENFont(size: 16)
            ], for: .normal)
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBarButton]
        numberToolbar.sizeToFit()
        
        nameTextField.inputAccessoryView = numberToolbar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("Update Wallet Name", comment: ""))
        
        let rightButton = UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: -16)
        rightButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        rightButton.title = NSLocalizedString("Confirmation", comment: "")
        rightButton.addTarget(self, action: #selector(pressedSaveButton), for: UIControlEvents.touchUpInside)
        let barButton = UIBarButtonItem(customView: rightButton)
        customizedNavigationBar.topItem?.rightBarButtonItem = barButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func pressedSaveButton(_ sender: Any) {
        print("pressedSwitchTokenBButton: \(appWallet)")
        print("wallet Name is: \(appWallet.name)")
        
        guard nameTextField.text?.count != 0 else {
            let alertController = UIAlertController(title: NSLocalizedString("New wallet name can't be empty", comment: ""), message: nil, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            })
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        guard AppWalletDataManager.shared.isNewWalletNameToken(newWalletname: nameTextField.text!) else {
            let title = NSLocalizedString("The name is token, please try another one", comment: "")
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        appWallet.name = nameTextField.text!
        let dataManager = AppWalletDataManager.shared
        dataManager.updateAppWalletsInLocalStorage(newAppWallet: appWallet)
        self.navigationController?.popViewController(animated: true)
    }
}
