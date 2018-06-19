//
//  GlobalPicker.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/24/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import SwiftTheme

enum GlobalPicker {
    // Default values
    static let backgroundColor: ThemeColorPicker = ["#fff", "#000"]
    static let textColor: ThemeColorPicker = ["#000", "#fff"]
    static let textLightGreyColor: ThemeColorPicker = ["#aaa", "#aaa"]  // ["#00000099", "#fff"]

    // TODO: Update purple color
    static let themeColor = UIColor.tokenestBackground
    
    // Navigation bar
    static let navigationBarTextColors = ["#fff", "#fff"]  // used in navigation map
    static let navigationBarTextColor = ThemeColorPicker.pickerWithColors(navigationBarTextColors)
    static let navigationBarTintColor: ThemeColorPicker = ["#3B51C8", "#3B51C8"]
    
    // Tabvbar
    static let barTextColor: ThemeColorPicker = ["#3B51C8", "#fff"]
    static let barTintColor: ThemeColorPicker = ["#fff", "#000"]
    
    static let tableViewBackgroundColor: ThemeColorPicker = ["#f5f5f5", "#121212"]
}
