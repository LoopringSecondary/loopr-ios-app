//
//  TradeFAQTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/29/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class TradeFAQTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var seperateLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        seperateLine.backgroundColor = UIColor.init(rgba: "#E5E7ED")
    }

    class func getCellIdentifier() -> String {
        return "TradeFAQTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 108
    }
}
