//
//  UpdatedImportWalletEnterWalletNameViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/23/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedImportWalletEnterWalletNameViewController: UIViewController, UITextFieldDelegate {

    var setupWalletMethod: QRCodeMethod = .create
    
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var startInfolbel: UILabel!
    
    @IBOutlet weak var backgroundImageHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImageTopLayoutConstraint: NSLayoutConstraint!
    
    // Scrollable UI components
    var mainScrollView: UIScrollView = UIScrollView()
    let scrollViewHeight: CGFloat = 360  // measured in sketch file.
    
    var infoImage: UIImageView = UIImageView()
    var infoLabel: UILabel = UILabel()
    
    var walletNameInfoLabel: UILabel = UILabel()
    var walletNameTextField: UITextField = UITextField()
    
    convenience init(setupWalletMethod: QRCodeMethod) {
        self.init(nibName: "UpdatedImportWalletEnterWalletNameViewController", bundle: nil)
        self.setupWalletMethod = setupWalletMethod
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
        
        infoImage.frame = CGRect(x: 48, y: 36, width: 18, height: 18)
        infoImage.image = UIImage.init(named: "Tokenest-setup-info-icon")
        mainScrollView.addSubview(infoImage)
        
        infoLabel.textColor = UIColor.tokenestTip
        infoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        infoLabel.frame = CGRect(x: 72, y: infoImage.y+1, width: screenWidth - 72 - 35, height: 18)
        infoLabel.numberOfLines = 1
        infoLabel.text = LocalizedString("Give your wallet an awesome name", comment: "")
        mainScrollView.addSubview(infoLabel)
        
        walletNameInfoLabel.textColor = UIColor.tokenestTip
        walletNameInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        walletNameInfoLabel.frame = CGRect(x: 74, y: 105, width: 200, height: 17)
        walletNameInfoLabel.text = LocalizedString("Wallet Name", comment: "")
        mainScrollView.addSubview(walletNameInfoLabel)
        
        walletNameTextField.delegate = self
        walletNameTextField.tag = 0
        walletNameTextField.frame = CGRect(x: paddingLeft, y: 128, width: screenWidth-paddingLeft*2, height: textFieldHeight)
        walletNameTextField.setTokenestStyle()
        mainScrollView.addSubview(walletNameTextField)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        mainScrollView.addGestureRecognizer(scrollViewTap)
        
        view.addSubview(mainScrollView)
        
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
        
        walletNameTextField.inputAccessoryView = numberToolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        walletNameTextField.resignFirstResponder()
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
    
    @objc func backButtonPressed(_ sender: Any) {
        print("backButtonPressed")
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func doneWithNumberPad(_ sender: Any) {
        // pressedContinueButton(sender)
        walletNameTextField.resignFirstResponder()
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
        
        do {
            switch setupWalletMethod {
            case .importUsingMnemonic:
                if !validation() {
                    return
                }
                walletNameTextField.resignFirstResponder()
                ImportWalletUsingMnemonicDataManager.shared.walletName = walletNameTextField.text!
                importUsingMnemonic()
                return
                
            case .importUsingKeystore:
                if !validation() {
                    return
                }
                walletNameTextField.resignFirstResponder()
                ImportWalletUsingKeystoreDataManager.shared.walletName = walletNameTextField.text!
                try ImportWalletUsingKeystoreDataManager.shared.complete()
                
            case .importUsingPrivateKey:
                if !validation() {
                    return
                }
                walletNameTextField.resignFirstResponder()
                ImportWalletUsingPrivateKeyDataManager.shared.walletName = walletNameTextField.text!
                try ImportWalletUsingPrivateKeyDataManager.shared.complete()
            default:
                return
            }
        } catch AddWalletError.duplicatedAddress {
            alertForDuplicatedAddress()
            return
        } catch {
            alertForError()
            return
        }
        
        // Exit the whole importing process
        succeedAndExit()
    }
    
    func importUsingMnemonic() {
        ImportWalletUsingMnemonicDataManager.shared.complete(completion: {(appWallet, error) in
            if error == nil {
                self.succeedAndExit()
            } else if error == .duplicatedAddress {
                self.alertForDuplicatedAddress()
            } else {
                self.alertForError()
            }
        })
    }
    
    func validation() -> Bool {
        var validWalletName = true
        let walletName = walletNameTextField.text ?? ""
        if walletName.trim() == "" {
            validWalletName = false
            walletNameInfoLabel.shake()
            walletNameInfoLabel.textColor = UIStyleConfig.red
        }
        return validWalletName
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
        default: ()
        }
        return true
    }
    
    func succeedAndExit() {
        if SetupDataManager.shared.hasPresented {
            self.dismiss(animated: true, completion: {
                
            })
        } else {
            SetupDataManager.shared.hasPresented = true
            let appDelegate = UIApplication.shared.delegate as? AppDelegate
            appDelegate?.window?.rootViewController = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateInitialViewController()
        }
    }
}
