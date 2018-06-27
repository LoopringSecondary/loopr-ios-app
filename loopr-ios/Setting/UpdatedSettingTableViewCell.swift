//
//  UpdatedSettingTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/26/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class UpdatedSettingTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.init(white: 1, alpha: 0.98)
        nameLabel.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        nameLabel.textColor = UIColor.init(rgba: "#32384C")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    class func getCellIdentifier() -> String {
        return "UpdatedSettingTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 70
    }
}
