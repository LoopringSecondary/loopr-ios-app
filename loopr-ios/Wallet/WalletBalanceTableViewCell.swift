//
//  WalletBalanceTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/19/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

protocol WalletBalanceTableViewCellDelegate: class {
    func updateTableView(isHideSmallAsset: Bool)
}

class WalletBalanceTableViewCell: UITableViewCell {

    weak var delegate: WalletBalanceTableViewCellDelegate?

    var updateBalanceLabelTimer: Timer?

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var balanceLabel: TickerLabel!
    // let addressLabel: UILabel = UILabel()
    
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var buttonBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // backgroundImageView.image = UIImage.init(named: "Tokenest-settings-background-image")
        // backgroundImageView.contentMode = .bottom
        
        selectionStyle = .none
        backgroundColor = UIColor.init(rgba: "#F3F6F8")
        
        buttonBackgroundView.backgroundColor = UIColor.init(white: 1, alpha: 0.98)
        buttonBackgroundView.cornerRadius = 7.5
        buttonBackgroundView.clipsToBounds = true
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        
        balanceLabel.setFont(FontConfigManager.shared.getRegularFont(size: 32))
        balanceLabel.animationDuration = 0.3
        balanceLabel.textAlignment = NSTextAlignment.center
        balanceLabel.initializeLabel()
        balanceLabel.backgroundColor = UIColor.clear

        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText("\(balance)", animated: false)

        /*
        addressLabel.frame = CGRect.init(x: screenWidth*0.25, y: balanceLabel.frame.maxY, width: screenWidth*0.5, height: 30)
        addressLabel.font = FontConfigManager.shared.getLabelFont(size: 14)
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 1
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressLabel.text = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address ?? ""
        addSubview(addressLabel)
        */
        
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
        
        update()
    }

    private func update() {
        balanceLabel.textColor = UIColor.white
        // addressLabel.theme_textColor = GlobalPicker.textLightGreyColor
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
        layoutIfNeeded()
    }
    
    func startUpdateBalanceLabelTimer() {
        if updateBalanceLabelTimer == nil {
            updateBalanceLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateBalance), userInfo: nil, repeats: true)
        }
    }

    func stopUpdateBalanceLabelTimer() {
        if updateBalanceLabelTimer != nil {
            updateBalanceLabelTimer?.invalidate()
            updateBalanceLabelTimer = nil
        }
    }
    
    @objc func pressedReceiveButton(_ button: UIButton) {
        print("pressedItem1Button")
    }

    class func getCellIdentifier() -> String {
        return "WalletBalanceTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        let screensize: CGRect = UIScreen.main.bounds
        // let screenWidth = screensize.width
        let screenHeight = screensize.height
        return screenHeight * 0.6
    }
}
