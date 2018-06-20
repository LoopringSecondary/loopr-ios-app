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
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 2
        nameLabel.backgroundColor = UIColor.init(rgba: "#F0F1F5")
        nameLabel.textColor = UIColor.init(rgba: "#878FA4")
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
