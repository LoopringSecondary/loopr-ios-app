//
//  AssetTransactionDetailViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AssetTransactionDetailViewController: UIViewController {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var transactionIDButton: UIButton!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var gasLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var transaction: Transaction?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.customizedNavigationBar.shadowImage = UIImage()
        self.statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let transaction = self.transaction {
            setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: "\(transaction.symbol)")
            setupLabels(transaction: transaction)
        }
    }
    
    func setupLabels(transaction: Transaction) {
        typeLabel.text = transaction.type.description
        statusLabel.text = transaction.status.description
        amountLabel.text = "\(transaction.value) \(transaction.symbol)"
        transactionIDButton.title = transaction.txHash
        receiveButton.title = transaction.to
        let gas = GasDataManager.shared.getGasAmountInETH(by: "transfer")
        gasLabel.text = "\(gas) ETH"
        dateLabel.text = transaction.createTime
        if transaction.status == .success {
            statusLabel.textColor = UIColor.tokenestDowns
        } else if transaction.status == .failed {
            statusLabel.textColor = UIColor.tokenestUps
        } else if transaction.status == .pending {
            statusLabel.textColor = UIColor.tokenestPending
        }
    }
    
    @IBAction func pressedHashButton(_ sender: UIButton) {
        var etherUrl = "https://etherscan.io/tx/"
        if let tx = self.transaction {
            etherUrl += tx.txHash
            if let url = URL(string: etherUrl) {
                let viewController = DefaultWebViewController()
                viewController.navigationTitle = "Etherscan.io"
                viewController.url = url
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    @IBAction func pressedReceiverButton(_ sender: UIButton) {
        var etherUrl = "https://etherscan.io/address/"
        if let tx = self.transaction {
            if tx.type == .sent {
                etherUrl += tx.to
            } else if tx.type == .received {
                etherUrl += tx.from
            }
            if let url = URL(string: etherUrl) {
                let viewController = DefaultWebViewController()
                viewController.url = url
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
