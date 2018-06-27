//
//  TradeBuyViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/11/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import Geth

class TradeViewController: UIViewController, UITextFieldDelegate, NumericKeyboardDelegate, NumericKeyboardProtocol, QRCodeScanProtocol, AmountStackViewDelegate {

    @IBOutlet weak var progressBar: UIView!
    @IBOutlet weak var customNaviBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewButtonLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextBackgroundView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    var qrCodeBarButton: UIBarButtonItem!
    var historyBarButton: UIBarButtonItem!

    // TokenS
    var tokenSButton: UIButton = UIButton()
    var amountSellTextField: FloatLabelTextField!
    var tokenSUnderLine: UIView = UIView()
    var estimateValueInCurrency: UILabel = UILabel()
    var amountStackView: AmountStackView!
    
    // Exchange label
    var exchangeImage: UIImageView = UIImageView()
    var exchangeLabel: UILabel = UILabel()
    
    // TokenB
    var tokenBButton: UIButton = UIButton()
    var amountBuyTextField: FloatLabelTextField!
    var totalUnderLine: UIView = UIView()
    var availableLabel: UILabel = UILabel()

    // Numeric keyboard
    var isNumericKeyboardShown: Bool = false
    var numericKeyboardView: DefaultNumericKeyboard!

    var activeTextFieldTag = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        progressBar.backgroundColor = GlobalPicker.themeColor
        scrollViewButtonLayoutConstraint.constant = 0
        
        let qrScanButton = UIButton(type: UIButtonType.custom)
        // TODO: smaller images.
        qrScanButton.theme_setImage(["Scan", "Scan-white"], forState: UIControlState.normal)
        qrScanButton.setImage(UIImage(named: "Scan")?.alpha(0.3), for: .highlighted)
        qrScanButton.addTarget(self, action: #selector(self.pressQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrScanButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        qrCodeBarButton = UIBarButtonItem(customView: qrScanButton)
        
        let historyButton = UIButton(type: UIButtonType.custom)
        // TODO: smaller images.
        historyButton.theme_setImage(["Order-history-black", "Order-history-white"], forState: UIControlState.normal)
        historyButton.setImage(UIImage(named: "Order-history-black")?.alpha(0.3), for: .highlighted)
        historyButton.addTarget(self, action: #selector(self.pressedOrderHistoryButton(_:)), for: UIControlEvents.touchUpInside)
        historyButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        historyBarButton = UIBarButtonItem(customView: historyButton)
        
        nextButton.title = NSLocalizedString("Next", comment: "")
        nextButton.setupRoundBlack()
        
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        
        let originY: CGFloat = 60
        let padding: CGFloat = 15
        let tokenButtonWidth: CGFloat = 60

        // First row: TokenS
        
        tokenSButton.setTitleColor(UIColor.black, for: .normal)
        tokenSButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
        tokenSButton.titleLabel?.font = FontConfigManager.shared.getLabelENFont()
        tokenSButton.frame = CGRect(x: screenWidth-padding-tokenButtonWidth, y: originY, width: tokenButtonWidth, height: 40)
        tokenSButton.addTarget(self, action: #selector(pressedSwitchTokenSButton), for: .touchUpInside)
        scrollView.addSubview(tokenSButton)
        
        amountSellTextField = FloatLabelTextField(frame: CGRect(x: padding, y: originY, width: screenWidth-padding*2-80, height: 40))
        amountSellTextField.delegate = self
        amountSellTextField.tag = 0
        amountSellTextField.inputView = UIView()
        amountSellTextField.font = FontConfigManager.shared.getLabelENFont()
        amountSellTextField.theme_tintColor = GlobalPicker.textColor
        amountSellTextField.placeholder = NSLocalizedString("Enter the amount you have", comment: "")
        amountSellTextField.contentMode = UIViewContentMode.bottom
        scrollView.addSubview(amountSellTextField)
        
        tokenSUnderLine.frame = CGRect(x: padding, y: tokenSButton.frame.maxY, width: screenWidth - padding * 2, height: 1)
        tokenSUnderLine.backgroundColor = UIColor.black
        scrollView.addSubview(tokenSUnderLine)
        
        estimateValueInCurrency.font = FontConfigManager.shared.getLabelENFont()
        estimateValueInCurrency.frame = CGRect(x: padding, y: tokenSUnderLine.frame.maxY, width: screenWidth-padding*2-80, height: 40)
        scrollView.addSubview(estimateValueInCurrency)
        
        amountStackView = AmountStackView(frame: CGRect(x: screenWidth-100-padding, y: tokenSUnderLine.frame.maxY, width: 100, height: 40))
        amountStackView.delegate = self
        scrollView.addSubview(amountStackView)
        
        // Second row: exchange label
        
        exchangeImage.image = UIImage(named: "Trading")
        exchangeLabel.font = FontConfigManager.shared.getLabelENFont(size: 15)
        exchangeLabel.textAlignment = .center
        exchangeLabel.frame = CGRect(x: 0, y: estimateValueInCurrency.frame.maxY + padding*2, width: screenWidth, height: 40)
        scrollView.addSubview(exchangeLabel)
        
        // Thrid row: TokenB

        tokenBButton.setTitleColor(UIColor.black, for: .normal)
        tokenBButton.setTitleColor(UIColor.black.withAlphaComponent(0.3), for: .highlighted)
        tokenBButton.titleLabel?.font = FontConfigManager.shared.getLabelENFont()
        tokenBButton.frame = CGRect(x: screenWidth-padding-tokenButtonWidth, y: exchangeLabel.frame.maxY + padding*2, width: tokenButtonWidth, height: 40)
        tokenBButton.addTarget(self, action: #selector(pressedSwitchTokenBButton), for: .touchUpInside)
        scrollView.addSubview(tokenBButton)
        
        amountBuyTextField = FloatLabelTextField(frame: CGRect(x: padding, y: exchangeLabel.frame.maxY + padding*2, width: screenWidth-padding*2-80, height: 40))
        amountBuyTextField.delegate = self
        amountBuyTextField.tag = 2
        amountBuyTextField.inputView = UIView()
        amountBuyTextField.font = FontConfigManager.shared.getLabelENFont()
        amountBuyTextField.theme_tintColor = GlobalPicker.textColor
        amountBuyTextField.placeholder = NSLocalizedString("Enter the amount you get", comment: "")
        amountBuyTextField.contentMode = UIViewContentMode.bottom
        scrollView.addSubview(amountBuyTextField)
        
        totalUnderLine.frame = CGRect(x: padding, y: tokenBButton.frame.maxY, width: screenWidth - padding * 2, height: 1)
        totalUnderLine.backgroundColor = UIColor.black
        scrollView.addSubview(totalUnderLine)
        
        availableLabel.text = ""
        availableLabel.font = FontConfigManager.shared.getLabelENFont()
        availableLabel.frame = CGRect(x: padding, y: totalUnderLine.frame.maxY, width: screenWidth-padding*2-80, height: 40)
        scrollView.addSubview(availableLabel)

        scrollView.contentSize = CGSize(width: screenWidth, height: availableLabel.frame.maxY + 30)
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(scrollViewTap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setBackButtonAndUpdateTitle(customizedNavigationBar: customNaviBar, title: "P2P交易")
        
        // A hack solution to bring history icon back. It's not a perfect soluction
        customNaviBar.topItem?.leftBarButtonItem = qrCodeBarButton
        customNaviBar.topItem?.rightBarButtonItem = historyBarButton
        
        tokenSButton.setTitle(TradeDataManager.shared.tokenS.symbol, for: .normal)
        tokenSButton.setRightImage(imageName: "Arrow-down-black", imagePaddingTop: 0, imagePaddingLeft: 10, titlePaddingRight: 0)
        tokenBButton.setTitle(TradeDataManager.shared.tokenB.symbol, for: .normal)
        tokenBButton.setRightImage(imageName: "Arrow-down-black", imagePaddingTop: 0, imagePaddingLeft: 10, titlePaddingRight: 0)
        updateTipLabel()
        updateInfoLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func updateInfoLabel() {
        let tokens = TradeDataManager.shared.tokenS.symbol
        let tokenb = TradeDataManager.shared.tokenB.symbol
        let pair = TradeDataManager.shared.tradePair
        if let market = MarketDataManager.shared.getMarket(byTradingPair: pair) {
            exchangeLabel.isHidden = false
            exchangeLabel.text = "Exchange (1 \(tokens) ≈ \(market.balance) \(tokenb))"
            let width = (UIScreen.main.bounds.width - exchangeLabel.intrinsicContentSize.width) / 2
            exchangeImage.frame = CGRect(x: width - 25, y: 10, width: 20, height: 20)
            exchangeLabel.addSubview(exchangeImage)
        } else {
            exchangeLabel.isHidden = true
        }
    }
    
    func updateTipLabel(text: String? = nil, color: UIColor? = nil) {
        if let text = text, let color = color {
            estimateValueInCurrency.text = text
            estimateValueInCurrency.textColor = color
            if color == .red {
                estimateValueInCurrency.shake()
            }
        } else {
            let tokens = TradeDataManager.shared.tokenS.symbol
            let title = NSLocalizedString("Available Balance", comment: "")
            if let balance = CurrentAppWalletDataManager.shared.getBalance(of: tokens) {
                estimateValueInCurrency.text = "\(title) \(balance) \(tokens)"
            } else {
                estimateValueInCurrency.text = "\(title) 0.0 \(tokens)"
            }
            estimateValueInCurrency.textColor = .black
        }
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        amountSellTextField.resignFirstResponder()
        amountBuyTextField.resignFirstResponder()
        hideNumericKeyboard()
    }
    
    @objc func pressQRCodeButton(_ sender: Any) {
        print("Selected Scan QR code")
        let viewController = ScanQRCodeViewController()
        viewController.delegate = self
        viewController.shouldPop = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedOrderHistoryButton(_ sender: Any) {
        print("pressedOrderHistoryButton")
        let viewController = P2POrderHistoryViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedSwitchTokenSButton(_ sender: Any) {
        print("pressedSwitchTokenSButton")
        let viewController = SwitchTradeTokenViewController()
        viewController.type = .tokenS
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedSwitchTokenBButton(_ sender: Any) {
        print("pressedSwitchTokenBButton")
        let viewController = SwitchTradeTokenViewController()
        viewController.type = .tokenB
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func pressedNextButton(_ sender: Any) {
        print("pressedNextButton")
        hideNumericKeyboard()
        amountSellTextField.resignFirstResponder()
        amountBuyTextField.resignFirstResponder()
        
        let isBuyValid = validateAmountBuy()
        let isSellValid = validateAmountSell()
        if isSellValid && isBuyValid {
            self.pushController()
        }
        if !isSellValid && estimateValueInCurrency.textColor != .red {
            estimateValueInCurrency.text = NSLocalizedString("Please input a valid amount", comment: "")
            estimateValueInCurrency.textColor = .red
            estimateValueInCurrency.shake()
        }
        if !isBuyValid {
            availableLabel.isHidden = false
            availableLabel.text = NSLocalizedString("Please input a valid amount", comment: "")
            availableLabel.textColor = .red
            availableLabel.shake()
        }
    }
    
    func constructMaker() -> OriginalOrder? {
        var buyNoMoreThanAmountB: Bool
        var tokenSell, tokenBuy: String
        var amountBuy, amountSell, lrcFee: Double
        tokenBuy = TradeDataManager.shared.tokenB.symbol
        tokenSell = TradeDataManager.shared.tokenS.symbol
        amountBuy = Double(amountBuyTextField.text!)!
        amountSell = Double(amountSellTextField.text!)!
        buyNoMoreThanAmountB = false
        
        lrcFee = 0
        
        let delegate = RelayAPIConfiguration.delegateAddress
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address
        
//        let since = Int64(Date().timeIntervalSince1970)
//        let until = Int64(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!.timeIntervalSince1970)
        
        let since = Int64(1530078002) // test
        let until = Int64(1530079142) // test
        
        var order = OriginalOrder(delegate: delegate, address: address, side: "sell", tokenS: tokenSell, tokenB: tokenBuy, validSince: since, validUntil: until, amountBuy: amountBuy, amountSell: amountSell, lrcFee: lrcFee, buyNoMoreThanAmountB: buyNoMoreThanAmountB, orderType: .p2pOrder)
        PlaceOrderDataManager.shared.completeOrder(&order)
        return order
    }
    
    func preserveMaker(order: OriginalOrder) {
        let defaults = UserDefaults.standard
        let orderData = [order.hash: order.authPrivateKey]
        defaults.set(orderData, forKey: UserDefaultsKeys.p2pOrder.rawValue)
    }
    
    func pushController() {
        if let order = constructMaker() {
            preserveMaker(order: order)
            TradeDataManager.shared.isTaker = false
            let viewController = TradeConfirmationViewController()
            viewController.order = order
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func validateAmountSell() -> Bool {
        var text: String
        let tokens = TradeDataManager.shared.tokenS.symbol
        let title = NSLocalizedString("Available Balance", comment: "")
        if let amounts = amountSellTextField.text, let amountSell = Double(amounts) {
            if let balance = CurrentAppWalletDataManager.shared.getBalance(of: tokens) {
                if amountSell > balance {
                    text = "\(title) \(balance) \(tokens)"
                    updateTipLabel(text: text, color: .red)
                    return false
                } else {
                    if let price = PriceDataManager.shared.getPrice(of: tokens) {
                        let estimateValue: Double = amountSell * price
                        text = estimateValue.currency
                        updateTipLabel(text: text, color: .black)
                    }
                    return true
                }
            } else {
                if amountSell == 0 {
                    text = 0.0.currency
                    updateTipLabel(text: text, color: .black)
                    return true
                } else {
                    text = "\(title) 0.0 \(tokens)"
                    updateTipLabel(text: text, color: .red)
                    return false
                }
            }
        } else {
            if let balance = CurrentAppWalletDataManager.shared.getBalance(of: tokens) {
                text = "\(title) \(balance) \(tokens)"
            } else {
                text = "\(title) 0.0 \(tokens)"
            }
            updateTipLabel(text: text, color: .black)
            return false
        }
    }
    
    func validateAmountBuy() -> Bool {
        availableLabel.isHidden = true
        if let amountb = amountBuyTextField.text, Double(amountb) != nil {
            return true
        } else {
            return false
        }
    }
    
    func validate() -> Bool {
        var isValid = false
        if activeTextFieldTag == amountSellTextField.tag {
            isValid = validateAmountSell()
        } else if activeTextFieldTag == amountBuyTextField.tag {
            isValid = validateAmountBuy()
        }
        return isValid
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        activeTextFieldTag = textField.tag
        showNumericKeyboard(textField: textField)
        _ = validate()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing")
    }
    
    func getActiveTextField() -> UITextField? {
        if activeTextFieldTag == amountSellTextField.tag {
            return amountSellTextField
        } else if activeTextFieldTag == amountBuyTextField.tag {
            return amountBuyTextField
        } else {
            return nil
        }
    }
    
    func showNumericKeyboard(textField: UITextField) {
        if !isNumericKeyboardShown {
            let width = self.view.frame.width
            let height = self.nextBackgroundView.frame.origin.y

            scrollViewButtonLayoutConstraint.constant = DefaultNumericKeyboard.height
            
            numericKeyboardView = DefaultNumericKeyboard(frame: CGRect(x: 0, y: height, width: width, height: DefaultNumericKeyboard.height))
            numericKeyboardView.delegate = self
            view.addSubview(numericKeyboardView)
            view.bringSubview(toFront: nextBackgroundView)
            view.bringSubview(toFront: nextButton)
            
            let destinateY = height - DefaultNumericKeyboard.height
            
            // TODO: improve the animation.
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
            }, completion: { finished in
                self.isNumericKeyboardShown = true
                if finished {
                    if textField.tag == self.amountBuyTextField.tag {
                        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                        self.scrollView.setContentOffset(bottomOffset, animated: true)
                    }
                }
            })
        } else {
            if textField.tag == amountBuyTextField.tag {
                let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.size.height)
                self.scrollView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    func hideNumericKeyboard() {
        if isNumericKeyboardShown {
            let width = self.view.frame.width
            let height = self.nextBackgroundView.frame.origin.y
            let destinateY = height
            self.scrollViewButtonLayoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                // animation for layout constraint change.
                self.view.layoutIfNeeded()
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
            }, completion: { finished in
                self.isNumericKeyboardShown = false
                if finished {
                    
                }
            })
        } else {
            self.scrollView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    func numericKeyboard(_ numericKeyboard: NumericKeyboard, itemTapped item: NumericKeyboardItem, atPosition position: Position) {
        print("pressed keyboard: (\(position.row), \(position.column))")
        
        let activeTextField: UITextField? = getActiveTextField()
        guard activeTextField != nil else {
            return
        }
        var currentText = activeTextField!.text ?? ""
        switch (position.row, position.column) {
        case (3, 0):
            activeTextField!.text = currentText + "."
        case (3, 1):
            activeTextField!.text = currentText + "0"
        case (3, 2):
            if currentText.count > 0 {
                currentText = String(currentText.dropLast())
            }
            activeTextField!.text = currentText
        default:
            let itemValue = position.row * 3 + position.column + 1
            activeTextField!.text = currentText + String(itemValue)
        }
        _ = validate()
    }

    func numericKeyboard(_ numericKeyboard: NumericKeyboard, itemLongPressed item: NumericKeyboardItem, atPosition position: Position) {
        print("Long pressed keyboard: (\(position.row), \(position.column))")
        let activeTextField = getActiveTextField()
        guard activeTextField != nil else {
            return
        }
        var currentText = activeTextField!.text ?? ""
        if (position.row, position.column) == (3, 2) {
            if currentText.count > 0 {
                currentText = String(currentText.dropLast())
            }
            activeTextField!.text = currentText
        }
    }
    
    func setResultOfScanningQRCode(valueSent: String, type: QRCodeType) {
        let values = valueSent.components(separatedBy: TradeDataManager.seperator)
        guard values.count == 2 else { return }
        let makerHash = values[0]
        let makerPrivateKey = values[1]
        if let maker = TradeDataManager.shared.getOrder(by: makerHash) {
            let taker = TradeDataManager.shared.constructTaker(from: maker)
            maker.hash = makerHash
            TradeDataManager.shared.isTaker = true
            TradeDataManager.shared.orders = []
            TradeDataManager.shared.orders.insert(maker, at: 0)
            TradeDataManager.shared.orders.insert(taker, at: 1)
            TradeDataManager.shared.makerPrivateKey = makerPrivateKey
            let vc = TradeConfirmationViewController()
            vc.order = taker
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setResultOfAmount(with percentage: Double) {
        let tokens = TradeDataManager.shared.tokenS.symbol
        if let balance = CurrentAppWalletDataManager.shared.getBalance(of: tokens) {
            amountSellTextField.text = (balance * percentage).withCommas()
        } else {
            amountSellTextField.text = "0.0"
        }
        activeTextFieldTag = amountSellTextField.tag
        _ = validate()
    }
}
