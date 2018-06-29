//
//  UpdatedGenerateWalletEnterNameAndPasswordViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/20/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import SwiftTheme

class UpdatedGenerateWalletEnterNameAndPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startInfolbel: UILabel!
    
    @IBOutlet weak var backgroundImageHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageTopLayoutConstraint: NSLayoutConstraint!
    
    var isPushedInParentViewController: Bool = true

    // Scrollable UI components
    var mainScrollView: UIScrollView = UIScrollView()
    let scrollViewHeight: CGFloat = 360  // measured in sketch file.
    
    var infoImage: UIImageView = UIImageView()
    var infoLabel: UILabel = UILabel()
    
    var walletNameInfoLabel: UILabel = UILabel()
    var walletNameTextField: UITextField = UITextField()
    
    var passwordInfoLabel: UILabel = UILabel()
    var passwordTextField: UITextField = UITextField()
    
    var repeatPasswordInfoLabel: UILabel = UILabel()
    var repeatPasswordTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Generate a new wallet
        _ = GenerateWalletDataManager.shared.new()

        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        
        // Add swipe to go-back feature back which is a system default gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // Update the navigation bar
        let navigationItem = UINavigationItem()
        navigationItem.title = NSLocalizedString("Generate Wallet", comment: "")
        customizedNavigationBar.setItems([navigationItem], animated: false)

        statusBarBackgroundView.backgroundColor = UIColor.init(rgba: "#2E2BA4")
        
        nextButton.addTarget(self, action: #selector(pressedContinueButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        // TODO: not sure why we have to set this value here. Setting in storyboard doesn't work.
        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)
        
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        // let screenHeight = screensize.height
        
        // let originY: CGFloat = 345
        let paddingLeft: CGFloat = 47
        let textFieldHeight: CGFloat = 43
        
        mainScrollView.frame = CGRect(x: 0, y: backgroundImageHeightLayoutConstraint.constant, width: screenWidth, height: scrollViewHeight)
        mainScrollView.contentSize = CGSize(width: screenWidth, height: scrollViewHeight)
        mainScrollView.backgroundColor = .white
        
        infoImage.frame = CGRect(x: 48, y: 37, width: 16.5, height: 16.5)
        infoImage.image = UIImage.init(named: "Tokenest-setup-info-icon")
        mainScrollView.addSubview(infoImage)
        
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        infoLabel.frame = CGRect(x: 72, y: 36, width: screenWidth, height: 34)
        infoLabel.numberOfLines = 2
        let attr = NSMutableAttributedString(string: "钱包密码用于导出私钥，交易设置时验证您的身份" + "\n" + "长度不少于6位")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        infoLabel.attributedText = attr
        mainScrollView.addSubview(infoLabel)

        walletNameInfoLabel.textColor = UIColor.tokenestTip
        walletNameInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        walletNameInfoLabel.frame = CGRect(x: 74, y: 105, width: 200, height: 17)
        walletNameInfoLabel.text = NSLocalizedString("Wallet Name", comment: "")
        mainScrollView.addSubview(walletNameInfoLabel)
        
        walletNameTextField.delegate = self
        walletNameTextField.tag = 0
        walletNameTextField.frame = CGRect(x: paddingLeft, y: 128, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        walletNameTextField.setTokenestStyle()
        mainScrollView.addSubview(walletNameTextField)
        
        passwordInfoLabel.textColor = UIColor.tokenestTip
        passwordInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        passwordInfoLabel.frame = CGRect(x: 74, y: 186, width: 200, height: 17)
        passwordInfoLabel.text = NSLocalizedString("Password", comment: "")
        mainScrollView.addSubview(passwordInfoLabel)
        
        passwordTextField.textContentType = UITextContentType("")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        passwordTextField.frame = CGRect(x: paddingLeft, y: 209, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        passwordTextField.setTokenestStyle()
        mainScrollView.addSubview(passwordTextField)
        
        repeatPasswordInfoLabel.textColor = UIColor.tokenestTip
        repeatPasswordInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        repeatPasswordInfoLabel.frame = CGRect(x: 74, y: 267, width: 200, height: 17)
        repeatPasswordInfoLabel.text = NSLocalizedString("Repeat Password", comment: "")
        mainScrollView.addSubview(repeatPasswordInfoLabel)
        
        repeatPasswordTextField.textContentType = UITextContentType("")
        repeatPasswordTextField.isSecureTextEntry = true
        repeatPasswordTextField.autocorrectionType = .no
        repeatPasswordTextField.delegate = self
        repeatPasswordTextField.tag = 2
        repeatPasswordTextField.frame = CGRect(x: paddingLeft, y: 290, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        repeatPasswordTextField.setTokenestStyle()
        mainScrollView.addSubview(repeatPasswordTextField)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        mainScrollView.addGestureRecognizer(scrollViewTap)
        
        view.addSubview(mainScrollView)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Complete", comment: ""), style: .plain, target: self, action: #selector(doneWithNumberPad))
        doneBarButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor(rgba: "#4350CC"),
            NSAttributedStringKey.font: FontConfigManager.shared.getLabelENFont(size: 16)
            ], for: .normal)
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBarButton]
        numberToolbar.sizeToFit()
        
        walletNameTextField.inputAccessoryView = numberToolbar
        passwordTextField.inputAccessoryView = numberToolbar
        repeatPasswordTextField.inputAccessoryView = numberToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        if isPushedInParentViewController {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    @objc func doneWithNumberPad(_ sender: Any) {
        pressedContinueButton(sender)
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        walletNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        repeatPasswordInfoLabel.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func systemKeyboardWillShow(_ notification: Notification) {
        print("systemKeyboardWillShow")
        self.backgroundImageTopLayoutConstraint.constant = -backgroundImageHeightLayoutConstraint.constant
        
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let systemKeyboardHeight = keyboardFrame.cgRectValue.height
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        let height = self.view.bounds.height - self.customizedNavigationBar.bottomY - (systemKeyboardHeight + bottomPadding)
        print(height)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.mainScrollView.frame = CGRect(x: 0, y: self.customizedNavigationBar.bottomY, width: UIScreen.main.bounds.width, height: height)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    @objc func systemKeyboardWillDisappear(notification: NSNotification?) {
        print("keyboardWillDisappear")
        self.backgroundImageTopLayoutConstraint.constant = 0

        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.mainScrollView.frame = CGRect(x: 0, y: self.backgroundImageHeightLayoutConstraint.constant, width: UIScreen.main.bounds.width, height: self.scrollViewHeight)
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    @objc func pressedContinueButton(_ sender: Any) {
        guard AppWalletDataManager.shared.isNewWalletNameToken(newWalletname: walletNameTextField.text ?? "") else {
            let title = NSLocalizedString("The name is token, please try another one", comment: "")
            let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                
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
            self.walletNameInfoLabel.textColor = UIStyleConfig.red
        }
        
        let password = passwordTextField.text ?? ""
        if password.trim() == "" {
            validPassword = false
            self.passwordInfoLabel.shake()
            self.passwordInfoLabel.textColor = UIStyleConfig.red
        }
        
        if password.trim().count < 6 {
            validPassword = false
            self.passwordInfoLabel.shake()
            self.passwordInfoLabel.textColor = UIStyleConfig.red
            self.passwordInfoLabel.text = "密码长度应不少于6位"
        }
        
        let repeatPassword = repeatPasswordTextField.text ?? ""
        if repeatPassword.trim() == "" {
            validRepeatPassword = false
        }
        if password != repeatPassword {
            validRepeatPassword = false
            self.repeatPasswordInfoLabel.text = NSLocalizedString("Please input the consistant password", comment: "")
        }
        if !validRepeatPassword {
            self.repeatPasswordInfoLabel.shake()
            self.repeatPasswordInfoLabel.textColor = UIStyleConfig.red
        }
        
        if validWalletName && validPassword && validRepeatPassword {
            walletNameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            repeatPasswordInfoLabel.resignFirstResponder()
            self.view.endEditing(true)
            
            GenerateWalletDataManager.shared.setWalletName(walletName)
            GenerateWalletDataManager.shared.setPassword(password)
            let viewController = ListMnemonicViewController()
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + (string.utf16.count) - range.length
        print("textField shouldChangeCharactersIn \(newLength)")
        
        switch textField.tag {
        case walletNameTextField.tag:
            if newLength > 0 {
                walletNameInfoLabel.textColor = UIColor.tokenestTip
            } else {
                walletNameInfoLabel.shake()
                walletNameInfoLabel.textColor = UIStyleConfig.red
            }
        case passwordTextField.tag:
            if newLength > 0 && newLength < 6 {
                passwordInfoLabel.textColor = UIColor.tokenestTip
                passwordInfoLabel.text = NSLocalizedString("Password", comment: "")
            } else if newLength >= 6 {
                passwordInfoLabel.textColor = UIColor.tokenestTip
                passwordInfoLabel.text = NSLocalizedString("Password", comment: "")
            } else {
                passwordInfoLabel.shake()
                passwordInfoLabel.textColor = UIStyleConfig.red
            }
        case repeatPasswordTextField.tag:
            if newLength > 0 {
                repeatPasswordInfoLabel.text = NSLocalizedString("Repeat Password", comment: "")
                repeatPasswordInfoLabel.textColor = UIColor.tokenestTip
            } else {
                repeatPasswordInfoLabel.shake()
                repeatPasswordInfoLabel.textColor = UIStyleConfig.red
            }
        default: ()
        }
        return true
    }
}
