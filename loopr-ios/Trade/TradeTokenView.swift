//
//  TradeTokenView.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/15/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class TradeTokenView: UIView {
    
    var iconImageWidth: CGFloat = 54
    
    var titleLabel: UILabel
    var iconImageView: UIImageView
    var iconView: IconView
    var amountLabel: UILabel
    var totalPriceInFiatCurrency: UILabel
    
    override init(frame: CGRect) {
        let padding: CGFloat = 10*UIStyleConfig.scale

        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: 40*UIStyleConfig.scale))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.tokenestTip
        titleLabel.font = FontConfigManager.shared.getLabelSCFont(size: 16)

        iconImageView = UIImageView(frame: CGRect(x: 0, y: titleLabel.frame.maxY + padding, width: frame.width, height: iconImageWidth*UIStyleConfig.scale))
        iconImageView.contentMode = .scaleAspectFit

        iconView = IconView(frame: CGRect(x: 0, y: titleLabel.frame.maxY + padding, width: frame.width, height: iconImageWidth*UIStyleConfig.scale))
        iconView.isHidden = true
        iconView.backgroundColor = UIColor.clear

        amountLabel = UILabel(frame: CGRect(x: 0, y: iconImageView.frame.maxY + padding, width: frame.width, height: 40*UIStyleConfig.scale))
        amountLabel.textAlignment = .center
        amountLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        amountLabel.textColor = UIColor.tokenestTableFont
        
        totalPriceInFiatCurrency = UILabel(frame: CGRect(x: 0, y: amountLabel.frame.maxY - 15*UIStyleConfig.scale, width: frame.width, height: 40*UIStyleConfig.scale))
        totalPriceInFiatCurrency.textAlignment = .center
        totalPriceInFiatCurrency.font = FontConfigManager.shared.getLabelENFont(size: 16)
        totalPriceInFiatCurrency.textColor = UIColor.tokenestTip

        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(iconImageView)
        addSubview(iconView)
        addSubview(amountLabel)
        addSubview(totalPriceInFiatCurrency)
    }

    // Used in ConvertETHViewController
    func update(symbol: String) {
        amountLabel.text = symbol
        let icon = UIImage(named: symbol)
        if icon != nil {
            iconImageView.image = icon
            iconImageView.isHidden = false
            iconView.isHidden = true
        } else {
            iconView.isHidden = false
            iconView.symbol = symbol
            iconView.symbolLabel.text = symbol
            iconImageView.isHidden = true
        }
        totalPriceInFiatCurrency.isHidden = true
    }

    // Used in Trade
    func update(title: String, symbol: String, amount: Double) {
        titleLabel.text = title
        amountLabel.text = "\(amount.withCommas(6)) \(symbol)"
        amountLabel.font = UIFont.init(name: FontConfigManager.shared.getMedium(), size: 17*UIStyleConfig.scale)
        
        totalPriceInFiatCurrency.isHidden = false
        if let price = PriceDataManager.shared.getPrice(of: symbol) {
            let value: Double = price * amount
            totalPriceInFiatCurrency.text = value.currency
        } else {
            totalPriceInFiatCurrency.text = 0.0.currency
        }

        let icon = UIImage(named: symbol)
        if icon != nil {
            iconImageView.image = icon
            iconImageView.isHidden = false
            iconView.isHidden = true
        } else {
            iconView.isHidden = false
            iconView.symbol = symbol
            iconView.symbolLabel.text = symbol
            iconImageView.isHidden = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
