//
//  SendViewController.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/18.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit
import Geth

class SendViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, DefaultNumericKeyboardDelegate, NumericKeyboardProtocol, QRCodeScanProtocol, AmountStackViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var moreTokensButton: UIButton!
    @IBOutlet weak var tokensCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewTopToCollection: NSLayoutConstraint!
    @IBOutlet weak var scrollViewTopToHeader: NSLayoutConstraint!
    @IBOutlet weak var scrollViewBottomLayoutContraint: NSLayoutConstraint!
    
    // Address
    var addressY: CGFloat = 0.0
    var addressInfoLabel: UILabel = UILabel()
    var addressTextField: UITextField = UITextField()
    var scanButton: UIButton = UIButton()
    
    // Amount
    var amountY: CGFloat = 0.0
    var amountInfoLabel: UILabel = UILabel()
    var amountTextField: UITextField = UITextField()
    var amountStackView: AmountStackView!
    
    // Transaction Fee
    var transactionFeeLabel = UILabel()
    var transactionFeeTextField = UITextField()
    
    var advancedButton: UIButton = UIButton()
    var showAdvanced: Bool = false
 
    var transactionSpeedSlider = UISlider()
    var transactionAmountMinLabel = UILabel()
    var transactionAmountMaxLabel = UILabel()
    var transactionAmountCurrentLabel = UILabel()
    var transactionAmountHelpButton = UIButton()

    var sendButton = UIButton()

    // Numeric keyboard
    var isNumericKeyboardShow: Bool = false
    var numericKeyboardView: DefaultNumericKeyboard!
    var activeTextFieldTag = -1
    
    var asset: Asset!
    var showCollection: Bool = false
    var gasPriceInGwei: Double = GasDataManager.shared.getGasPriceInGwei()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: able to switch tokens.
        asset = CurrentAppWalletDataManager.shared.getAsset(symbol: "ETH")

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        
        tokensCollectionView.alpha = 0
        tokensCollectionView.dataSource = self
        tokensCollectionView.delegate = self
        tokensCollectionView.allowsSelection = false
        tokensCollectionView.isScrollEnabled = true
        tokensCollectionView.register(UINib(nibName: "AssetCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "AssetCollectionViewCell")
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let padding: CGFloat = 16
        
        // 1st row: address
        addressInfoLabel.frame = CGRect(x: padding, y: padding, width: screenWidth, height: 40)
        addressInfoLabel.text = "sdfsfd"
        scrollView.addSubview(addressInfoLabel)

        addressTextField.delegate = self
        addressTextField.tag = 0
        addressTextField.keyboardType = .alphabet
        addressTextField.font = FontConfigManager.shared.getLabelFont()
        addressTextField.theme_tintColor = GlobalPicker.textColor
        addressTextField.placeholder = NSLocalizedString("Enter the address", comment: "")
        addressTextField.borderStyle = .roundedRect
        addressTextField.setRightPaddingPoints(40)
        addressTextField.contentMode = UIViewContentMode.bottom
        addressTextField.frame = CGRect(x: padding, y: addressInfoLabel.frame.maxY, width: screenWidth-padding*2, height: 40)
        scrollView.addSubview(addressTextField)
        addressY = addressTextField.frame.minY
        
        scanButton.image = #imageLiteral(resourceName: "Tokenest-scan")
        scanButton.frame = CGRect(x: screenWidth-padding-40, y: addressTextField.frame.origin.y, width: 40, height: 40)
        scanButton.addTarget(self, action: #selector(pressedScanButton(_:)), for: .touchUpInside)
        scrollView.addSubview(scanButton)
        
        // 2nd row: amount
        amountInfoLabel.frame = CGRect(x: padding, y: addressTextField.frame.maxY + padding, width: screenWidth, height: 40)
        amountInfoLabel.text = "sdfsfd"
        scrollView.addSubview(amountInfoLabel)
        
        amountTextField.delegate = self
        amountTextField.inputView = UIView()
        amountTextField.tag = 1
        amountTextField.borderStyle = .roundedRect
        amountTextField.setRightPaddingPoints(100)
        amountTextField.font = FontConfigManager.shared.getLabelFont()
        amountTextField.theme_tintColor = GlobalPicker.textColor
        amountTextField.placeholder = NSLocalizedString("Enter the amount", comment: "")
        amountTextField.contentMode = UIViewContentMode.bottom
        amountTextField.frame = CGRect(x: padding, y: amountInfoLabel.frame.maxY, width: screenWidth-padding*2, height: 40)
        scrollView.addSubview(amountTextField)
        amountY = amountTextField.frame.minY
        
        amountStackView = AmountStackView(frame: CGRect(x: screenWidth-110-padding, y: amountTextField.frame.origin.y, width: 100, height: 40))
        amountStackView.delegate = self
        scrollView.addSubview(amountStackView)
        
        // 3rd Row: Transaction
        transactionFeeLabel.frame = CGRect(x: padding, y: amountTextField.frame.maxY + padding*2, width: screenWidth, height: 40)
        transactionFeeLabel.font = FontConfigManager.shared.getLabelFont()
        transactionFeeLabel.text = NSLocalizedString("Transaction Fee", comment: "")
        scrollView.addSubview(transactionFeeLabel)
        
        transactionFeeTextField.delegate = self
        transactionFeeTextField.inputView = UIView()
        transactionFeeTextField.frame = CGRect(x: padding, y: transactionFeeLabel.frame.maxY, width: screenWidth-padding*2, height: 40)
        transactionFeeTextField.tag = 2
        transactionFeeTextField.borderStyle = .roundedRect
        transactionFeeTextField.setRightPaddingPoints(40)
        transactionFeeTextField.theme_tintColor = GlobalPicker.textColor
        transactionFeeTextField.placeholder = NSLocalizedString("Enter the amount", comment: "")
        transactionFeeTextField.contentMode = UIViewContentMode.bottom
        scrollView.addSubview(transactionFeeTextField)
        
        advancedButton.frame = CGRect(x: screenWidth-padding-40, y: transactionFeeTextField.frame.origin.y, width: 40, height: 40)
        advancedButton.setImage(#imageLiteral(resourceName: "Tokenest-modify"), for: .normal)
        advancedButton.addTarget(self, action: #selector(pressedAdvancedButton(_:)), for: .touchUpInside)
        scrollView.addSubview(advancedButton)
        
        transactionSpeedSlider.alpha = 0
        transactionSpeedSlider.minimumValue = 1
        transactionSpeedSlider.maximumValue = Float(gasPriceInGwei * 2) <= 20 ? 20 : Float(gasPriceInGwei * 2)
        transactionSpeedSlider.value = Float(gasPriceInGwei)
        transactionSpeedSlider.tintColor = GlobalPicker.themeColor
        transactionSpeedSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        transactionSpeedSlider.frame = CGRect(x: padding, y: transactionFeeTextField.frame.maxY + padding, width: screenWidth-2*padding, height: 20)
        scrollView.addSubview(transactionSpeedSlider)
        
        transactionAmountMinLabel.alpha = 0
        transactionAmountMinLabel.frame = CGRect(x: padding, y: transactionSpeedSlider.frame.maxY + 10, width: (screenWidth-2*padding)/8, height: 30)
        transactionAmountMinLabel.font = FontConfigManager.shared.getLabelFont()
        transactionAmountMinLabel.text = NSLocalizedString("Slow", comment: "")
        scrollView.addSubview(transactionAmountMinLabel)
        
        transactionAmountCurrentLabel.alpha = 0
        transactionAmountCurrentLabel.textAlignment = .center
        transactionAmountCurrentLabel.frame = CGRect(x: transactionAmountMinLabel.frame.maxX, y: transactionAmountMinLabel.frame.minY, width: (screenWidth-2*padding)*3/4, height: 30)
        transactionAmountCurrentLabel.font = FontConfigManager.shared.getLabelFont()
        transactionAmountCurrentLabel.text = NSLocalizedString("gas price", comment: "") + ": \(gasPriceInGwei) gwei"
        
        scrollView.addSubview(transactionAmountCurrentLabel)
        
        let pad = (transactionAmountCurrentLabel.frame.width - transactionAmountCurrentLabel.intrinsicContentSize.width) / 2
        transactionAmountHelpButton.alpha = 0
        transactionAmountHelpButton.frame = CGRect(x: transactionAmountCurrentLabel.frame.maxX - pad, y: transactionAmountCurrentLabel.frame.minY, width: 30, height: 30)
        transactionAmountHelpButton.image = UIImage(named: "HelpIcon")
        transactionAmountHelpButton.addTarget(self, action: #selector(pressedHelpButton), for: .touchUpInside)
        scrollView.addSubview(transactionAmountHelpButton)
        
        transactionAmountMaxLabel.alpha = 0
        transactionAmountMaxLabel.textAlignment = .right
        transactionAmountMaxLabel.frame = CGRect(x: transactionAmountCurrentLabel.frame.maxX, y: transactionAmountMinLabel.frame.minY, width: (screenWidth-2*padding)/8, height: 30)
        transactionAmountMaxLabel.font = FontConfigManager.shared.getLabelFont()
        transactionAmountMaxLabel.text = NSLocalizedString("Fast", comment: "")
        scrollView.addSubview(transactionAmountMaxLabel)

        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: screenWidth, height: transactionAmountMinLabel.frame.maxY + 30)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: .UITextFieldTextDidChange, object: nil)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(scrollViewTap)
        
        // Get the latest estimate gas price from Relay.
        GasDataManager.shared.getEstimateGasPrice { (gasPrice, _) in
            self.gasPriceInGwei = Double(gasPrice)
            DispatchQueue.main.async {
                self.transactionAmountCurrentLabel.text = NSLocalizedString("gas price", comment: "") + ": \(self.gasPriceInGwei) gwei"
                self.updateTransactionFeeAmountLabel()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateTransactionFeeAmountLabel() {
        let amountInEther = gasPriceInGwei / 1000000000
        if let etherPrice = PriceDataManager.shared.getPrice(of: "ETH") {
            let transactionFeeInFiat = amountInEther * etherPrice * Double(GasDataManager.shared.getGasLimit(by: "eth_transfer")!)
            transactionFeeTextField.text = "\(transactionFeeInFiat.currency)"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("Send", comment: ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func pressedMoreButton(_ sender: UIButton) {
        showCollection = !showCollection
        if showCollection {
            scrollViewTopToHeader.priority = .defaultLow
            scrollViewTopToCollection.priority = .defaultHigh
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.tokensCollectionView.alpha = 1
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            scrollViewTopToHeader.priority = .defaultHigh
            scrollViewTopToCollection.priority = .defaultLow
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.tokensCollectionView.alpha = 0
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    func updateLabel(label: UILabel, text: String, textColor: UIColor) {
        label.textColor = textColor
        label.text = text
        if textColor == .red {
            label.shake()
        }
    }
    
    func validateAddress() -> Bool {
        if let toAddress = addressTextField.text {
            if !toAddress.isEmpty {
                if toAddress.isHexAddress() {
                    var error: NSError? = nil
                    if GethNewAddressFromHex(toAddress, &error) != nil {
                        updateLabel(label: addressInfoLabel, text: NSLocalizedString("Please confirm the address before sending", comment: ""), textColor: .black)
                        return true
                    }
                }
                updateLabel(label: addressInfoLabel, text: NSLocalizedString("Please input a correct address", comment: ""), textColor: .red)
            } else {
                updateLabel(label: addressInfoLabel, text: NSLocalizedString("Please confirm the address before sending", comment: ""), textColor: .black)
            }
        }
        return false
    }
    
    func validateAmount() -> Bool {
        if let amount = Double(amountTextField.text ?? "0") {
            if amount > 0.0 {
                if asset.balance >= amount {
                    if let token = TokenDataManager.shared.getTokenBySymbol(asset!.symbol) {
                        if GethBigInt.generate(valueInEther: amount, symbol: token.symbol) != nil {
                            if let price = PriceDataManager.shared.getPrice(of: asset.symbol) {
                                let display = (amount * price).currency
                                updateLabel(label: amountInfoLabel, text: display, textColor: .black)
                                return true
                            }
                        }
                    }
                } else {
                    let title = NSLocalizedString("Available Balance", comment: "")
                    updateLabel(label: amountInfoLabel, text: "\(title) \(asset.display) \(asset.symbol)", textColor: .red)
                }
            } else {
                let text = NSLocalizedString("Please input a valid amount", comment: "")
                updateLabel(label: amountInfoLabel, text: text, textColor: .red)
            }
        } else {
            updateLabel(label: amountInfoLabel, text: 0.0.currency, textColor: .black)
        }
        return false
    }
    
    func validate() -> Bool {
        var isValid = false
        if activeTextFieldTag == addressTextField.tag {
            isValid = validateAddress()
        } else if activeTextFieldTag == amountTextField.tag {
            isValid = validateAmount()
        }
        return isValid
    }
    
    func setResultOfAmount(with percentage: Double) {
        let length = Asset.getLength(of: asset.symbol) ?? 4
        let value = asset.balance * Double(percentage)
        amountTextField.text = value.withCommas(length)
        if let price = PriceDataManager.shared.getPrice(of: asset.symbol) {
            let total = value * price
            updateLabel(label: amountInfoLabel, text: total.currency, textColor: .black)
        }
        _ = validate()
    }
    
    func setResultOfScanningQRCode(valueSent: String, type: QRCodeType) {
        addressTextField.text = valueSent
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            hideNumericKeyboard()
        } else if textField.tag == 1 {
            showNumericKeyboard(textField: amountTextField)
        }
        activeTextFieldTag = amountTextField.tag
        _ = validate()
        return true
    }
    
    func getActiveTextField() -> UITextField? {
        return amountTextField
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let systemKeyboardHeight = keyboardFrame.cgRectValue.height
        if #available(iOS 11.0, *) {
            // Get the the distance from the bottom safe area edge to the bottom of the screen
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            self.scrollViewBottomLayoutContraint.constant = systemKeyboardHeight + bottomPadding
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                if self.addressY - self.scrollView.contentOffset.y < 0 || self.addressY - self.scrollView.contentOffset.y > self.scrollViewBottomLayoutContraint.constant {
                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: self.addressY + 30), animated: true)
                }
            }, completion: { _ in
                
            })
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification?) {
        print("keyboardWillDisappear")
        scrollViewBottomLayoutContraint.constant = 0
    }
    
    @objc func keyboardDidChange(notification: NSNotification?) {
        activeTextFieldTag = addressTextField.tag
        _ = validate()
    }
    
    func showNumericKeyboard(textField: UITextField) {
        if !isNumericKeyboardShow {
            let width = self.view.frame.width
            let height = self.view.frame.height
            scrollViewBottomLayoutContraint.constant = DefaultNumericKeyboard.height
            numericKeyboardView = DefaultNumericKeyboard.init(frame: CGRect(x: 0, y: height, width: width, height: DefaultNumericKeyboard.height))
            numericKeyboardView.delegate2 = self
            view.addSubview(numericKeyboardView)
            
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            
            let destinateY = height - DefaultNumericKeyboard.height - bottomPadding

            // TODO: improve the animation.
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
                if self.amountY - self.scrollView.contentOffset.y < 0 || self.addressY - self.scrollView.contentOffset.y > self.scrollViewBottomLayoutContraint.constant {
                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: self.amountY - 120*UIStyleConfig.scale), animated: true)
                }

            }, completion: { _ in
                self.isNumericKeyboardShow = true
            })
        }
        numericKeyboardView.currentText = textField.text ?? ""
    }
    
    func hideNumericKeyboard() {
        if isNumericKeyboardShow {
            let width = self.view.frame.width
            let height = self.view.frame.height
            let destinateY = height
            self.scrollViewBottomLayoutContraint.constant = 0

            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                // animation for layout constraint change.
                self.view.layoutIfNeeded()
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
                // self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }, completion: { _ in
                self.isNumericKeyboardShow = false
            })
        } else {
            
        }
    }
    
    func numericKeyboard(_ numericKeyboard: NumericKeyboard, currentTextDidUpdate currentText: String) {
        let activeTextField: UITextField? = getActiveTextField()
        guard activeTextField != nil else {
            return
        }
        activeTextField!.text = currentText
        _ = validate()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            return wallet.assetSequence.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCollectionViewCell.getCellIdentifier(), for: indexPath) as? AssetCollectionViewCell
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            cell?.asset = wallet.assetSequence[indexPath.row]
        }
        cell?.update()
        return cell!
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider!) {
        print("Slider value changed \(sender.value)")
        let step: Float = 1
        let roundedStepValue = round(sender.value / step) * step
        gasPriceInGwei = Double(roundedStepValue)
        
        // Update info
        transactionAmountCurrentLabel.text = NSLocalizedString("gas price", comment: "") + ": \(roundedStepValue) gwei"
        updateTransactionFeeAmountLabel()
    }
    
    @objc func pressedScanButton(_ sender: UIButton) {
        let viewController = ScanQRCodeViewController()
        viewController.delegate = self
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedAdvancedButton(_ sender: Any) {
        print("pressedAdvancedButton")
        showAdvanced = !showAdvanced
        if showAdvanced {
            UIView.animate(withDuration: 0.5, animations: {
                self.transactionSpeedSlider.alpha = 1
                self.transactionAmountMinLabel.alpha = 1
                self.transactionAmountCurrentLabel.alpha = 1
                self.transactionAmountMaxLabel.alpha = 1
                self.transactionAmountHelpButton.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.transactionSpeedSlider.alpha = 0
                self.transactionAmountMinLabel.alpha = 0
                self.transactionAmountCurrentLabel.alpha = 0
                self.transactionAmountMaxLabel.alpha = 0
                self.transactionAmountHelpButton.alpha = 0
            })
        }
    }
    
    @objc func pressedHelpButton(_ sender: Any) {
        let title = NSLocalizedString("What is gas?", comment: "")
        let message = NSLocalizedString("Gas is...", comment: "") // TODO
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: NSLocalizedString("Confirm", comment: ""), style: .cancel, handler: { _ in
        })
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        amountTextField.resignFirstResponder()
        self.view.endEditing(true)
        hideNumericKeyboard()
    }
}
