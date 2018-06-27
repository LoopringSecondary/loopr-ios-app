//
//  SendConfirmViewController.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/24.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit
import Geth
import SVProgressHUD

class SendConfirmViewController: UIViewController {

    @IBOutlet weak var sendValueLabel: UILabel!
    @IBOutlet weak var sendTipLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var gasPriceLabel: UILabel!
    @IBOutlet weak var sendButton: UIButton!
    
    var sendAsset: Asset!
    var sendAmount: String!
    var receiveAddress: String!
    var gasAmountInETH: String!
    var dismissClosure: (() -> Void)?
    var parentNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        view.theme_backgroundColor = GlobalPicker.textColor
        let message = "\(self.sendAmount!) \(self.sendAsset.symbol)"
        sendValueLabel.font = FontConfigManager.shared.getLabelENFont(size: 24)
        sendValueLabel.text = message
        if let amountInCurrency = PriceDataManager.shared.getPrice(of: self.sendAsset.symbol, by: Double(self.sendAmount)!) {
            sendTipLabel.text = "\(message) ≈ \(amountInCurrency)"
        }
        gasPriceLabel.text = gasAmountInETH
        senderLabel.text = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address
        receiverLabel.text = self.receiveAddress!
        sendButton.setupRoundPurpleWithShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedCloseButton(_ sender: UIButton) {
        if let closure = self.dismissClosure {
            closure()
        }
        self.dismiss(animated: true, completion: {
        })
    }
    
    @IBAction func pressedSendButton(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: "Processing the transaction ...")
        if let toAddress = self.receiveAddress,
            let token = TokenDataManager.shared.getTokenBySymbol(self.sendAsset.symbol)
             {
            var error: NSError? = nil
            let toAddress = GethNewAddressFromHex(toAddress, &error)!
            if token.symbol.uppercased() == "ETH" {
                let amount = Double(self.sendAmount)! - 0.001
                let gethAmount = GethBigInt.generate(valueInEther: amount, symbol: token.symbol)!
                SendCurrentAppWalletDataManager.shared._transferETH(amount: gethAmount, toAddress: toAddress, completion: completion)
            } else {
                let amount = Double(self.sendAmount)!
                let gethAmount = GethBigInt.generate(valueInEther: amount, symbol: token.symbol)!
                let contractAddress = GethNewAddressFromHex(token.protocol_value, &error)!
                SendCurrentAppWalletDataManager.shared._transferToken(contractAddress: contractAddress, toAddress: toAddress, tokenAmount: gethAmount, completion: completion)
            }
        }
    }
}

extension SendConfirmViewController {
    
    func completion(_ txHash: String?, _ error: Error?) {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            let vc = SendResultViewController()
            vc.type = "发送代币"
            vc.asset = self.sendAsset
            vc.navigationItem.title = "转账"
            if let error = error as NSError?,
                let json = error.userInfo["message"] as? JSON,
                let message = json.string {
                vc.errorMessage = message
            }
            if let closure = self.dismissClosure {
                closure()
            }
            self.dismiss(animated: true, completion: nil)
            self.parentNavController?.pushViewController(vc, animated: true)
        }
    }
}
