//
//  WalletClearTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/19/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class WalletClearTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = UIColor.clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func getCellIdentifier() -> String {
        return "WalletClearTableViewCell"
    }
}
