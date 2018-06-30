//
//  SettingCurrencyTableViewCell.swift
//  loopr-ios
//
//  Created by kenshin on 2018/4/22.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

class SettingCurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var currencyImageView: UIImageView!
    @IBOutlet weak var currencyDisplayLabel: UILabel!
    
    var currency: Currency?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        theme_backgroundColor = GlobalPicker.backgroundColor
        tintColor = GlobalPicker.themeColor
        currencyDisplayLabel.textColor = UIColor.init(rgba: "#878FA4")
        currencyDisplayLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
    }

    class func getCellIdentifier() -> String {
        return "SettingCurrnecyTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 80
    }
    
    func update() {
        if let currency = self.currency {
            currencyImageView.image = currency.icon
            currencyDisplayLabel.text = currency.name
        }
    }
}
