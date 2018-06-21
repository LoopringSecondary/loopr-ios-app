//
//  SendViewController.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/18.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit
import Geth
import SVProgressHUD

class SendViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate, DefaultNumericKeyboardDelegate, NumericKeyboardProtocol, QRCodeScanProtocol, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    // Transaction Fee
    var transactionFeeLabel = UILabel()
    var transactionValueLabel = UILabel()
    var transactionCurrencyLabel = UILabel()
    var transactionTipButton = UIButton()
 
    var transactionSpeedSlider = UISlider()
    var transactionAmountMinLabel = UILabel()
    var transactionAmountMaxLabel = UILabel()
    var transactionAmountCurrentLabel = UILabel()
    var transactionAmountHelpButton = UIButton()

    // send button
    var sendButton = UIButton()

    // Numeric keyboard
    var isNumericKeyboardShow: Bool = false
    var numericKeyboardView: DefaultNumericKeyboard!
    var activeTextFieldTag = -1
    
    var asset: Asset!
    var showCollection: Bool = false
    var recGasPriceInGwei: Double = 0
    var gasPriceInGwei: Double = GasDataManager.shared.getGasPriceInGwei()
    var selectedIndexPath: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: able to switch tokens.
        asset = CurrentAppWalletDataManager.shared.getAsset(symbol: "ETH")

        // Do any additional setup after loading the view.
        maskView.alpha = 0
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        nameLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        collectionHeight.constant = getCollectionHeight()
        
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
        addressInfoLabel.font = FontConfigManager.shared.getLabelsFont()
        addressInfoLabel.textColor = UIColor.tokenestTip
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
        amountInfoLabel.text = "转账金额(ETH)"
        amountInfoLabel.font = FontConfigManager.shared.getLabelsFont()
        amountInfoLabel.textColor = UIColor.tokenestTip
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
        
        amountMaxButton.title = "全部转出"
        amountMaxButton.titleColor = UIColor.tokenestButton
        amountMaxButton.titleLabel?.font = FontConfigManager.shared.getLabelsFont()
        amountMaxButton.frame = CGRect(x: screenWidth-90-padding, y: amountTextField.frame.origin.y, width: 100, height: 40)
        amountMaxButton.addTarget(self, action: #selector(pressedMaxButton(_:)), for: .touchUpInside)
        scrollView.addSubview(amountMaxButton)
        
        // 3rd Row: Transaction
        transactionFeeLabel.frame = CGRect(x: padding, y: amountTextField.frame.maxY + padding, width: screenWidth, height: 40)
        transactionFeeLabel.font = FontConfigManager.shared.getLabelsFont()
        transactionFeeLabel.textColor = UIColor.tokenestTip
        transactionFeeLabel.text = "矿工费(ETH)"
        scrollView.addSubview(transactionFeeLabel)
        
        transactionValueLabel.frame = CGRect(x: padding, y: transactionFeeLabel.frame.maxY, width: 100, height: 40)
        transactionValueLabel.text  = "0.00000"
        transactionValueLabel.font = FontConfigManager.shared.getLabelFont()
        scrollView.addSubview(transactionValueLabel)
        
        let originX = transactionValueLabel.intrinsicContentSize.width + padding
        transactionCurrencyLabel.frame = CGRect(x: originX, y: transactionFeeLabel.frame.maxY, width: 100, height: 40)
        transactionCurrencyLabel.font = FontConfigManager.shared.getLabelsFont()
        transactionCurrencyLabel.textColor = UIColor.tokenestTip
        scrollView.addSubview(transactionCurrencyLabel)
        
        transactionTipButton.frame = CGRect(x: screenWidth-padding-120, y: transactionFeeLabel.frame.maxY, width: 120, height: 40)
        transactionTipButton.titleColor = UIColor.tokenestButton
        transactionTipButton.titleLabel?.font = FontConfigManager.shared.getLabelsFont()
        transactionTipButton.contentHorizontalAlignment = .right
        transactionTipButton.title = "获取推荐油费"
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
        transactionAmountMinLabel.font = FontConfigManager.shared.getLabelFont()
        transactionAmountMinLabel.text = NSLocalizedString("Slow", comment: "")
        scrollView.addSubview(transactionAmountMinLabel)
        
        transactionAmountCurrentLabel.textAlignment = .center
        transactionAmountCurrentLabel.frame = CGRect(x: transactionAmountMinLabel.frame.maxX, y: transactionAmountMinLabel.frame.minY, width: (screenWidth-2*padding)*3/4, height: 30)
        transactionAmountCurrentLabel.font = FontConfigManager.shared.getLabelFont()
        transactionAmountCurrentLabel.text = NSLocalizedString("gas price", comment: "") + ": \(gasPriceInGwei) gwei"
        
        scrollView.addSubview(transactionAmountCurrentLabel)
        
        let pad = (transactionAmountCurrentLabel.frame.width - transactionAmountCurrentLabel.intrinsicContentSize.width) / 2
        transactionAmountHelpButton.frame = CGRect(x: transactionAmountCurrentLabel.frame.maxX - pad, y: transactionAmountCurrentLabel.frame.minY, width: 30, height: 30)
        transactionAmountHelpButton.image = UIImage(named: "HelpIcon")
        transactionAmountHelpButton.addTarget(self, action: #selector(pressedHelpButton), for: .touchUpInside)
        scrollView.addSubview(transactionAmountHelpButton)
        
        transactionAmountMaxLabel.textAlignment = .right
        transactionAmountMaxLabel.frame = CGRect(x: transactionAmountCurrentLabel.frame.maxX, y: transactionAmountMinLabel.frame.minY, width: (screenWidth-2*padding)/8, height: 30)
        transactionAmountMaxLabel.font = FontConfigManager.shared.getLabelFont()
        transactionAmountMaxLabel.text = NSLocalizedString("Fast", comment: "")
        scrollView.addSubview(transactionAmountMaxLabel)
        
        // send button
        sendButton.setupRoundPurple()
        sendButton.title = "转出"
        sendButton.frame = CGRect(x: padding*4, y: transactionAmountMaxLabel.frame.maxY + padding*3, width: screenWidth-padding*8, height: 48)
        sendButton.addTarget(self, action: #selector(pressedSendButton(_:)), for: .touchUpInside)
        scrollView.addSubview(sendButton)

        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: screenWidth, height: sendButton.frame.maxY + 30)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidChange), name: .UITextFieldTextDidChange, object: nil)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(scrollViewTap)
        
        // Get the latest estimate gas price from Relay.
        GasDataManager.shared.getEstimateGasPrice { (gasPrice, _) in
            self.gasPriceInGwei = Double(gasPrice)
            self.recGasPriceInGwei = Double(gasPrice)
            DispatchQueue.main.async {
                
                self.updateTransactionFeeAmountLabel(self.gasPriceInGwei)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCollectionHeight() -> CGFloat {
        var height: CGFloat = 0
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            let rows = ceil(Double(wallet.assetSequence.count / 4))
            height = CGFloat(rows * 55)
        }
        return height
    }
    
    func updateTransactionFeeAmountLabel(_ gasPriceInGwei: Double) {
        let amountInEther = gasPriceInGwei / 1000000000
        let totalGasInEther = amountInEther * Double(GasDataManager.shared.getGasLimit(by: "eth_transfer")!)
        transactionAmountCurrentLabel.text = NSLocalizedString("gas price", comment: "") + ": \(gasPriceInGwei) gwei"
        if let etherPrice = PriceDataManager.shared.getPrice(of: "ETH") {
            let transactionFeeInFiat = totalGasInEther * etherPrice
            transactionValueLabel.text = "\(totalGasInEther.withCommas(5))"
            transactionCurrencyLabel.text = "  ≈\(transactionFeeInFiat.currency)"
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
    
    func hideCollectionView() {
        moreTokensButton.setImage(#imageLiteral(resourceName: "Tokenest-moretoken"), for: .normal)
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
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
            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
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
                updateLabel(label: addressInfoLabel, text: NSLocalizedString("Please input a correct address", comment: ""), textColor: .red)
            } else {
                updateLabel(label: addressInfoLabel, text: NSLocalizedString("转账地址", comment: ""), textColor: .tokenestTip)
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
                                updateLabel(label: amountInfoLabel, text: display, textColor: .tokenestTip)
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
            updateLabel(label: amountInfoLabel, text: 0.0.currency, textColor: .tokenestTip)
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
    
    func pushController() {
        let toAddress = addressTextField.text!
        if let token = TokenDataManager.shared.getTokenBySymbol(asset!.symbol) {
            let gethAmount = GethBigInt.generate(valueInEther: Double(amountTextField.text!)!, symbol: token.symbol)!
            var error: NSError? = nil
            let toAddress = GethNewAddressFromHex(toAddress, &error)!
            if token.symbol.uppercased() == "ETH" {
                SendCurrentAppWalletDataManager.shared._transferETH(amount: gethAmount, toAddress: toAddress, completion: completion)
            } else {
                // TODO: Error handling for invalid protocol value
                if !token.protocol_value.isHexAddress() {
                    print("token protocol \(token.protocol_value) is invalid")
                    return
                }
                let contractAddress = GethNewAddressFromHex(token.protocol_value, &error)!
                SendCurrentAppWalletDataManager.shared._transferToken(contractAddress: contractAddress, toAddress: toAddress, tokenAmount: gethAmount, completion: completion)
            }
        }
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
            SVProgressHUD.show(withStatus: "Processing the transaction ...")
            self.pushController()
        }
        if !isAmountValid && amountInfoLabel.textColor != .red {
            amountInfoLabel.text = NSLocalizedString("Please input a valid amount", comment: "")
            amountInfoLabel.textColor = .red
            amountInfoLabel.shake()
        }
        if !isAddressValid && addressInfoLabel.textColor != .red {
            addressInfoLabel.text = NSLocalizedString("Please input a correct address", comment: "")
            addressInfoLabel.textColor = .red
            addressInfoLabel.shake()
        }
    }
    
    @objc func pressedMaxButton(_ sender: UIButton) {
        amountTextField.text = asset.display
        if let price = PriceDataManager.shared.getPrice(of: asset.symbol) {
            let total = asset.balance * price
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
            self.scrollViewBottomConstraint.constant = systemKeyboardHeight + bottomPadding
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            return wallet.assetSequence.count / 4
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AssetCollectionViewCell.getCellIdentifier(), for: indexPath) as? AssetCollectionViewCell
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            cell?.asset = wallet.assetSequence[indexPath.row + (indexPath.section*4)]
        }
        if selectedIndexPath != nil && selectedIndexPath == indexPath || cell?.asset?.lowercased() == self.asset.symbol.lowercased() {
            cell?.highlightEffect()
        } else {
            cell?.removeHighlight()
        }
        cell?.update()
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        let cell = collectionView.cellForItem(at: indexPath) as! AssetCollectionViewCell
        cell.highlightEffect()
        hideCollectionView()
        if let wallet = CurrentAppWalletDataManager.shared.getCurrentAppWallet() {
            let symbol = wallet.assetSequence[indexPath.row + (indexPath.section*4)]
            if let token = TokenDataManager.shared.getTokenBySymbol(symbol) {
                tokenImage.image = token.icon
                nameLabel.text = token.source
                tokenLabel.text = token.symbol
                if let asset = CurrentAppWalletDataManager.shared.getAsset(symbol: symbol) {
                    self.asset = asset
                    amountLabel.text = asset.display
                }
            }
        }
        tokensCollectionView.reloadData()
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider!) {
        print("Slider value changed \(sender.value)")
        let step: Float = 1
        let roundedStepValue = round(sender.value / step) * step
        gasPriceInGwei = Double(roundedStepValue)
        updateTransactionFeeAmountLabel(self.gasPriceInGwei)
    }
    
    @objc func pressedScanButton(_ sender: UIButton) {
        let viewController = ScanQRCodeViewController()
        viewController.delegate = self
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: true)
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

extension SendViewController {
    
    func completion(_ txHash: String?, _ error: Error?) {
        SVProgressHUD.dismiss()
        guard error == nil && txHash != nil else {
            DispatchQueue.main.async {
                let title = NSLocalizedString("Failed to send the transaction", comment: "")
                let message = String(describing: error)
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Back", comment: ""), style: .default, handler: { _ in
                }))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        print("Result of transfer is \(txHash!)")
        DispatchQueue.main.async {
            let title = NSLocalizedString("Sent the transaction successfully", comment: "")
            let message = "Result of transfer is \(txHash!)"
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
