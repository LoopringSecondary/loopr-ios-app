//
//  UIButton+RoundBlackButton.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/26/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

extension UIButton {
    
    func setupRoundBlack(height: CGFloat = 47*UIStyleConfig.scale) {
        backgroundColor = UIColor.black
        setBackgroundColor(UIColor.black, for: .normal)
        // TODO: update the color in the highlighted state.
        setBackgroundColor(UIColor.init(white: 0.15, alpha: 1), for: .highlighted)
        clipsToBounds = true
        setTitleColor(.gray, for: .disabled)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.init(white: 0.5, alpha: 1), for: .highlighted)
        titleLabel?.font = UIFont(name: FontConfigManager.shared.getBold(), size: 16.0*UIStyleConfig.scale)
        layer.cornerRadius = height * 0.5
    }
    
    func setupRoundWhite(height: CGFloat = 47*UIStyleConfig.scale) {
        setTitleColor(.gray, for: .disabled)
        setTitleColor(.black, for: .normal)
        setBackgroundColor(UIColor.white, for: .normal)
        setBackgroundColor(UIColor.init(white: 0.85, alpha: 1), for: .highlighted)
        clipsToBounds = true
        titleLabel?.font = UIFont(name: FontConfigManager.shared.getBold(), size: 16.0*UIStyleConfig.scale)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        layer.cornerRadius = height * 0.5
    }
    
    func setupRoundPurpleOutline(height: CGFloat = 47*UIStyleConfig.scale, font: UIFont? = UIFont(name: FontConfigManager.shared.getBold(), size: 16.0*UIStyleConfig.scale)) {
        setTitleColor(UIColor.tokenestBackground, for: .normal)
        setTitleColor(UIColor.tokenestBackground.withAlphaComponent(0.8), for: .highlighted)
        setBackgroundColor(UIColor.white, for: .normal)
        // TODO: design this color.
        setBackgroundColor(UIColor.white, for: .highlighted)
        clipsToBounds = true
        titleLabel?.font = font
        layer.borderWidth = 1
        layer.borderColor = UIColor.tokenestBackground.cgColor
        layer.cornerRadius = height * 0.5
    }
    
    func setupRoundPurple(height: CGFloat = 47*UIStyleConfig.scale, font: UIFont? = UIFont(name: FontConfigManager.shared.getBold(), size: 16.0*UIStyleConfig.scale)) {
        backgroundColor = UIColor.black
        setBackgroundColor(UIColor.tokenestBackground, for: .normal)
        // TODO: update the color in the highlighted state.
        setBackgroundColor(UIColor.tokenestBackground.withAlphaComponent(0.8), for: .highlighted)
        clipsToBounds = true
        setTitleColor(.gray, for: .disabled)
        setTitleColor(UIColor.white, for: .normal)
        setTitleColor(UIColor.init(white: 0.5, alpha: 1), for: .highlighted)
        titleLabel?.font = font
        layer.cornerRadius = height * 0.5
    }

    func setupRoundPurpleWithShadow(height: CGFloat = 47*UIStyleConfig.scale) {
        setupRoundPurple(height: height)
        let shadowLayer = UIView(frame: self.frame)
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.shadowColor = UIColor.tokenestBackground.cgColor
        shadowLayer.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        shadowLayer.layer.shadowOffset = CGSize(width: 4, height: 4)
        shadowLayer.layer.shadowOpacity = 0.3
        shadowLayer.layer.shadowRadius = 4
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        self.superview?.addSubview(shadowLayer)
        self.superview?.bringSubview(toFront: self)
    }
}
