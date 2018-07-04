//
//  SendViewController.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/18.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit
import Geth

class SendViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, DefaultNumericKeyboardDelegate, NumericKeyboardProtocol, QRCodeScanProtocol, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountTipLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var moreTokensButton: UIButton!
    @IBOutlet weak var tokensCollectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var totalMaskView: UIView!
    
    // Address
    var addressY: CGFloat = 0.0
    var addressInfoLabel: UILabel = UILabel()
    var addressTextField: UITextField = UITextField()
    var scanButton: UIButton = UIButton()
    
    // Amount
    var amountY: CGFloat = 0.0
    var amountInfoLabel: UILabel = UILabel()
    var amountTextField: UITextField = UITextField()
    var amountMaxButton: UIButton = UIButton()
    var amountETHTipLabel: UILabel = UILabel()
    
    // Transaction Fee
    var transactionFeeLabel = UILabel()
    var transactionValueLabel = UILabel()
    var transactionCurrencyLabel = UILabel()
    var transactionTipButton = UIButton()
    
    var transactionSpeedSlider = UISlider()
    var transactionAmountMinLabel = UILabel()
    var transactionAmountMaxLabel = UILabel()
    var transactionAmountCurrentLabel = UILabel()
    
    // send button
    var sendButton = UIButton()
    
    // Numeric keyboard
    var isNumericKeyboardShow: Bool = false
    var numericKeyboardView: DefaultNumericKeyboard!
    var activeTextFieldTag = -1
    
    var asset: Asset!
    var address: String!
    var showCollection: Bool = false
    var selectedIndexPath: IndexPath!
    var recGasPriceInGwei: Double = 0
    var gasPriceInGwei: Double = GasDataManager.shared.getGasPriceInGwei()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        maskView.alpha = 0
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        nameLabel.font = FontConfigManager.shared.getLabelENFont(size: 14)
        amountTipLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        collectionHeight.constant = getCollectionHeight()
        if asset == nil {
            asset = CurrentAppWalletDataManager.shared.getAsset(symbol: "ETH")
        }
        
        tokensCollectionView.alpha = 0
        tokensCollectionView.dataSource = self
        tokensCollectionView.delegate = self
        tokensCollectionView.allowsSelection = true
        tokensCollectionView.isScrollEnabled = true
        tokensCollectionView.register(UINib(nibName: "AssetCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "AssetCollectionViewCell")
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let padding: CGFloat = 16
        
        // 1st row: address
        addressInfoLabel.frame = CGRect(x: padding, y: padding, width: screenWidth, height: 40)
        addressInfoLabel.text = "转账地址"
        addressInfoLabel.font = FontConfigManager.shared.getLabelSCFont()
        addressInfoLabel.textColor = UIColor.tokenestTip
        scrollView.addSubview(addressInfoLabel)
        
        addressTextField.delegate = self
        addressTextField.tag = 0
        addressTextField.keyboardType = .alphabet
        addressTextField.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        addressTextField.theme_tintColor = GlobalPicker.textColor
        addressTextField.placeholder = LocalizedString("Enter the address", comment: "")
        addressTextField.text = self.address ?? ""
        addressTextField.borderStyle = .roundedRect
        addressTextField.setLeftPaddingPoints(8)
        addressTextField.setRightPaddingPoints(40)
        addressTextField.contentMode = UIViewContentMode.bottom
        addressTextField.frame = CGRect(x: padding, y: addressInfoLabel.frame.maxY, width: screenWidth-padding*2, height: 48)
        scrollView.addSubview(addressTextField)
        addressY = addressTextField.frame.minY
        
        scanButton.setImage(#imageLiteral(resourceName: "Tokenest-scan"), for: .normal)
        scanButton.frame = CGRect(x: screenWidth-padding-40, y: addressTextField.frame.origin.y+4, width: 40, height: 40)
        scanButton.addTarget(self, action: #selector(pressedScanButton(_:)), for: .touchUpInside)
        scrollView.addSubview(scanButton)
        
        // 2nd row: amount
        amountInfoLabel.frame = CGRect(x: padding, y: addressTextField.frame.maxY + padding, width: screenWidth, height: 40)
        amountInfoLabel.text = "转账金额(\(asset.symbol))"
        amountInfoLabel.font = FontConfigManager.shared.getLabelSCFont()
        amountInfoLabel.textColor = UIColor.tokenestTip
        scrollView.addSubview(amountInfoLabel)
        
        amountTextField.delegate = self
        amountTextField.inputView = UIView()
        amountTextField.tag = 1
        amountTextField.borderStyle = .roundedRect
        amountTextField.setLeftPaddingPoints(8)
        amountTextField.setRightPaddingPoints(100)
        amountTextField.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        amountTextField.theme_tintColor = GlobalPicker.textColor
        amountTextField.placeholder = LocalizedString("Enter the amount", comment: "")
        amountTextField.contentMode = UIViewContentMode.bottom
        amountTextField.frame = CGRect(x: padding, y: amountInfoLabel.frame.maxY, width: screenWidth-padding*2, height: 48)
        scrollView.addSubview(amountTextField)
        amountY = amountTextField.frame.minY
        
        amountMaxButton.title = "全部转出"
        amountMaxButton.titleColor = UIColor.tokenestBackground
        amountMaxButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont()
        amountMaxButton.frame = CGRect(x: screenWidth-90-padding, y: amountTextField.frame.origin.y+4, width: 100, height: 40)
        amountMaxButton.addTarget(self, action: #selector(pressedMaxButton(_:)), for: .touchUpInside)
        scrollView.addSubview(amountMaxButton)
        
        amountETHTipLabel.isHidden = true
        amountETHTipLabel.text = "我们为您保留0.01 ETH作为油费以保证后续可以发送交易"
        amountETHTipLabel.textAlignment = .right
        amountETHTipLabel.frame = CGRect(x: padding, y: amountTextField.frame.maxY, width: screenWidth-padding*2, height: 40)
        amountETHTipLabel.font = FontConfigManager.shared.getLabelSCFont(size: 10)
        amountETHTipLabel.textColor = UIColor.tokenestTip
        scrollView.addSubview(amountETHTipLabel)
        
        // 3rd Row: Transaction
        transactionFeeLabel.frame = CGRect(x: padding, y: amountETHTipLabel.frame.maxY, width: screenWidth, height: 40)
        transactionFeeLabel.font = FontConfigManager.shared.getLabelSCFont()
        transactionFeeLabel.textColor = UIColor.tokenestTip
        transactionFeeLabel.text = "矿工费(ETH)"
        scrollView.addSubview(transactionFeeLabel)
        
        transactionValueLabel.frame = CGRect(x: padding, y: transactionFeeLabel.frame.maxY, width: 100, height: 40)
        transactionValueLabel.text  = "0.00000"
        transactionValueLabel.font = FontConfigManager.shared.getLabelENFont()
        scrollView.addSubview(transactionValueLabel)
        
        let originX = transactionValueLabel.intrinsicContentSize.width + padding
        transactionCurrencyLabel.frame = CGRect(x: originX, y: transactionFeeLabel.frame.maxY, width: 100, height: 40)
        transactionCurrencyLabel.font = FontConfigManager.shared.getLabelSCFont()
        transactionCurrencyLabel.textColor = UIColor.tokenestTip
        scrollView.addSubview(transactionCurrencyLabel)
        
        transactionTipButton.frame = CGRect(x: screenWidth-padding-120, y: transactionFeeLabel.frame.maxY, width: 120, height: 40)
        transactionTipButton.titleColor = UIColor.tokenestBackground
        transactionTipButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont()
        transactionTipButton.contentHorizontalAlignment = .right
        transactionTipButton.title = LocalizedString("Recommended Gas", comment: "")
        transactionTipButton.addTarget(self, action: #selector(pressedTipButton(_:)), for: .touchUpInside)
        scrollView.addSubview(transactionTipButton)
        
        transactionSpeedSlider.minimumValue = 1
        transactionSpeedSlider.maximumValue = Float(gasPriceInGwei * 2) <= 20 ? 20 : Float(gasPriceInGwei * 2)
        transactionSpeedSlider.value = Float(gasPriceInGwei)
        transactionSpeedSlider.tintColor = GlobalPicker.themeColor
        transactionSpeedSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        transactionSpeedSlider.frame = CGRect(x: padding, y: transactionValueLabel.frame.maxY + padding, width: screenWidth-2*padding, height: 20)
        scrollView.addSubview(transactionSpeedSlider)
        
        transactionAmountMinLabel.frame = CGRect(x: padding, y: transactionSpeedSlider.frame.maxY + 10, width: (screenWidth-2*padding)/8, height: 30)
        transactionAmountMinLabel.font = FontConfigManager.shared.getLabelSCFont()
        transactionAmountMinLabel.text = LocalizedString("Slow", comment: "")
        scrollView.addSubview(transactionAmountMinLabel)
        
        transactionAmountCurrentLabel.textAlignment = .center
        transactionAmountCurrentLabel.frame = CGRect(x: transactionAmountMinLabel.frame.maxX, y: transactionAmountMinLabel.frame.minY, width: (screenWidth-2*padding)*3/4, height: 30)
        transactionAmountCurrentLabel.font = FontConfigManager.shared.getLabelSCFont()
        transactionAmountCurrentLabel.text = LocalizedString("gas price", comment: "") + ": \(gasPriceInGwei) gwei"
        
        scrollView.addSubview(transactionAmountCurrentLabel)
        
        transactionAmountMaxLabel.textAlignment = .right
        transactionAmountMaxLabel.frame = CGRect(x: transactionAmountCurrentLabel.frame.maxX, y: transactionAmountMinLabel.frame.minY, width: (screenWidth-2*padding)/8, height: 30)
        transactionAmountMaxLabel.font = FontConfigManager.shared.getLabelSCFont()
        transactionAmountMaxLabel.text = LocalizedString("Fast", comment: "")
        scrollView.addSubview(transactionAmountMaxLabel)
        
        // send button
        sendButton.title = "转出"
        sendButton.frame = CGRect(x: padding*4, y: transactionAmountMaxLabel.frame.maxY + padding*3, width: screenWidth-padding*8, height: 48)
        sendButton.addTarget(self, action: #selector(pressedSendButton(_:)), for: .touchUpInside)
        sendButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        scrollView.addSubview(sendButton)
        self.sendButton.setupRoundPurpleWithShadow(height: 48)
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: screenWidth, height: sendButton.frame.maxY + 30)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: .UITextFieldTextDidChange, object: nil)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(scrollViewTap)
        
        GasDataManager.shared.getEstimateGasPrice { (gasPrice, _) in
            self.gasPriceInGwei = Double(gasPrice)
            self.recGasPriceInGwei = Double(gasPrice)
            DispatchQueue.main.async {
                self.updateTransactionFeeAmountLabel(self.gasPriceInGwei)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("Send", comment: ""))
        self.tokenImage.image = asset.icon
        self.tokenLabel.text = asset.symbol
        self.nameLabel.text = asset.name
        self.amountLabel.text = getAvailableString()
        if asset.symbol.uppercased() == "ETH" {
            amountETHTipLabel.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCollectionHeight() -> CGFloat {
        var height: CGFloat = 0
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            let rows = ceil(Double(wallet.assetSequence.count) / 4)
            height = CGFloat(rows * 55)
        }
        return height
    }
    
    func updateTransactionFeeAmountLabel(_ gasPriceInGwei: Double) {
        let amountInEther = gasPriceInGwei / 1000000000
        let totalGasInEther = amountInEther * Double(GasDataManager.shared.getGasLimit(by: "token_transfer")!)
        transactionAmountCurrentLabel.text = LocalizedString("gas price", comment: "") + ": \(gasPriceInGwei) gwei"
        if let etherPrice = PriceDataManager.shared.getPrice(of: "ETH") {
            let transactionFeeInFiat = totalGasInEther * etherPrice
            transactionValueLabel.text = "\(totalGasInEther.withCommas(5))"
            transactionCurrencyLabel.text = "  ≈\(transactionFeeInFiat.currency)"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func hideCollectionView() {
        moreTokensButton.setImage(#imageLiteral(resourceName: "Tokenest-moretoken"), for: .normal)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.maskView.alpha = 0
            self.tokensCollectionView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func pressedMoreButton(_ sender: UIButton) {
        amountTextField.resignFirstResponder()
        self.view.endEditing(true)
        hideNumericKeyboard()
        showCollection = !showCollection
        if showCollection {
            moreTokensButton.setImage(#imageLiteral(resourceName: "Tokenest-lesstoken"), for: .normal)
            UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.maskView.alpha = 0.7
                self.tokensCollectionView.alpha = 1
                self.view.bringSubview(toFront: self.tokensCollectionView)
                self.view.layoutIfNeeded()
            }, completion: nil)
        } else {
            hideCollectionView()
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
                        updateLabel(label: addressInfoLabel, text: "转账地址", textColor: .tokenestTip)
                        return true
                    }
                }
                updateLabel(label: addressInfoLabel, text: LocalizedString("Please input a correct address", comment: ""), textColor: .red)
            } else {
                updateLabel(label: addressInfoLabel, text: LocalizedString("转账地址", comment: ""), textColor: .tokenestTip)
            }
        }
        return false
    }
    
    func getAvailableAmount() -> Double {
        var result: Double = 0
        if let asset = self.asset {
            let balance = asset.balance
            if asset.symbol.uppercased() == "ETH" {
                result = balance - 0.01
            } else {
                result = balance
            }
        }
        return result < 0 ? 0 : result
    }
    
    func getAvailableString() -> String {
        var result: String = ""
        if let asset = self.asset {
            if asset.symbol.uppercased() == "ETH" {
                var balance = asset.balance - 0.01
                if balance < 0 {
                    balance = 0
                }
                result = balance.withCommas(6)
            } else {
                result = asset.display
            }
        }
        return result
    }
    
    func validateAmount() -> Bool {
        if let amount = Double(amountTextField.text ?? "0") {
            let balance = getAvailableAmount()
            if amount > 0.0 {
                if balance >= amount {
                    if let token = TokenDataManager.shared.getTokenBySymbol(asset!.symbol) {
                        if GethBigInt.generate(valueInEther: amount, symbol: token.symbol) != nil {
                            if let price = PriceDataManager.shared.getPrice(of: asset.symbol) {
                                let display = (amount * price).currency
                                updateLabel(label: amountInfoLabel, text: display, textColor: .tokenestTip)
                                return true
                            }
                        }
                    }
                } else {
                    let title = LocalizedString("Available Balance", comment: "")
                    updateLabel(label: amountInfoLabel, text: "\(title) \(amountLabel.text!) \(asset.symbol)", textColor: .red)
                }
            } else {
                let text = LocalizedString("Please input a valid amount", comment: "")
                updateLabel(label: amountInfoLabel, text: text, textColor: .red)
            }
        } else {
            var text = ""
            if amountTextField.text == "" {
                text = "转账金额(\(asset.symbol))"
            } else {
                text = LocalizedString("Please input a valid amount", comment: "")
            }
            updateLabel(label: amountInfoLabel, text: text, textColor: .tokenestTip)
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
    
    func setResultOfScanningQRCode(valueSent: String, type: QRCodeType) {
        addressTextField.text = valueSent
        activeTextFieldTag = addressTextField.tag
        _ = validate()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            hideNumericKeyboard()
        } else if textField.tag == 1 {
            showNumericKeyboard(textField: amountTextField)
        }
        activeTextFieldTag = textField.tag
        _ = validate()
        return true
    }
    
    func getActiveTextField() -> UITextField? {
        return amountTextField
    }
    
    func pushController() {
        totalMaskView.alpha = 0.75
        let vc = SendConfirmViewController()
        vc.sendAsset = self.asset
        vc.sendAmount = self.amountTextField.text
        vc.receiveAddress = self.addressTextField.text
        vc.gasAmountInETH = self.transactionValueLabel.text
        vc.dismissClosure = { self.totalMaskView.alpha = 0 }
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        vc.parentNavController = self.navigationController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func pressedSendButton(_ sender: Any) {
        print("start sending")
        // Show activity indicator
        hideNumericKeyboard()
        addressTextField.resignFirstResponder()
        amountTextField.resignFirstResponder()
        let isAmountValid = validateAmount()
        let isAddressValid = validateAddress()
        if isAmountValid && isAddressValid {
            self.pushController()
        }
        if !isAmountValid && amountInfoLabel.textColor != .red {
            amountInfoLabel.text = LocalizedString("Please input a valid amount", comment: "")
            amountInfoLabel.textColor = .red
            amountInfoLabel.shake()
        }
        if !isAddressValid && addressInfoLabel.textColor != .red {
            addressInfoLabel.text = LocalizedString("Please input a correct address", comment: "")
            addressInfoLabel.textColor = .red
            addressInfoLabel.shake()
        }
    }
    
    @objc func pressedMaxButton(_ sender: UIButton) {
        amountTextField.text = getAvailableString()
        if let price = PriceDataManager.shared.getPrice(of: asset.symbol) {
            let total = getAvailableAmount() * price
            updateLabel(label: amountInfoLabel, text: total.currency, textColor: .tokenestTip)
        }
        _ = validate()
    }
    
    @objc func pressedTipButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.transactionSpeedSlider.value = Float(self.recGasPriceInGwei)
            self.updateTransactionFeeAmountLabel(self.recGasPriceInGwei)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let systemKeyboardHeight = keyboardFrame.cgRectValue.height
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            self.scrollViewBottomConstraint.constant = systemKeyboardHeight - bottomPadding
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                if self.addressY - self.scrollView.contentOffset.y < 0 || self.addressY - self.scrollView.contentOffset.y > self.scrollViewBottomConstraint.constant {
                    self.scrollView.setContentOffset(CGPoint.init(x: 0, y: self.addressY + 30), animated: true)
                }
            }, completion: { _ in
                self.activeTextFieldTag = self.addressTextField.tag
            })
        }
    }
    
    @objc func keyboardWillDisappear(notification: NSNotification?) {
        print("keyboardWillDisappear")
        if self.activeTextFieldTag != 1 {
            scrollViewBottomConstraint.constant = 0
        }
    }
    
    @objc func keyboardDidChange(notification: NSNotification?) {
        _ = validate()
    }
    
    func showNumericKeyboard(textField: UITextField) {
        if !isNumericKeyboardShow {
            let width = self.view.frame.width
            let height = self.view.frame.height
            numericKeyboardView = DefaultNumericKeyboard.init(frame: CGRect(x: 0, y: height, width: width, height: DefaultNumericKeyboard.height))
            numericKeyboardView.delegate2 = self
            scrollViewBottomConstraint.constant = DefaultNumericKeyboard.height
            view.addSubview(numericKeyboardView)
            
            let window = UIApplication.shared.keyWindow
            let bottomPadding = window?.safeAreaInsets.bottom ?? 0
            
            let destinateY = height - DefaultNumericKeyboard.height - bottomPadding
            
            // TODO: improve the animation.
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
                if self.amountY - self.scrollView.contentOffset.y < 0 || self.addressY - self.scrollView.contentOffset.y > self.scrollViewBottomConstraint.constant {
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
            self.scrollViewBottomConstraint.constant = 0
            
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                // animation for layout constraint change.
                self.view.layoutIfNeeded()
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
                self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }, completion: { _ in
                self.isNumericKeyboardShow = false
            })
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            return Int(ceil(Double(wallet.assetSequence.count) / 4))
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var result = 0
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            if wallet.assetSequence.count - 4 * section > 4 {
                result = 4
            } else {
                result = wallet.assetSequence.count - 4 * section
            }
        }
        return result
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width - 99) / 4, height: 32)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row + (indexPath.section * 4)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCollectionViewCell.getCellIdentifier(), for: indexPath) as? AssetCollectionViewCell
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            if wallet.assetSequence.count > index {
                cell?.asset = wallet.assetSequence[index]
            }
        }
        if selectedIndexPath != nil && selectedIndexPath == indexPath || cell?.asset?.lowercased() == self.asset.symbol.lowercased() {
            cell?.isHighlighted = true
        } else {
            cell?.isHighlighted = false
        }
        cell?.update()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.hideCollectionView()
        
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            let index = indexPath.row + (indexPath.section * 4)
            guard index < wallet.assetSequence.count else { return }
            let symbol = wallet.assetSequence[index]
            if let token = TokenDataManager.shared.getTokenBySymbol(symbol) {
                tokenImage.image = token.icon
                nameLabel.text = token.source
                tokenLabel.text = token.symbol
                amountInfoLabel.text = "转账金额(\(token.symbol))"
                if let asset = CurrentAppWalletDataManager.shared.getAsset(symbol: symbol) {
                    self.asset = asset
                    self.amountLabel.text = getAvailableString()
                }
            }
            if symbol.uppercased() == "ETH" {
                amountETHTipLabel.isHidden = false
            } else {
                amountETHTipLabel.isHidden = true
            }
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! AssetCollectionViewCell
        cell.isHighlighted = true
        
        self.showCollection = false
        self.selectedIndexPath = indexPath
        self.tokensCollectionView.reloadData()
    }
    
    // To avoid gesture conflicts in swiping to back and UISlider
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view != nil && touch.view!.isKind(of: UISlider.self) {
            return false
        }
        return true
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider!) {
        print("Slider value changed \(sender.value)")
        let step: Float = 1
        let roundedStepValue = round(sender.value / step) * step
        gasPriceInGwei = Double(roundedStepValue)
        GasDataManager.shared.setGasPrice(in: gasPriceInGwei)
        updateTransactionFeeAmountLabel(self.gasPriceInGwei)
    }
    
    @objc func pressedScanButton(_ sender: UIButton) {
        let viewController = ScanQRCodeViewController()
        viewController.delegate = self
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        amountTextField.resignFirstResponder()
        self.view.endEditing(true)
        hideNumericKeyboard()
    }
}
