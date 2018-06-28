//
//  AssetCollectionViewCell.swift
//  loopr-ios
//
//  Created by kenshin on 2018/4/29.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

class AssetCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var asset: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.font = FontConfigManager.shared.getSubtitleFont()
    }
    
    func update() {
        if let asset = self.asset {
            nameLabel.cornerRadius = 16
            nameLabel.borderWidth = 0.5
            nameLabel.borderColor = UIColor.tokenestBackground
            nameLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
            nameLabel.text = asset
            if isHighlighted {
                nameLabel.backgroundColor = UIColor.tokenestBackground
                nameLabel.textColor = UIColor.white
            } else {
                nameLabel.backgroundColor = UIColor.white
                nameLabel.textColor = UIColor.tokenestBackground
            }
        }
    }
    
    class func getCellIdentifier() -> String {
        return "AssetCollectionViewCell"
    }
}
