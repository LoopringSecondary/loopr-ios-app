//
//  ConvertConfirmViewController.swift
//  loopr-ios
//
//  Created by 王忱 on 2018/6/26.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit
import Geth
import SVProgressHUD

class ConvertConfirmViewController: UIViewController {

    @IBOutlet weak var convertValueLabel: UILabel!
    @IBOutlet weak var convertTipLabel: UILabel!
    @IBOutlet weak var convertButton: UIButton!
    
    var convertAsset: Asset!
    var convertAmount: String!
    var dismissClosure: (() -> Void)?
    var parentNavController: UINavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        view.theme_backgroundColor = GlobalPicker.textColor
        let message = "\(self.convertAmount!) \(self.convertAsset.symbol)"
        convertValueLabel.font = FontConfigManager.shared.getLabelENFont(size: 24)
        convertValueLabel.text = message
        convertTipLabel.text = "\(message) → \(self.convertAmount!) \(self.getAnotherToken())"
        convertButton.setupRoundPurpleWithShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAnotherToken() -> String {
        if let asset = self.convertAsset {
            if asset.symbol.uppercased() == "ETH" {
                return "WETH"
            } else if asset.symbol.uppercased() == "WETH" {
                return "ETH"
            }
        }
        return "WETH"
    }
    
    @IBAction func pressedConvertButton(_ sender: UIButton) {
        let amount = GethBigInt.generate(Double(self.convertAmount)!)!
        SVProgressHUD.show(withStatus: NSLocalizedString("正在转换", comment: "") + "...")
        if convertAsset!.symbol.uppercased() == "ETH" {
            SendCurrentAppWalletDataManager.shared._deposit(amount: amount, completion: completion)
        } else if convertAsset!.symbol.uppercased() == "WETH" {
            SendCurrentAppWalletDataManager.shared._withDraw(amount: amount, completion: completion)
        }
    }
    
    @IBAction func pressedCloseButton(_ sender: UIButton) {
        if let closure = self.dismissClosure {
            closure()
        }
        self.dismiss(animated: true, completion: {
        })
    }
}

extension ConvertConfirmViewController {
    func completion(_ txHash: String?, _ error: Error?) {
        SVProgressHUD.dismiss()
        DispatchQueue.main.async {
            let vc = SendResultViewController()
            vc.type = "转换"
            vc.asset = self.convertAsset
            vc.navigationItem.title = "转换\(self.convertAsset.symbol)"
            if let error = error as NSError?, let message = error.userInfo["message"] as? String {
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
