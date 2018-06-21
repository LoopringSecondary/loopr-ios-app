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
    
    func highlightEffect() {
        self.nameLabel.backgroundColor = UIColor.tokenestButton
        self.nameLabel.textColor = UIColor.white
    }
    
    func removeHighlight() {
        self.nameLabel.backgroundColor = UIColor.white
        self.nameLabel.textColor = UIColor.tokenestButton
    }
    
    class func getCellIdentifier() -> String {
        return "AssetCollectionViewCell"
    }
}
