//
//  UIColorExtensions.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/11/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {

    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    func convert(to color: UIColor, multiplier _multiplier: CGFloat) -> UIColor? {
        let multiplier = min(max(_multiplier, 0), 1)
        let components = cgColor.components ?? []
        let toComponents = color.cgColor.components ?? []
        if components.isEmpty || components.count < 3 || toComponents.isEmpty || toComponents.count < 3 {
            return nil
        }
        var results: [CGFloat] = []
        for index in 0...3 {
            let result = (toComponents[index] - components[index]) * abs(multiplier) + components[index]
            results.append(result)
        }
        return UIColor(red: results[0], green: results[1], blue: results[2], alpha: results[3])
    }
    
    class var subtitle: UIColor {
        return UIColor(named: "Subtitle")!
    }
    
    class var seperator: UIColor {
        return UIColor(named: "Seperator")!
    }
    
    class var buttonBackground: UIColor {
        return UIColor(named: "ButtonBackground")!
    }
    
    class var tokenestBackground: UIColor {
        return UIColor(named: "Tokenest-background")!
    }
    
    class var tokenestBlankBackground: UIColor {
        return UIColor.init(rgba: "#F3F6F8")
    }
    
    class var tokenestBorder: UIColor {
        return UIColor.init(rgba: "#E8E8E8")
    }
    
    class var tokenestButton: UIColor {
        return UIColor.init(rgba: "#2E2BA4")
    }
    
    class var tokenestTip: UIColor {
        return UIColor.init(rgba: "#878FA4")
    }
}
