//
//  UpdatedUnlockWalletViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/23/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SVProgressHUD

class UpdatedUnlockWalletViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

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

    // var importMethod: QRCodeMethod = .importUsingKeystore
    var importMethod: QRCodeMethod = .importUsingPrivateKey
    var importMethodSelection: UIButton = UIButton()
    
    var contentTextView: UITextView = UITextView()
    
    var passwordInfoLabel: UILabel = UILabel()
    var passwordTextField: UITextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        
        // Add swipe to go-back feature back which is a system default gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // Update the navigation bar
        let navigationItem = UINavigationItem()
        navigationItem.title = NSLocalizedString("Import Wallet", comment: "")
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
        
        infoImage.frame = CGRect(x: 48, y: 37, width: 16.5, height: 16.5)
        infoImage.image = UIImage.init(named: "Tokenest-setup-info-icon")
        mainScrollView.addSubview(infoImage)
        
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        infoLabel.frame = CGRect(x: 72, y: 36, width: screenWidth - 72 - 35, height: 34)
        infoLabel.numberOfLines = 2
        let attr = NSMutableAttributedString(string: "Tokenest支持keystore, 私钥及助记词的导入，请选择您要导入钱包的方式并将内容黏贴至下框")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        infoLabel.attributedText = attr
        mainScrollView.addSubview(infoLabel)
        
        importMethodSelection.frame = CGRect(x: 74, y: 94, width: 90, height: 17)
        importMethodSelection.setTitleColor(UIColor.black, for: .normal)
        importMethodSelection.set(image: UIImage.init(named: "Tokenest-importMethodSelection"), title: importMethod.description, titlePosition: .left, additionalSpacing: 0, state: .normal)
        importMethodSelection.set(image: UIImage.init(named: "Tokenest-importMethodSelection")?.alpha(0.6), title: importMethod.description, titlePosition: .left, additionalSpacing: 0, state: .highlighted)
        importMethodSelection.setTitleColor(GlobalPicker.themeColor, for: .normal)
        importMethodSelection.setTitleColor(GlobalPicker.themeColor.withAlphaComponent(0.7), for: .normal)
        importMethodSelection.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        importMethodSelection.addTarget(self, action: #selector(pressedImportMethodSelection), for: .touchUpInside)
        mainScrollView.addSubview(importMethodSelection)
        
        contentTextView.frame = CGRect(x: paddingLeft, y: 117, width: screenWidth-paddingLeft*2, height: 120)
        contentTextView.contentInset = UIEdgeInsets.init(top: 15, left: 15, bottom: 15, right: 15)
        contentTextView.cornerRadius = 12
        contentTextView.font = FontConfigManager.shared.getLabelENFont()
        contentTextView.backgroundColor = UIColor.tokenestTextFieldBackground
        contentTextView.delegate = self
        // contentTextView.text = NSLocalizedString("Please enter the keystore", comment: "")
        contentTextView.textColor = .lightGray
        contentTextView.tintColor = UIColor.black
        mainScrollView.addSubview(contentTextView)

        passwordInfoLabel.textColor = UIColor.tokenestTip
        passwordInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        passwordInfoLabel.frame = CGRect(x: 74, y: 252, width: 200, height: 17)
        passwordInfoLabel.text = NSLocalizedString("Password", comment: "")
        mainScrollView.addSubview(passwordInfoLabel)
        
        passwordTextField.textContentType = UITextContentType("")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        passwordTextField.frame = CGRect(x: paddingLeft, y: 275, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        passwordTextField.setTokenestStyle()
        mainScrollView.addSubview(passwordTextField)
        
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
        
        contentTextView.inputAccessoryView = numberToolbar
        passwordTextField.inputAccessoryView = numberToolbar
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // TODO: have to update the color here. We may not need this function
        // customizedNavigationBar.isTranslucent = false
        // customizedNavigationBar.barTintColor = UIColor.init(rgba: "#2E2BA4")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // TODO: have to update the color here. We may not need this function
        // customizedNavigationBar.isTranslucent = false
        // customizedNavigationBar.barTintColor = UIColor.init(rgba: "#2E2BA4")
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
    
    @objc func pressedImportMethodSelection(_ sender: Any) {
        print("pressedImportMethodSelection")
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        // walletNameTextField.resignFirstResponder()
        // walletPasswordTextField.resignFirstResponder()
        // walletRepeatPasswordInfoLabel.resignFirstResponder()
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
        let viewController = UpdatedImportWalletEnterWalletNameViewController(setupWalletMethod: .importUsingKeystore)
        self.navigationController?.pushViewController(viewController, animated: true)
        
        /*
        if importMethod == .importUsingKeystore {
            let keystoreString = self.contentTextView.text ?? ""
            let password = passwordTextField.text ?? ""
            continueImportUsingKeystore(keystoreString: keystoreString, password: password)
        } else if importMethod == .importUsingPrivateKey {
            let privateKey = self.contentTextView.text ?? ""
            continueImportUsingPrivateKey(privateKey: privateKey)
        } else if importMethod == .importUsingMnemonic {
            continueImportUsingMnemonic()
        }
        */
    }
    
    
    

}
