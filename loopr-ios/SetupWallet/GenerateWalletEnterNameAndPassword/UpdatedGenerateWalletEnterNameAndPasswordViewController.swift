//
//  UpdatedGenerateWalletEnterNameAndPasswordViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/20/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedGenerateWalletEnterNameAndPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startInfolbel: UILabel!
    
    @IBOutlet weak var backgroundImageHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageTopLayoutConstraint: NSLayoutConstraint!    

    // Scrollable UI components
    var mainScrollView: UIScrollView = UIScrollView()
    
    var infoImage: UIImageView = UIImageView()
    var infoLabel: UILabel = UILabel()
    
    var walletNameInfoLabel: UILabel = UILabel()
    var walletNameTextField: UITextField = UITextField()
    
    var walletPasswordInfoLabel: UILabel = UILabel()
    var walletPasswordTextField: UITextField = UITextField()
    
    var walletRepeatPasswordInfoLabel: UILabel = UILabel()
    var walletRepeatPasswordTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Add swipe to go-back feature back which is a system default gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        let navigationItem = UINavigationItem()
        navigationItem.title = NSLocalizedString("Generate Wallet", comment: "")
        customizedNavigationBar.setItems([navigationItem], animated: false)

        statusBarBackgroundView.backgroundColor = UIColor.init(rgba: "#2E2BA4")
        
        // TODO: this is broken.
        customizedNavigationBar.isTranslucent = false
        customizedNavigationBar.barTintColor = UIColor.init(rgba: "#2E2BA4")
        
        // Generate a new wallet
        _ = GenerateWalletDataManager.shared.new()
        
        nextButton.addTarget(self, action: #selector(pressedContinueButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        // TODO: not sure why we have to set this value here. Setting in storyboard doesn't work.
        startInfolbel.font = UIFont.init(name: "Futura-Bold", size: 31)
        
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
        let originY: CGFloat = 345
        let paddingLeft: CGFloat = 47
        let textFieldHeight: CGFloat = 43
        
        mainScrollView.frame = CGRect(x: 0, y: backgroundImageHeightLayoutConstraint.constant, width: screenWidth, height: screenHeight-backgroundImageHeightLayoutConstraint.constant)
        mainScrollView.backgroundColor = .white
        mainScrollView.isScrollEnabled = false
        
        infoImage.frame = CGRect(x: 48, y: 37, width: 16.5, height: 16.5)
        infoImage.image = UIImage.init(named: "Tokenest-setup-info-icon")
        mainScrollView.addSubview(infoImage)
        
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        infoLabel.frame = CGRect(x: 72, y: 36, width: screenWidth, height: 34)
        infoLabel.numberOfLines = 2
        let attr = NSMutableAttributedString(string: "钱包密码用于导出私钥，交易设置时验证您的身份" + "\n" + "长度不少于6位")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        infoLabel.attributedText = attr
        mainScrollView.addSubview(infoLabel)

        walletNameInfoLabel.textColor = UIColor.tokenestTip
        walletNameInfoLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        walletNameInfoLabel.frame = CGRect(x: 74, y: 105, width: 200, height: 17)
        walletNameInfoLabel.text = NSLocalizedString("Wallet Name", comment: "")
        mainScrollView.addSubview(walletNameInfoLabel)
        
        walletNameTextField.delegate = self
        walletNameTextField.tag = 0
        walletNameTextField.frame = CGRect(x: paddingLeft, y: 128, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        walletNameTextField.setTokenestStyle()
        mainScrollView.addSubview(walletNameTextField)
        
        walletPasswordInfoLabel.textColor = UIColor.tokenestTip
        walletPasswordInfoLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        walletPasswordInfoLabel.frame = CGRect(x: 74, y: 186, width: 200, height: 17)
        walletPasswordInfoLabel.text = NSLocalizedString("Password", comment: "")
        mainScrollView.addSubview(walletPasswordInfoLabel)
        
        walletPasswordTextField.isSecureTextEntry = true
        walletPasswordTextField.autocorrectionType = .no
        walletPasswordTextField.delegate = self
        walletPasswordTextField.tag = 1
        walletPasswordTextField.frame = CGRect(x: paddingLeft, y: 209, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        walletPasswordTextField.setTokenestStyle()
        mainScrollView.addSubview(walletPasswordTextField)
        
        walletRepeatPasswordInfoLabel.textColor = UIColor.tokenestTip
        walletRepeatPasswordInfoLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        walletRepeatPasswordInfoLabel.frame = CGRect(x: 74, y: 267, width: 200, height: 17)
        walletRepeatPasswordInfoLabel.text = NSLocalizedString("Repeat Password", comment: "")
        mainScrollView.addSubview(walletRepeatPasswordInfoLabel)
        
        walletRepeatPasswordTextField.isSecureTextEntry = true
        walletRepeatPasswordTextField.autocorrectionType = .no
        walletRepeatPasswordTextField.delegate = self
        walletRepeatPasswordTextField.tag = 2
        walletRepeatPasswordTextField.frame = CGRect(x: paddingLeft, y: 290, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        walletRepeatPasswordTextField.setTokenestStyle()
        mainScrollView.addSubview(walletRepeatPasswordTextField)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        mainScrollView.addGestureRecognizer(scrollViewTap)
        
        view.addSubview(mainScrollView)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        let doneBarButton = UIBarButtonItem(title: NSLocalizedString("Complete", comment: ""), style: .plain, target: self, action: #selector(doneWithNumberPad))
        doneBarButton.setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor(rgba: "#4350CC"),
            NSAttributedStringKey.font: FontConfigManager.shared.getLabelFont(size: 16)
            ], for: .normal)
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            doneBarButton]
        numberToolbar.sizeToFit()
        
        walletNameTextField.inputAccessoryView = numberToolbar
        walletPasswordTextField.inputAccessoryView = numberToolbar
        walletRepeatPasswordTextField.inputAccessoryView = numberToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneWithNumberPad(_ sender: Any) {
        pressedContinueButton(sender)
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        walletNameTextField.resignFirstResponder()
        walletPasswordTextField.resignFirstResponder()
        walletRepeatPasswordInfoLabel.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func systemKeyboardWillShow(_ notification: Notification) {
        print("systemKeyboardWillShow")
        self.backgroundImageTopLayoutConstraint.constant = -backgroundImageHeightLayoutConstraint.constant
        
        UIView.animate(withDuration: 10, delay: 0, options: .curveEaseInOut, animations: {
            self.mainScrollView.y = self.customizedNavigationBar.bottomY
            self.view.layoutIfNeeded()
        }) { (_) in
            
        }
    }
    
    @objc func systemKeyboardWillDisappear(notification: NSNotification?) {
        print("keyboardWillDisappear")
        self.backgroundImageTopLayoutConstraint.constant = 0

        UIView.animate(withDuration: 10, delay: 0, options: .curveEaseInOut, animations: {
            self.mainScrollView.bottomY = self.view.bottomY
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
            self.walletNameInfoLabel.textColor = UIColor.red
        }
        
        let password = walletPasswordTextField.text ?? ""
        if password.trim() == "" {
            validPassword = false
            self.walletPasswordInfoLabel.shake()
            self.walletPasswordInfoLabel.textColor = UIColor.red
        }
        
        let repeatPassword = walletRepeatPasswordTextField.text ?? ""
        if repeatPassword.trim() == "" {
            validRepeatPassword = false
        }
        if password != repeatPassword {
            validRepeatPassword = false
            self.walletRepeatPasswordInfoLabel.text = NSLocalizedString("Please input the consistant password.", comment: "")
        }
        if !validRepeatPassword {
            self.walletRepeatPasswordInfoLabel.shake()
            self.walletRepeatPasswordInfoLabel.textColor = UIColor.red
        }
        
        if validWalletName && validPassword && validRepeatPassword {
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
                walletNameInfoLabel.textColor = UIColor.red
            }
        case walletPasswordTextField.tag:
            if newLength > 0 {
                walletPasswordInfoLabel.textColor = UIColor.tokenestTip
            } else {
                walletPasswordInfoLabel.shake()
                walletPasswordInfoLabel.textColor = UIColor.red
            }
        case walletRepeatPasswordTextField.tag:
            if newLength > 0 {
                walletRepeatPasswordInfoLabel.textColor = UIColor.tokenestTip
            } else {
                walletRepeatPasswordInfoLabel.shake()
                walletRepeatPasswordInfoLabel.textColor = UIColor.red
            }
        default: ()
        }
        return true
    }
}
