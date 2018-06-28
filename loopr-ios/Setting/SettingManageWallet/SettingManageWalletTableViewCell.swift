//
//  SettingManageWalletTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/6/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingManageWalletTableViewCell: UITableViewCell {

    var wallet: AppWallet?
    
    @IBOutlet weak var baseView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var toatalBalanceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.init(rgba: "#F3F6F8")
        selectionStyle = .none
        
        baseView.backgroundColor = UIColor.white
        baseView.cornerRadius = 7.5
        nameLabel.font = FontConfigManager.shared.getLabelENFont(size: 21)
        addressLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        addressLabel.textColor = UIColor.init(rgba: "#878FA4")
        addressLabel.backgroundColor = UIColor.init(rgba: "#F4F6F8")
        addressLabel.cornerRadius = 9.0
        toatalBalanceLabel.font = FontConfigManager.shared.getLabelENFont(size: 20)
        toatalBalanceLabel.textColor = UIColor.init(rgba: "#3658ED")
    }

    func update() {
        if let wallet = wallet {
            nameLabel.text = wallet.name
            addressLabel.text = wallet.address.getAddressFormat()
            toatalBalanceLabel.text = wallet.totalCurrency.currency
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        print("hightlighted: \(highlighted)")
        if highlighted {
            print("change color")
            baseView.backgroundColor = UIStyleConfig.tableCellSelectedBackgroundColor
        } else {
            print("reset color")
            baseView.backgroundColor = UIColor.white
        }
    }
    
    class func getCellIdentifier() -> String {
        return "SelectWalletTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 118
    }
}
