//
//  WalletBalanceTableViewCellViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/19/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class WalletBalanceTableViewCellViewController: UIViewController {
    
    var updateBalanceLabelTimer: Timer?
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var balanceLabel: TickerLabel!
    // let addressLabel: UILabel = UILabel()
    
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(rgba: "#F3F6F8")

        balanceLabel.setFont(FontConfigManager.shared.getRegularFont(size: 32))
        balanceLabel.animationDuration = 0.3
        balanceLabel.textAlignment = NSTextAlignment.center
        balanceLabel.initializeLabel()
        balanceLabel.backgroundColor = UIColor.clear
        balanceLabel.textColor = UIColor.white
        
        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText("\(balance)", animated: false)
        
        buttonBackgroundView.backgroundColor = UIColor.init(white: 1, alpha: 0.98)
        buttonBackgroundView.cornerRadius = 7.5
        buttonBackgroundView.clipsToBounds = true
        
        let iconTitlePadding: CGFloat = 14
        
        receiveButton.backgroundColor = UIColor.clear
        receiveButton.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        receiveButton.set(image: UIImage.init(named: "Tokenest-asset-receive"), title: NSLocalizedString("Receive", comment: ""), titlePosition: .right, additionalSpacing: iconTitlePadding, state: .normal)
        receiveButton.set(image: UIImage.init(named: "Tokenest-asset-receive")?.alpha(0.6), title: NSLocalizedString("Receive", comment: ""), titlePosition: .right, additionalSpacing: iconTitlePadding, state: .highlighted)
        receiveButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        receiveButton.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        receiveButton.addTarget(self, action: #selector(self.pressedReceiveButton(_:)), for: .touchUpInside)
        
        sendButton.backgroundColor = UIColor.clear
        sendButton.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        sendButton.set(image: UIImage.init(named: "Tokenest-asset-send"), title: NSLocalizedString("Send", comment: ""), titlePosition: .right, additionalSpacing: iconTitlePadding, state: .normal)
        sendButton.set(image: UIImage.init(named: "Tokenest-asset-send")?.alpha(0.6), title: NSLocalizedString("Send", comment: ""), titlePosition: .left, additionalSpacing: iconTitlePadding, state: .highlighted)
        sendButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        sendButton.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        sendButton.addTarget(self, action: #selector(self.pressedReceiveButton(_:)), for: .touchUpInside)
        
        if updateBalanceLabelTimer == nil {
            updateBalanceLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateBalance), userInfo: nil, repeats: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    @objc func pressedReceiveButton(_ button: UIButton) {
        print("pressedItem1Button")
    }
    
    func setup() {
        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText(balance, animated: true)
        balanceLabel.layoutCharacterLabels()
    }
    
    @objc func updateBalance() {
        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText(balance, animated: true)
    }

}
