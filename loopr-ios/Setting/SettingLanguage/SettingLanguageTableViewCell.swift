//
//  SettingLanguageTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/2/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class SettingLanguageTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        leftLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        leftLabel.textColor = UIColor.init(rgba: "#878FA4")
    }

    class func getCellIdentifier() -> String {
        return "SettingLanguageTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 49
    }
}
