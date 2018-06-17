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

    let balanceLabel: TickerLabel = TickerLabel()
    let addressLabel: UILabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        self.theme_backgroundColor = GlobalPicker.navigationBarTintColor
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        
        balanceLabel.frame = CGRect.init(x: 10, y: 42, width: screenWidth - 10*2, height: 36)
        balanceLabel.setFont(FontConfigManager.shared.getRegularFont(size: 32))
        balanceLabel.animationDuration = 0.3
        balanceLabel.textAlignment = NSTextAlignment.center
        balanceLabel.initializeLabel()
        balanceLabel.theme_backgroundColor = GlobalPicker.navigationBarTintColor

        var balance = CurrentAppWalletDataManager.shared.getTotalAssetCurrencyFormmat()
        balance.insert(" ", at: balance.index(after: balance.startIndex))
        balanceLabel.setText("\(balance)", animated: false)
        addSubview(balanceLabel)

        addressLabel.frame = CGRect.init(x: screenWidth*0.25, y: balanceLabel.frame.maxY, width: screenWidth*0.5, height: 30)
        addressLabel.font = FontConfigManager.shared.getLabelFont(size: 14)
        addressLabel.textAlignment = .center
        addressLabel.numberOfLines = 1
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressLabel.text = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address ?? ""
        addSubview(addressLabel)
        
        if updateBalanceLabelTimer == nil {
            updateBalanceLabelTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.updateBalance), userInfo: nil, repeats: true)
        }
        
        update()
    }

    private func update() {
        balanceLabel.textColor = UIColor.white
        addressLabel.theme_textColor = GlobalPicker.textLightGreyColor
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

    class func getCellIdentifier() -> String {
        return "WalletBalanceTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 150
    }
}
