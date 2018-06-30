//
//  TradeBuyViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/11/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import Geth

class TradeViewController: UIViewController, UITextFieldDelegate, NumericKeyboardDelegate, NumericKeyboardProtocol {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var scrollViewBottom: NSLayoutConstraint!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var exchangelabel: UILabel!
    
    var historyBarButton: UIBarButtonItem!

    // TokenS
    var tokenSButton: UIButton = UIButton()
    var amountSellTextField: UITextField = UITextField()
    var tokenSUnderLine: UIView = UIView()
    var estimateValueInCurrency: UILabel = UILabel()
    
    // TokenB
    var tokenBButton: UIButton = UIButton()
    var amountBuyTextField: UITextField = UITextField()
    var totalUnderLine: UIView = UIView()
    var availableLabel: UILabel = UILabel()

    // Numeric keyboard
    var isNumericKeyboardShown: Bool = false
    var numericKeyboardView: DefaultNumericKeyboard!

    var activeTextFieldTag = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subtitleLabel.textColor = UIColor.tokenestTip
        subtitleLabel.font = FontConfigManager.shared.getLabelSCFont(size: 18)
        exchangelabel.textColor = UIColor.tokenestTableFont
        exchangelabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        
        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        
        let originY: CGFloat = 60
        let padding: CGFloat = 15
        let tokenButtonWidth: CGFloat = 60
        let textFieldWidth: CGFloat = 200

        // First row: TokenS
        tokenSButton.setTitleColor(UIColor.tokenestTableFont, for: .normal)
        tokenSButton.setTitleColor(UIColor.tokenestTableFont.withAlphaComponent(0.3), for: .highlighted)
        tokenSButton.titleLabel?.font = FontConfigManager.shared.getLabelENFont(size: 18)
        tokenSButton.frame = CGRect(x: padding, y: originY, width: tokenButtonWidth, height: 40)
        tokenSButton.addTarget(self, action: #selector(pressedSwitchTokenSButton), for: .touchUpInside)
        scrollView.addSubview(tokenSButton)
        
        amountSellTextField.frame = CGRect(x: screenWidth-textFieldWidth-padding, y: originY, width: textFieldWidth, height: 40)
        amountSellTextField.delegate = self
        amountSellTextField.tag = 0
        amountSellTextField.inputView = UIView()
        amountSellTextField.font = FontConfigManager.shared.getLabelENFont(size: 18)
        amountSellTextField.theme_tintColor = GlobalPicker.textColor
        amountSellTextField.placeholder = LocalizedString("Enter the amount you have", comment: "")
        amountSellTextField.textAlignment = .right
        scrollView.addSubview(amountSellTextField)
        
        estimateValueInCurrency.textColor = UIColor.tokenestTip
        estimateValueInCurrency.font = FontConfigManager.shared.getLabelENFont(size: 12)
        estimateValueInCurrency.frame = CGRect(x: screenWidth-padding-textFieldWidth, y: amountSellTextField.frame.maxY, width: textFieldWidth, height: 40)
        estimateValueInCurrency.textAlignment = .right
        scrollView.addSubview(estimateValueInCurrency)
        
        tokenSUnderLine.frame = CGRect(x: padding, y: estimateValueInCurrency.frame.maxY, width: screenWidth - padding * 2, height: 0.5)
        tokenSUnderLine.backgroundColor = UIColor.tokenestBorder
        scrollView.addSubview(tokenSUnderLine)
        
        // Second row: exchange label
        tokenBButton.setTitleColor(UIColor.tokenestTableFont, for: .normal)
        tokenBButton.setTitleColor(UIColor.tokenestTableFont.withAlphaComponent(0.3), for: .highlighted)
        tokenBButton.titleLabel?.font = FontConfigManager.shared.getLabelENFont(size: 18)
        tokenBButton.frame = CGRect(x: padding, y: tokenSUnderLine.frame.maxY + padding*2, width: tokenButtonWidth, height: 40)
        tokenBButton.addTarget(self, action: #selector(pressedSwitchTokenBButton), for: .touchUpInside)
        scrollView.addSubview(tokenBButton)
        
        amountBuyTextField.frame = CGRect(x: screenWidth-padding-textFieldWidth, y: tokenSUnderLine.frame.maxY + padding*2, width: textFieldWidth, height: 40)
        amountBuyTextField.delegate = self
        amountBuyTextField.tag = 2
        amountBuyTextField.inputView = UIView()
        amountBuyTextField.font = FontConfigManager.shared.getLabelENFont(size: 18)
        amountBuyTextField.theme_tintColor = GlobalPicker.textColor
        amountBuyTextField.placeholder = LocalizedString("Enter the amount you get", comment: "")
        amountBuyTextField.textAlignment = .right
        scrollView.addSubview(amountBuyTextField)

        scrollView.contentSize = CGSize(width: screenWidth, height: amountBuyTextField.frame.maxY + 30)
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
        self.navigationController?.setToolbarHidden(true, animated: false)
        tokenSButton.setTitle(TradeDataManager.shared.tokenS.symbol, for: .normal)
        tokenSButton.setRightImage(imageName: "Arrow-down-black", imagePaddingTop: 0, imagePaddingLeft: 10, titlePaddingRight: 0)
        tokenBButton.setTitle(TradeDataManager.shared.tokenB.symbol, for: .normal)
        tokenBButton.setRightImage(imageName: "Arrow-down-black", imagePaddingTop: 0, imagePaddingLeft: 10, titlePaddingRight: 0)
        updateTipLabel()
        updateInfoLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: false)
    }
    
    func updateInfoLabel() {
        let tokens = TradeDataManager.shared.tokenS.symbol
        let tokenb = TradeDataManager.shared.tokenB.symbol
        let pair = TradeDataManager.shared.tradePair
        if let market = MarketDataManager.shared.getMarket(byTradingPair: pair) {
            exchangelabel.isHidden = false
            exchangelabel.text = "1 \(tokens) ≈ \(market.balance) \(tokenb)"
        } else {
            exchangelabel.isHidden = true
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
            let title = LocalizedString("Available Balance", comment: "")
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
    
    @IBAction func pressedHistoryButton(_ sender: UIButton) {
        let viewController = P2POrderHistoryViewController()
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
            estimateValueInCurrency.text = LocalizedString("Please input a valid amount", comment: "")
            estimateValueInCurrency.textColor = .red
            estimateValueInCurrency.shake()
        }
        if !isBuyValid {
            availableLabel.isHidden = false
            availableLabel.text = LocalizedString("Please input a valid amount", comment: "")
            availableLabel.textColor = .red
            availableLabel.shake()
        }
    }
    
    func constructMaker() -> OriginalOrder? {
        var buyNoMoreThanAmountB: Bool
        var amountBuy, amountSell: Double
        var tokenSell, tokenBuy, market: String
        
        tokenBuy = TradeDataManager.shared.tokenB.symbol
        tokenSell = TradeDataManager.shared.tokenS.symbol
        market = "\(tokenSell)/\(tokenBuy)"
        amountBuy = Double(amountBuyTextField.text!)!
        amountSell = Double(amountSellTextField.text!)!
        
        buyNoMoreThanAmountB = false
        let delegate = RelayAPIConfiguration.delegateAddress
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address
        
        // P2P 订单 默认 1hour 过期，或增加ui调整
        // let since = Int64(Date().timeIntervalSince1970)
        // let until = Int64(Calendar.current.date(byAdding: .hour, value: 1, to: Date())!.timeIntervalSince1970)
        let since = Int64(1530806400)
        let until = Int64(1530979200)
        
        var order = OriginalOrder(delegate: delegate, address: address, side: "sell", tokenS: tokenSell, tokenB: tokenBuy, validSince: since, validUntil: until, amountBuy: amountBuy, amountSell: amountSell, lrcFee: 0, buyNoMoreThanAmountB: buyNoMoreThanAmountB, orderType: .p2pOrder, market: market)
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
        let title = LocalizedString("Available Balance", comment: "")
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
            let height = self.view.frame.height
            scrollViewBottom.constant = DefaultNumericKeyboard.height
            numericKeyboardView = DefaultNumericKeyboard(frame: CGRect(x: 0, y: height, width: width, height: DefaultNumericKeyboard.height))
            numericKeyboardView.delegate = self
            view.addSubview(numericKeyboardView)
            
            let barHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
            let destinateY = height - DefaultNumericKeyboard.height - barHeight
            
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
            let height = self.view.frame.height
            self.scrollViewBottom.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                // animation for layout constraint change.
                self.view.layoutIfNeeded()
                self.numericKeyboardView.frame = CGRect(x: 0, y: height, width: width, height: DefaultNumericKeyboard.height)
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
