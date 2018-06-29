//
//  WalletAssetEmptyDataTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/29/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class WalletAssetEmptyDataTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func getCellIdentifier() -> String {
        return "WalletAssetEmptyDataTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 306
    }

}
