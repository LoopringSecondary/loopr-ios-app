//
//  ConvertETHViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/18/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import Geth
import NotificationBannerSwift

class ConvertETHViewController: UIViewController, UITextFieldDelegate, DefaultNumericKeyboardDelegate, NumericKeyboardDelegate, NumericKeyboardProtocol {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    @IBOutlet weak var availableTipLabel: UILabel!
    @IBOutlet weak var tokenSLabel: UILabel!
    @IBOutlet weak var tokenBLabel: UILabel!
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var ethAmountLabel: UILabel!
    @IBOutlet weak var wethAmountLabel: UILabel!
    @IBOutlet weak var amountSTextField: UITextField!
    @IBOutlet weak var amountBTextField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewBottomLayoutConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var convertButton: UIButton!
    @IBOutlet weak var totalMaskView: UIView!
    
    var asset: Asset?
    
    var availableLabels: [String: UILabel] = [:]

    // Numeric Keyboard
    var isNumericKeyboardShow: Bool = false
    var numericKeyboardView: DefaultNumericKeyboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customizedNavigationBar.shadowImage = UIImage()
        self.statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        scrollViewBottomLayoutConstraint.constant = 0
        
        // token labels
        tokenSLabel.text = asset?.symbol
        tokenBLabel.text = getAnotherAsset()?.symbol
        
        // amount textfield
        amountSTextField.delegate = self
        amountSTextField.inputView = UIView()
 
        // Labels
        availableLabels["ETH"] = ethAmountLabel
        availableLabels["WETH"] = wethAmountLabel
        tipLabel.font = FontConfigManager.shared.getLabelSCFont(size: 10)
        ethAmountLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        ethAmountLabel.text = ConvertDataManager.shared.getMaxAmountString("ETH")
        wethAmountLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        wethAmountLabel.text = ConvertDataManager.shared.getMaxAmountString("WETH")
        availableTipLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        availableTipLabel.alpha = 0.8
        
        // Convert button
        convertButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        convertButton.title = NSLocalizedString("Convert", comment: "")
        convertButton.setupRoundPurpleWithShadow()
        
        let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        scrollViewTap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(scrollViewTap)
        SendCurrentAppWalletDataManager.shared.getNonceFromEthereum()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("Convert", comment: ""))
    }
    
    @objc func scrollViewTapped() {
        print("scrollViewTapped")
        amountSTextField.resignFirstResponder()
        self.view.endEditing(true)
        hideNumericKeyboard()
    }
    
    func getAnotherToken() -> String {
        if let asset = self.asset {
            if asset.symbol.uppercased() == "ETH" {
                return "WETH"
            } else if asset.symbol.uppercased() == "WETH" {
                return "ETH"
            }
        }
        return "WETH"
    }
    
    func getAnotherAsset() -> Asset? {
        let symbol = getAnotherToken()
        return ConvertDataManager.shared.getAsset(by: symbol)
    }
    
    @IBAction func pressedSwitchButton(_ sender: UIButton) {
        if let asset = self.asset {
            UIView.transition(with: tokenSLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.tokenSLabel.text = self.getAnotherToken() }, completion: nil)
            UIView.transition(with: tokenBLabel, duration: 0.5, options: .transitionCrossDissolve, animations: { self.tokenBLabel.text = asset.symbol }, completion: nil)
            self.asset = getAnotherAsset()
            _ = validate()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing")
        showNumericKeyboard(textField: textField)
        return true
    }

    func getActiveTextField() -> UITextField? {
        // Only one text field in the view controller.
        return amountSTextField
    }
    
    func numericKeyboard(_ numericKeyboard: NumericKeyboard, currentTextDidUpdate currentText: String) {
        let activeTextField: UITextField? = getActiveTextField()
        guard activeTextField != nil else {
            return
        }
        activeTextField!.text = currentText
        _ = validate()
    }
    
    func showNumericKeyboard(textField: UITextField) {
        if !isNumericKeyboardShow {
            let width = self.view.frame.width
            let height = self.view.frame.height
            numericKeyboardView = DefaultNumericKeyboard(frame: CGRect(x: 0, y: height, width: width, height: DefaultNumericKeyboard.height))
            numericKeyboardView.delegate = self
            scrollViewBottomLayoutConstraint.constant = DefaultNumericKeyboard.height
            view.addSubview(numericKeyboardView)
            
            let destinateY = height - DefaultNumericKeyboard.height
            
            // TODO: improve the animation.
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
                self.scrollView.setContentOffset(CGPoint.zero, animated: true)
            }, completion: { _ in
                self.isNumericKeyboardShow = true
            })
        }
    }

    func hideNumericKeyboard() {
        if isNumericKeyboardShow {
            let width = self.view.frame.width
            let height = self.view.frame.height
            let destinateY = height
            self.scrollViewBottomLayoutConstraint.constant = 0
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.numericKeyboardView.frame = CGRect(x: 0, y: destinateY, width: width, height: DefaultNumericKeyboard.height)
            }, completion: { _ in
                self.isNumericKeyboardShow = false
            })
        }
    }
    
    func validate() -> GethBigInt? {
        var result: GethBigInt? = nil
        let symbol = asset!.symbol.uppercased()
        let tipMessage = NSLocalizedString("Convert_TipInfo", comment: "")
        if let text = amountSTextField.text, let inputAmount = Double(text),
           let amount = availableLabels[symbol]?.text, let maxAmount = Double(amount) {
            if inputAmount > 0 {
                if inputAmount > maxAmount {
                    availableLabels[symbol]?.shake()
                    tipLabel.textColor = .red
                    tipLabel.text = NSLocalizedString("Please input a valid amount", comment: "")
                } else {
                    amountBTextField.text = amountSTextField.text
                    result = GethBigInt.generate(inputAmount)
                    tipLabel.text = tipMessage
                    tipLabel.textColor = UIColor.tokenestTip
                }
            } else {
                tipLabel.textColor = .red
                tipLabel.shake()
                tipLabel.text = NSLocalizedString("Please input a valid amount", comment: "")
            }
        } else {
            if amountSTextField.text == "" {
                tipLabel.text = tipMessage
                tipLabel.textColor = UIColor.tokenestTip
                amountBTextField.text = ""
            } else {
                tipLabel.textColor = .red
                tipLabel.shake()
                tipLabel.text = NSLocalizedString("Please input a valid amount", comment: "")
            }
        }
        return result
    }
    
    @IBAction func pressedConvertButton(_ sender: UIButton) {
        guard validate() != nil else {
            tipLabel.textColor = .red
            tipLabel.text = NSLocalizedString("Please input a valid amount", comment: "")
            tipLabel.shake()
            return
        }
        self.pushController()
    }
    
    func pushController() {
        self.totalMaskView.alpha = 0.75
        let vc = ConvertConfirmViewController()
        vc.convertAsset = self.asset
        vc.convertAmount = self.amountSTextField.text
        vc.dismissClosure = { self.totalMaskView.alpha = 0 }
        vc.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        vc.parentNavController = self.navigationController
        self.present(vc, animated: true, completion: nil)
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
}
