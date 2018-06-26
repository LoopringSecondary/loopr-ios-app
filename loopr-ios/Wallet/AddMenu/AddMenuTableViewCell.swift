//
//  AddMenuTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 4/2/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AddMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seperateLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = UIColor.white
        titleLabel.textColor = UIColor.init(rgba: "#878FA4")
        titleLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        seperateLabel.backgroundColor = UIColor.tokenestBorder
    }

    class func getCellIdentifier() -> String {
        return "AddMenuTableViewCell"
    }
}
