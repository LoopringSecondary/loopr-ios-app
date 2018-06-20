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
            nameLabel.text = asset
        }
    }
    
    class func getCellIdentifier() -> String {
        return "AssetCollectionViewCell"
    }
}
