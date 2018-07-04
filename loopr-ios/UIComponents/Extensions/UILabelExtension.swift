//
//  UILabelExtension.swift
//  loopr-ios
//
//  Created by kenshin on 2018/6/1.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    
    func setTitleFont() {
        let font = FontConfigManager.shared.getTitleFont()
        self.theme_textColor = GlobalPicker.textColor
        self.font = font
    }
    
    func setSubTitleFont() {
        let font = FontConfigManager.shared.getSubtitleFont()
        self.theme_textColor = ["#00000099", "#fff"]
        self.font = font
    }
    
    func setHeaderFont() {
        let font = FontConfigManager.shared.getHeaderFont()
        self.theme_textColor = GlobalPicker.textColor
        self.font = font
    }
    
    func setMarket() {
        if let text = self.text {
            let range = (text as NSString).range(of: "/\\w*\\d*", options: .regularExpression)
            let attribute = NSMutableAttributedString.init(string: text)
            attribute.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.tokenestFailed], range: range)
            self.attributedText = attribute
        }
    }
    
    static func heightForOneLineStringView(font: UIFont) -> CGFloat{
        let label: UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: 200, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = LocalizedString("Default", comment: "")
        
        label.sizeToFit()
        return label.frame.height
    }
}
