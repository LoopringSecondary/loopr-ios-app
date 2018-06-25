//
//  AssetTableViewCell.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/1/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AssetTableViewCell: UITableViewCell {

    var asset: Asset?
    
    // TODO: We may deprecate IBOutlet
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var seperateLine: UIView!
    
    // @IBOutlet weak var forwardImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        theme_backgroundColor = GlobalPicker.backgroundColor
        symbolLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        nameLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        amountLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        balanceLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        
        seperateLine.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update() {
        if let asset = asset {
            nameLabel.text = asset.name
            symbolLabel.text = asset.symbol
            iconImageView.image = asset.icon
            balanceLabel.text = "≈\(asset.currency)"
            amountLabel.text = "\(asset.display)"
        }
    }
    
    class func getCellIdentifier() -> String {
        return "AssetTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 72*UIStyleConfig.scale
    }
}
