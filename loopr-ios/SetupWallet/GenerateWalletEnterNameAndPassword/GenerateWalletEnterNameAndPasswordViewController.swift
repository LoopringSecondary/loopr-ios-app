//
//  GenerateWalletViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/4/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class GenerateWalletEnterNameAndPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var backgroundView: UIView!
    
    // Scrollable UI components
    var walletNameTextField: UITextField = UITextField()
    var walletNameUnderLine: UIView = UIView()
    var walletNameInfoLabel: UILabel = UILabel()
    
    var walletPasswordTextField: UITextField = UITextField()
    var walletPasswordUnderLine: UIView = UIView()
    var walletPasswordInfoLabel: UILabel = UILabel()
    
    var walletRepeatPasswordTextField: UITextField = UITextField()
    var walletRepeatPasswordUnderLine: UIView = UIView()
    var walletRepeatPasswordInfoLabel: UILabel = UILabel()
    
    var continueButton: UIButton = UIButton()
    
    // Keyboard
    var isKeyboardShown: Bool = false
    var keyboardOffsetY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // self.navigationItem.title = LocalizedString("Generate Wallet", comment: "")
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        
        // self.navigationController?.isNavigationBarHidden = false
        
        backgroundView.isUserInteractionEnabled = true
        
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        // let screenHeight = screensize.height
        
        let originY: CGFloat = 30
        let padding: CGFloat = 15

        walletNameTextField.delegate = self
        walletNameTextField.tag = 0
        // walletNameTextField.inputView = UIView()
        walletNameTextField.theme_tintColor = GlobalPicker.textColor
        walletNameTextField.font = FontConfigManager.shared.getLabelENFont(size: 19)
        walletNameTextField.placeholder = LocalizedString("Give your wallet an awesome name", comment: "")
        walletNameTextField.contentMode = UIViewContentMode.bottom
        walletNameTextField.frame = CGRect(x: padding, y: originY, width: screenWidth-padding*2, height: 40)
        backgroundView.addSubview(walletNameTextField)
        
        walletNameUnderLine.frame = CGRect(x: padding, y: walletNameTextField.frame.maxY, width: screenWidth - padding * 2, height: 1)
        walletNameUnderLine.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundView.addSubview(walletNameUnderLine)
        
        walletNameInfoLabel.frame = CGRect(x: padding, y: walletNameUnderLine.frame.maxY + 9, width: screenWidth - padding * 2, height: 16)
        walletNameInfoLabel.text = LocalizedString("Please enter a wallet name", comment: "")
        walletNameInfoLabel.font = UIFont.init(name: FontConfigManager.shared.getLight(), size: 16)
        walletNameInfoLabel.textColor = UIStyleConfig.red
        walletNameInfoLabel.alpha = 0.0
        backgroundView.addSubview(walletNameInfoLabel)
        
        walletPasswordTextField.isSecureTextEntry = true
        walletPasswordTextField.delegate = self
        walletPasswordTextField.tag = 1
        // walletPasswordTextField.inputView = UIView()
        walletPasswordTextField.theme_tintColor = GlobalPicker.textColor
        walletPasswordTextField.font = FontConfigManager.shared.getLabelENFont(size: 19)
        walletPasswordTextField.placeholder = LocalizedString("Password", comment: "")
        walletPasswordTextField.contentMode = UIViewContentMode.bottom
        walletPasswordTextField.frame = CGRect(x: padding, y: walletNameUnderLine.frame.maxY + 45, width: screenWidth-padding*2, height: 40)
        backgroundView.addSubview(walletPasswordTextField)
        
        walletPasswordUnderLine.frame = CGRect(x: padding, y: walletPasswordTextField.frame.maxY, width: screenWidth - padding * 2, height: 1)
        walletPasswordUnderLine.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundView.addSubview(walletPasswordUnderLine)
        
        walletPasswordInfoLabel.frame = CGRect(x: padding, y: walletPasswordTextField.frame.maxY + 9, width: screenWidth - padding * 2, height: 16)
        walletPasswordInfoLabel.text = LocalizedString("Please set a password", comment: "")
        walletPasswordInfoLabel.font = UIFont.init(name: FontConfigManager.shared.getLight(), size: 16)
        walletPasswordInfoLabel.textColor = UIStyleConfig.red
        walletPasswordInfoLabel.alpha = 0.0
        backgroundView.addSubview(walletPasswordInfoLabel)
        
        // Repeat password
        walletRepeatPasswordTextField.isSecureTextEntry = true
        walletRepeatPasswordTextField.delegate = self
        walletRepeatPasswordTextField.tag = 2
        // walletPasswordTextField.inputView = UIView()
        walletRepeatPasswordTextField.theme_tintColor = GlobalPicker.textColor
        walletRepeatPasswordTextField.font = FontConfigManager.shared.getLabelENFont(size: 19)
        walletRepeatPasswordTextField.placeholder = LocalizedString("Confirm password", comment: "")
        walletRepeatPasswordTextField.contentMode = UIViewContentMode.bottom
        walletRepeatPasswordTextField.frame = CGRect(x: padding, y: walletPasswordUnderLine.frame.maxY + 45, width: screenWidth-padding*2, height: 40)
        backgroundView.addSubview(walletRepeatPasswordTextField)
        
        walletRepeatPasswordUnderLine.frame = CGRect(x: padding, y: walletRepeatPasswordTextField.frame.maxY, width: screenWidth - padding * 2, height: 1)
        walletRepeatPasswordUnderLine.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        backgroundView.addSubview(walletRepeatPasswordUnderLine)
        
        walletRepeatPasswordInfoLabel.frame = CGRect(x: padding, y: walletRepeatPasswordTextField.frame.maxY + 9, width: screenWidth - padding * 2, height: 16)
        walletRepeatPasswordInfoLabel.text = LocalizedString("Confirm your password", comment: "")
        walletRepeatPasswordInfoLabel.font = UIFont.init(name: FontConfigManager.shared.getLight(), size: 16)
        walletRepeatPasswordInfoLabel.textColor = UIStyleConfig.red
        walletRepeatPasswordInfoLabel.alpha = 0.0
        backgroundView.addSubview(walletRepeatPasswordInfoLabel)
        
        continueButton.setupRoundBlack()
        continueButton.frame = CGRect(x: padding, y: walletRepeatPasswordUnderLine.frame.maxY + 50, width: screenWidth - padding * 2, height: 47)
        continueButton.addTarget(self, action: #selector(pressedContinueButton), for: .touchUpInside)
        backgroundView.addSubview(continueButton)
        
        backgroundView.theme_backgroundColor = GlobalPicker.backgroundColor
        
        // UI will be different based on SetupWalletMethod
        self.navigationItem.title = LocalizedString("Create a new wallet", comment: "")
        continueButton.setTitle(LocalizedString("Continue", comment: ""), for: .normal)
        
        // Generate a new wallet
        _ = GenerateWalletDataManager.shared.new()
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        backgroundView.addGestureRecognizer(scrollViewTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("Generate Wallet", comment: ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @objc func pressedContinueButton(_ sender: Any) {
        guard AppWalletDataManager.shared.isNewWalletNameToken(newWalletname: walletNameTextField.text ?? "") else {
            let title = LocalizedString("The name is token, please try another one", comment: "")
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: LocalizedString("OK", comment: ""), style: .default, handler: { _ in
                
            }))
            self.present(alert, animated: true, completion: nil)
            return
        }

        pressedContinueButtonInCreate()
    }
    
    func pressedContinueButtonInCreate() {
        var validWalletName = true
        var validPassword = true
        var validRepeatPassword = true
        
        let walletName = walletNameTextField.text ?? ""
        if walletName.trim() == "" {
            validWalletName = false
            self.walletNameInfoLabel.shake()
            self.walletNameInfoLabel.alpha = 1.0
        }
        
        let password = walletPasswordTextField.text ?? ""
        if password.trim() == "" {
            validPassword = false
            self.walletPasswordInfoLabel.shake()
            self.walletPasswordInfoLabel.alpha = 1.0
        }
        
        let repeatPassword = walletRepeatPasswordTextField.text ?? ""
        if repeatPassword.trim() == "" {
            validRepeatPassword = false
        }
        if password != repeatPassword {
            validRepeatPassword = false
            self.walletRepeatPasswordInfoLabel.text = LocalizedString("Please input the consistant password", comment: "")
        }
        if !validRepeatPassword {
            self.walletRepeatPasswordInfoLabel.shake()
            self.walletRepeatPasswordInfoLabel.alpha = 1.0
        }
        
        if validWalletName && validPassword && validRepeatPassword {
            GenerateWalletDataManager.shared.setWalletName(walletName)
            GenerateWalletDataManager.shared.setPassword(password)
            // let viewController = GenerateMnemonicViewController()
            let viewController = BackupMnemonicViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + (string.utf16.count) - range.length
        print("textField shouldChangeCharactersIn \(newLength)")
        
        switch textField.tag {
        case walletNameTextField.tag:
            if newLength > 0 {
                walletNameInfoLabel.alpha = 0.0
                walletNameUnderLine.backgroundColor = UIColor.black
            } else {
                walletNameUnderLine.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            }
        case walletPasswordTextField.tag:
            if newLength > 0 {
                walletPasswordInfoLabel.alpha = 0.0
                walletPasswordUnderLine.backgroundColor = UIColor.black
            } else {
                walletPasswordUnderLine.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            }
        case walletRepeatPasswordTextField.tag:
            if newLength > 0 {
                walletRepeatPasswordInfoLabel.alpha = 0.0
                walletRepeatPasswordUnderLine.backgroundColor = UIColor.black
            } else {
                walletRepeatPasswordUnderLine.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            }
        default: ()
        }
        return true
    }
    
    @objc func scrollViewTapped() {
        // Hide the keyboard and adjust the position
        walletNameTextField.resignFirstResponder()
        walletPasswordTextField.resignFirstResponder()
        walletRepeatPasswordTextField.resignFirstResponder()
        
        if isKeyboardShown {
            UIView.animate(withDuration: 0.4, animations: {
                // Wallet Name
                self.walletNameTextField.moveOffset(y: self.keyboardOffsetY)
                self.walletNameUnderLine.moveOffset(y: self.keyboardOffsetY)
                self.walletNameInfoLabel.moveOffset(y: self.keyboardOffsetY)
                
                // Wallet Password
                self.walletPasswordTextField.moveOffset(y: self.keyboardOffsetY)
                self.walletPasswordUnderLine.moveOffset(y: self.keyboardOffsetY)
                self.walletPasswordInfoLabel.moveOffset(y: self.keyboardOffsetY)
                
                self.walletRepeatPasswordTextField.moveOffset(y: self.keyboardOffsetY)
                self.walletRepeatPasswordUnderLine.moveOffset(y: self.keyboardOffsetY)
                self.walletRepeatPasswordInfoLabel.moveOffset(y: self.keyboardOffsetY)
                
                // continueButton
                self.continueButton.moveOffset(y: self.keyboardOffsetY)
            })
            isKeyboardShown = false
        }
    }
    
    @objc func systemKeyboardWillShow(_ notification: Notification) {
        if !isKeyboardShown {
            guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
                return
            }
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                let bottomPadding = window?.safeAreaInsets.bottom ?? 0
                let keyboardMinY = self.view.frame.height - keyboardHeight - bottomPadding
                
                keyboardOffsetY = (continueButton.frame.maxY + 20.0) - keyboardMinY

                if keyboardOffsetY > 0 {
                    UIView.animate(withDuration: 1.0, animations: {
                        // Wallet Name
                        self.walletNameTextField.moveOffset(y: -self.keyboardOffsetY)
                        self.walletNameUnderLine.moveOffset(y: -self.keyboardOffsetY)
                        self.walletNameInfoLabel.moveOffset(y: -self.keyboardOffsetY)
                        
                        // Wallet Password
                        self.walletPasswordTextField.moveOffset(y: -self.keyboardOffsetY)
                        self.walletPasswordUnderLine.moveOffset(y: -self.keyboardOffsetY)
                        self.walletPasswordInfoLabel.moveOffset(y: -self.keyboardOffsetY)
                        
                        self.walletRepeatPasswordTextField.moveOffset(y: -self.keyboardOffsetY)
                        self.walletRepeatPasswordUnderLine.moveOffset(y: -self.keyboardOffsetY)
                        self.walletRepeatPasswordInfoLabel.moveOffset(y: -self.keyboardOffsetY)

                        // continueButton
                        self.continueButton.moveOffset(y: -self.keyboardOffsetY)
                    })
                    
                    isKeyboardShown = true
                }
            } else {
                
            }
        }
    }
    
    @objc func systemKeyboardWillDisappear(notification: NSNotification?) {
        print("keyboardWillDisappear")
    }
}
