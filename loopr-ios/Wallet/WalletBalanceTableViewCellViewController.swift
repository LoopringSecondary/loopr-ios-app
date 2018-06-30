//
//  WalletBalanceTableViewCellViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/19/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

protocol WalletBalanceDelegate: class {
    func pressedReceiveButton()
    func pressedSendButton()
    func pressedAddTokenButton()
}

class WalletBalanceTableViewCellViewController: UIViewController {
    
    weak var delegate: WalletBalanceDelegate?
    
    var updateBalanceLabelTimer: Timer?
    
    @IBOutlet weak var balanceLabel: TickerLabel!
    // let addressLabel: UILabel = UILabel()
    
    @IBOutlet weak var addTokenButton: UIButton!
    
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var buttonBackgroundImageView: UIImageView!
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(rgba: "#F3F6F8")

        balanceLabel.setFont(FontConfigManager.shared.getRegularFont(size: 36))
        balanceLabel.animationDuration = 0.3
        balanceLabel.textAlignment = NSTextAlignment.center
        balanceLabel.initializeLabel()
        balanceLabel.backgroundColor = UIColor.clear
        balanceLabel.textColor = UIColor.white
        
        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText("\(balance)", animated: false)
        
        addTokenButton.setImage(UIImage.init(named: "Tokenest-asset-add-token")?.alpha(0.7), for: .highlighted)
        addTokenButton.addTarget(self, action: #selector(self.pressedAddTokenButton(_:)), for: .touchUpInside)

        buttonBackgroundImageView.cornerRadius = 7.5
        buttonBackgroundImageView.clipsToBounds = true
        
        buttonBackgroundView.backgroundColor = UIColor.init(white: 1, alpha: 0.98)
        buttonBackgroundView.isOpaque = true
        buttonBackgroundView.cornerRadius = 7.5
        buttonBackgroundView.clipsToBounds = true
        
        let iconTitlePadding: CGFloat = 14
        
        receiveButton.backgroundColor = UIColor.clear
        receiveButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14.0, type: "Medium")
        receiveButton.set(image: UIImage.init(named: "Tokenest-asset-receive"), title: LocalizedString("Receive", comment: ""), titlePosition: .right, additionalSpacing: iconTitlePadding, state: .normal)
        receiveButton.set(image: UIImage.init(named: "Tokenest-asset-receive")?.alpha(0.6), title: LocalizedString("Receive", comment: ""), titlePosition: .right, additionalSpacing: iconTitlePadding, state: .highlighted)
        receiveButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        receiveButton.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        receiveButton.addTarget(self, action: #selector(self.pressedReceiveButton(_:)), for: .touchUpInside)
        
        sendButton.backgroundColor = UIColor.clear
        sendButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14.0, type: "Medium")
        sendButton.set(image: UIImage.init(named: "Tokenest-asset-send"), title: LocalizedString("Send", comment: ""), titlePosition: .right, additionalSpacing: iconTitlePadding, state: .normal)
        sendButton.set(image: UIImage.init(named: "Tokenest-asset-send")?.alpha(0.6), title: LocalizedString("Send", comment: ""), titlePosition: .left, additionalSpacing: iconTitlePadding, state: .highlighted)
        sendButton.setTitleColor(UIColor.init(rgba: "#4A5668"), for: .normal)
        sendButton.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        sendButton.addTarget(self, action: #selector(self.pressedSendButton(_:)), for: .touchUpInside)
        
        if updateBalanceLabelTimer == nil {
            updateBalanceLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateBalance), userInfo: nil, repeats: true)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(currentAppWalletSwitchedReceivedNotification), name: .currentAppWalletSwitched, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
        
        let shadowSize: CGFloat = 0.5
        let shadowPath = UIBezierPath(rect: CGRect(x: -shadowSize / 2, y: -shadowSize / 2, width: self.buttonBackgroundView.frame.size.width + shadowSize, height: self.buttonBackgroundView.frame.size.height + shadowSize))
        self.buttonBackgroundView.layer.masksToBounds = false
        self.buttonBackgroundView.layer.shadowColor = UIColor.init(rgba: "#878FA4").cgColor
        self.buttonBackgroundView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.buttonBackgroundView.layer.shadowOpacity = 0.2
        self.buttonBackgroundView.layer.shadowRadius = 7.5
        self.buttonBackgroundView.layer.shadowPath = shadowPath.cgPath
    }
    
    @objc func pressedReceiveButton(_ button: UIButton) {
        print("pressedItem1Button")
        delegate?.pressedReceiveButton()
    }

    @objc func pressedSendButton(_ button: UIButton) {
        print("pressedSendButton")
        delegate?.pressedSendButton()
    }
    
    @objc func pressedAddTokenButton(_ button: UIButton) {
        print("pressedAddTokenButton")
        delegate?.pressedAddTokenButton()
    }
    
    func setup() {
        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText(balance, animated: true)
        balanceLabel.layoutCharacterLabels()
    }
    
    @objc func updateBalance() {
        print("updateBalance")
        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText(balance, animated: true)
        balanceLabel.setNeedsLayout()
        balanceLabel.layoutIfNeeded()
    }

    // This doesn't work very well.
    @objc func currentAppWalletSwitchedReceivedNotification() {
        // var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        // balance.insert(" ", at: balance.index(after: balance.startIndex))
        // balanceLabel.setText(balance, animated: true)
        // balanceLabel.layoutCharacterLabels()
    }
}
