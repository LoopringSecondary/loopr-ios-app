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
    
    @IBOutlet weak var presentedBackgroundView: UIView!
    
    var isPushedInParentViewController: Bool = true
    
    // Scrollable UI components
    var mainScrollView: UIScrollView = UIScrollView()
    let scrollViewHeight: CGFloat = 360 + 60  // measured in sketch file.
    
    var infoImage: UIImageView = UIImageView()
    var infoLabel: UILabel = UILabel()

    var currentImportMethod: QRCodeMethod = .importUsingKeystore
    var importMethodSelection: UIButton = UIButton()
    
    var contentTextViewBackground: UIView = UIView()
    var contentTextView: UITextView = UITextView()
    
    let firstRowY: CGFloat = 252
    let secordRowY: CGFloat = 333

    var passwordInfoLabel: UILabel = UILabel()
    var passwordTextField: UITextField = UITextField()
    
    var currentWalletType = WalletType.getDefault()
    var selectWalletTypeInfoLabel: UILabel = UILabel()
    var selectWalletTypeBackground: UIView = UIView()
    var selectWalletTypeButton: UIButton = UIButton()
    var selectWalletTypeArrowIcon: UIImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(systemKeyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        
        // Add swipe to go-back feature back which is a system default gesture
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        // Update the navigation bar
        let navigationItem = UINavigationItem()
        navigationItem.title = LocalizedString("Import Wallet", comment: "")
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
        infoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        infoLabel.frame = CGRect(x: 72, y: 36, width: screenWidth - 72 - 35, height: 34)
        infoLabel.numberOfLines = 2
        
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.init(rgba: "#4C5669"),
                          NSAttributedStringKey.font: FontConfigManager.shared.getLabelSCFont(size: 12, type: "Medium")]
        let infoString = "Tokenest支持 keystore, 私钥 及 助记词的导入，请选择您要导入钱包的方式并将内容黏贴至下框"
        let attr = infoString.higlighted(words: ["keystore", "私钥", "private key", "助记词", "mnemonic"], attributes: attributes)

        // let paragraphStyle = NSMutableParagraphStyle()
        // paragraphStyle.lineSpacing = 4
        // attr.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attr.length))
        infoLabel.attributedText = attr
        mainScrollView.addSubview(infoLabel)
        
        importMethodSelection.setTitleColor(UIColor.black, for: .normal)
        importMethodSelection.setTitleColor(UIColor.init(rgba: "#2E2BA4"), for: .normal)
        importMethodSelection.setTitleColor(GlobalPicker.themeColor.withAlphaComponent(0.7), for: .normal)
        importMethodSelection.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        importMethodSelection.addTarget(self, action: #selector(pressedImportMethodSelection), for: .touchUpInside)
        mainScrollView.addSubview(importMethodSelection)
        
        contentTextViewBackground.frame = CGRect(x: paddingLeft, y: 117, width: screenWidth-paddingLeft*2, height: 120)
        contentTextViewBackground.cornerRadius = 21.5
        contentTextViewBackground.layer.borderColor = UIColor.init(rgba: "#E5E7ED").cgColor
        contentTextViewBackground.layer.borderWidth = 0.5
        contentTextViewBackground.backgroundColor = UIColor.tokenestTextFieldBackground
        mainScrollView.addSubview(contentTextViewBackground)
        
        contentTextView.frame = CGRect(x: contentTextViewBackground.x+25, y: contentTextViewBackground.y + 12, width: contentTextViewBackground.width - 25*2, height: contentTextViewBackground.height - 24)
        contentTextView.font = FontConfigManager.shared.getLabelENFont(size: 15)
        contentTextView.delegate = self
        contentTextView.autocapitalizationType = .none
        // contentTextView.text = LocalizedString("Please enter the keystore", comment: "")
        contentTextView.backgroundColor = UIColor.tokenestTextFieldBackground
        contentTextView.textColor = .black
        contentTextView.tintColor = UIColor.black
        mainScrollView.addSubview(contentTextView)

        passwordInfoLabel.textAlignment = .left
        passwordInfoLabel.textColor = UIColor.tokenestTip
        passwordInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        passwordInfoLabel.text = LocalizedString("Password", comment: "")
        mainScrollView.addSubview(passwordInfoLabel)
        
        passwordTextField.textContentType = UITextContentType("")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.autocorrectionType = .no
        passwordTextField.delegate = self
        passwordTextField.tag = 1
        passwordTextField.setTokenestStyle()
        mainScrollView.addSubview(passwordTextField)
        
        selectWalletTypeInfoLabel.textAlignment = .left
        selectWalletTypeInfoLabel.textColor = UIColor.tokenestTip
        selectWalletTypeInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        selectWalletTypeInfoLabel.text = LocalizedString("Select Your Wallet Type", comment: "")
        mainScrollView.addSubview(selectWalletTypeInfoLabel)
        
        selectWalletTypeBackground.layer.borderWidth = 0.5
        selectWalletTypeBackground.layer.borderColor = UIColor.tokenestBorder.cgColor
        selectWalletTypeBackground.layer.cornerRadius = 47 * 0.5
        selectWalletTypeBackground.backgroundColor = UIColor.tokenestTextFieldBackground
        mainScrollView.addSubview(selectWalletTypeBackground)
        
        let selectWalletTypeBackgroundTap = UITapGestureRecognizer(target: self, action: #selector(pressedSelectWalletTypeButton))
        selectWalletTypeBackgroundTap.numberOfTapsRequired = 1
        selectWalletTypeBackground.addGestureRecognizer(selectWalletTypeBackgroundTap)
        
        selectWalletTypeArrowIcon.image = UIImage.init(named: "Tokenest-walletTypeSelection")
        selectWalletTypeArrowIcon.contentMode = .center
        mainScrollView.addSubview(selectWalletTypeArrowIcon)
        
        selectWalletTypeButton.setTitle(currentWalletType.name, for: .normal)
        selectWalletTypeButton.contentHorizontalAlignment = .left
        selectWalletTypeButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14, type: "Medium")
        selectWalletTypeButton.setTitleColor(UIColor.init(rgba: "#32384C"), for: .normal)
        selectWalletTypeButton.setTitleColor(UIColor.init(rgba: "#32384C").withAlphaComponent(0.7), for: .highlighted)
        selectWalletTypeButton.addTarget(self, action: #selector(pressedSelectWalletTypeButton), for: .touchUpInside)
        mainScrollView.addSubview(selectWalletTypeButton)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        mainScrollView.addGestureRecognizer(scrollViewTap)
        
        updateImportMethodSelection()
        view.addSubview(mainScrollView)
        
        presentedBackgroundView.backgroundColor = UIColor.clear
        presentedBackgroundView.isHidden = true
        view.bringSubview(toFront: presentedBackgroundView)
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        let doneBarButton = UIBarButtonItem(title: LocalizedString("Complete", comment: ""), style: .plain, target: self, action: #selector(doneWithNumberPad))
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
        updateImportMethodSelection()
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
        // pressedContinueButton(sender)
        contentTextView.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func pressedImportMethodSelection(_ sender: Any) {
        print("pressedImportMethodSelection")
        let viewController = SwitchImportWalletMethodViewController.init(nibName: "SwitchImportWalletMethodViewController", bundle: nil)
        viewController.delegate = self
        viewController.currentImportMethod = currentImportMethod
        viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        presentedBackgroundView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.71)
        }

        self.navigationController?.present(viewController, animated: true, completion: {
            
        })
    }
    
    @objc func pressedSelectWalletTypeButton(_ sender: Any) {
        print("pressedSelectWalletTypeButton")
        let viewController = SwitchImportWalletWalletTypeViewController()
        viewController.delegate = self
        viewController.currentWalletType = currentWalletType
        viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        presentedBackgroundView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.71)
        }
        
        self.navigationController?.present(viewController, animated: true, completion: {
            
        })
    }
    
    func updateImportMethodSelection() {
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        // let screenHeight = screensize.height
        
        // let originY: CGFloat = 345
        let paddingLeft: CGFloat = 47
        let textFieldHeight: CGFloat = 43
        
        var currentImportMethodDescription = currentImportMethod.description
        if currentImportMethod == .importUsingKeystore {
            currentImportMethodDescription += " " + LocalizedString("File", comment: "")
        }
        let titleWidth = currentImportMethodDescription.textWidth(font: FontConfigManager.shared.getLabelSCFont(size: 14))
        importMethodSelection.frame = CGRect(x: 76, y: 94, width: titleWidth, height: 17)
        
        if currentImportMethod == .importUsingKeystore {
            passwordInfoLabel.isHidden = false
            passwordTextField.isHidden = false
            selectWalletTypeInfoLabel.isHidden = true
            selectWalletTypeBackground.isHidden = true
            selectWalletTypeButton.isHidden = true
            selectWalletTypeArrowIcon.isHidden = true
            passwordInfoLabel.frame = CGRect(x: 74, y: firstRowY, width: 200, height: 17)
            passwordTextField.frame = CGRect(x: paddingLeft, y: passwordInfoLabel.y + 23, width: screenWidth-paddingLeft*2, height: textFieldHeight)

        } else if currentImportMethod == .importUsingPrivateKey {
            passwordInfoLabel.isHidden = true
            passwordTextField.isHidden = true
            selectWalletTypeInfoLabel.isHidden = true
            selectWalletTypeBackground.isHidden = true
            selectWalletTypeButton.isHidden = true
            selectWalletTypeArrowIcon.isHidden = true

        } else if currentImportMethod == .importUsingMnemonic && currentWalletType == WalletType.getLoopringWallet() {
            passwordInfoLabel.textColor = UIColor.tokenestTip
            passwordInfoLabel.isHidden = false
            passwordTextField.isHidden = false
            selectWalletTypeInfoLabel.isHidden = false
            selectWalletTypeBackground.isHidden = false
            selectWalletTypeButton.isHidden = false
            selectWalletTypeArrowIcon.isHidden = false
            
            selectWalletTypeInfoLabel.frame = CGRect(x: 74, y: firstRowY, width: 200, height: 17)
            selectWalletTypeBackground.frame = CGRect(x: 47, y: selectWalletTypeInfoLabel.y + 23, width: screenWidth - 47*2, height: 43)
            selectWalletTypeButton.frame = CGRect(x: selectWalletTypeBackground.x + 27, y: selectWalletTypeBackground.y, width: selectWalletTypeBackground.width - 2*27, height: selectWalletTypeBackground.height)
            selectWalletTypeArrowIcon.frame = CGRect(x: selectWalletTypeBackground.frame.maxX - 8 - 22, y: selectWalletTypeBackground.frame.midY-5.0/2, width: 8, height: 5)
            
            passwordInfoLabel.frame = CGRect(x: 74, y: secordRowY, width: 200, height: 17)
            passwordTextField.frame = CGRect(x: paddingLeft, y: passwordInfoLabel.y + 23, width: screenWidth-paddingLeft*2, height: textFieldHeight)

        } else if currentImportMethod == .importUsingMnemonic {
            passwordInfoLabel.textColor = UIColor.tokenestTip
            passwordInfoLabel.isHidden = true
            passwordTextField.isHidden = true
            selectWalletTypeInfoLabel.isHidden = false
            selectWalletTypeBackground.isHidden = false
            selectWalletTypeButton.isHidden = false
            selectWalletTypeArrowIcon.isHidden = false
            
            selectWalletTypeInfoLabel.frame = CGRect(x: 74, y: firstRowY, width: 200, height: 17)
            selectWalletTypeBackground.frame = CGRect(x: 47, y: selectWalletTypeInfoLabel.y + 23, width: screenWidth - 47*2, height: 43)
            selectWalletTypeButton.frame = CGRect(x: selectWalletTypeBackground.x + 27, y: selectWalletTypeBackground.y, width: selectWalletTypeBackground.width - 2*27, height: selectWalletTypeBackground.height)
            selectWalletTypeArrowIcon.frame = CGRect(x: selectWalletTypeBackground.frame.maxX - 8 - 22, y: selectWalletTypeBackground.frame.midY-5.0/2, width: 8, height: 5)
        }
        
        importMethodSelection.set(image: UIImage.init(named: "Tokenest-importMethodSelection"), title: currentImportMethodDescription, titlePosition: .left, additionalSpacing: 10, state: .normal)
        importMethodSelection.set(image: UIImage.init(named: "Tokenest-importMethodSelection")?.alpha(0.6), title: currentImportMethodDescription, titlePosition: .left, additionalSpacing: 10, state: .highlighted)
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        contentTextView.resignFirstResponder()
        passwordTextField.resignFirstResponder()
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
        }, completion: { (_) in
            
        })
    }
    
    @objc func systemKeyboardWillDisappear(notification: NSNotification?) {
        print("keyboardWillDisappear")
        self.backgroundImageTopLayoutConstraint.constant = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.mainScrollView.frame = CGRect(x: 0, y: self.backgroundImageHeightLayoutConstraint.constant, width: UIScreen.main.bounds.width, height: self.scrollViewHeight)
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            
        })
    }
    
    func validation() -> Bool {
        var valid = true
        let contentText = contentTextView.text ?? ""
        let password = passwordTextField.text ?? ""
        var invalidMessage = ""
        
        if currentImportMethod == .importUsingKeystore {
            if contentText.trim() == "" {
                invalidMessage = LocalizedString("Please enter keystore", comment: "")
                valid = false
            } else if !QRCodeMethod.isKeystore(content: contentText) {
                invalidMessage = LocalizedString("Invalid keystore. Please enter again.", comment: "")
                valid = false
            } else if password == "" {
                passwordInfoLabel.shake()
                passwordInfoLabel.textColor = UIStyleConfig.red
                invalidMessage = LocalizedString("Please enter password", comment: "")
                valid = false
            }
        } else if currentImportMethod == .importUsingPrivateKey {
            if contentText.trim() == "" {
                invalidMessage = LocalizedString("Please enter private key", comment: "")
                valid = false
            } else if !QRCodeMethod.isPrivateKey(key: contentText) {
                invalidMessage = LocalizedString("Invalid private key. Please enter again.", comment: "")
                valid = false
            }
        } else if currentImportMethod == .importUsingMnemonic {
            if contentText.trim() == "" {
                invalidMessage = LocalizedString("Please enter mnemonic", comment: "")
                valid = false
            } else if !QRCodeMethod.isMnemonicValid(mnemonic: contentText.trim()) {
                invalidMessage = LocalizedString("Invalid mnemonic. Please enter again.", comment: "")
                valid = false
            } else if currentWalletType == WalletType.getLoopringWallet() && password == "" {
                passwordInfoLabel.shake()
                passwordInfoLabel.textColor = UIStyleConfig.red
                invalidMessage = LocalizedString("Please enter password", comment: "")
                valid = false
            }
        } else {
            valid = false
        }
        
        if !valid && invalidMessage != "" {
            // contentTextView.shake()
            let banner = NotificationBanner.generate(title: invalidMessage, style: .danger)
            banner.duration = 1.5
            banner.show()
        }

        return valid
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text?.utf16.count)! + (string.utf16.count) - range.length
        print("textField shouldChangeCharactersIn \(newLength)")
        
        switch textField.tag {
        case passwordTextField.tag:
            if newLength > 0 {
                passwordInfoLabel.textColor = UIColor.tokenestTip
            }
        default: ()
        }
        return true
    }
    
    @objc func pressedContinueButton(_ sender: Any) {
        guard validation() else {
            print("validate failed")
            return
        }

        if currentImportMethod == .importUsingKeystore {
            let keystoreString = self.contentTextView.text ?? ""
            let password = passwordTextField.text ?? ""
            continueImportUsingKeystore(keystoreString: keystoreString, password: password)
        } else if currentImportMethod == .importUsingPrivateKey {
            let privateKey = self.contentTextView.text ?? ""
            continueImportUsingPrivateKey(privateKey: privateKey)
        } else if currentImportMethod == .importUsingMnemonic {
            let memonicString = self.contentTextView.text ?? ""
            let password = passwordTextField.text ?? ""
            continueImportUsingMnemonic(memonicString: memonicString, password: password)
        }
    }

}

extension UpdatedUnlockWalletViewController: SwitchImportWalletMethodViewControllerDelegate {
    func selectedImportWalletMethod(_ selectedImportMethod: QRCodeMethod?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: { (_) in
            self.presentedBackgroundView.isHidden = true
        })

        if selectedImportMethod != nil {
            currentImportMethod = selectedImportMethod!
            // Reset text in contentTextView
            contentTextView.text = ""
            
            // Update UI
            updateImportMethodSelection()
        }
    }
}

extension UpdatedUnlockWalletViewController: SwitchImportWalletWalletTypeViewControllerDelegate {
    func selectedImportWalletWalletType(_ selectedWalletType: WalletType?) {
        UIView.animate(withDuration: 0.3, animations: {
            self.presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: { (_) in
            self.presentedBackgroundView.isHidden = true
        })
        
        if selectedWalletType != nil {
            currentWalletType = selectedWalletType!
            selectWalletTypeButton.setTitle(currentWalletType.name, for: .normal)
            ImportWalletUsingMnemonicDataManager.shared.derivationPathValue = currentWalletType.derivationPath
            updateImportMethodSelection()
        }
    }
}
