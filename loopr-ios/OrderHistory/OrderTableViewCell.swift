//
//  OrderTableViewCell.swift
//  loopr-ios
//
//  Created by kenshin on 2018/4/2.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    var order: Order?
    let asset = CurrentAppWalletDataManager.shared
    let market = MarketDataManager.shared
    
    @IBOutlet weak var filledPieChart: CircleChart!
    @IBOutlet weak var tradingPairLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var displayLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var seperateLine: UIView!
    
    var pressedCancelButtonClosure: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func update() {
        guard let order = self.order else { return }
        setupTradingPairlabel(order: order)
        setupVolumeLabel(order: order)
        setupPriceLabel(order: order)
        setupOrderTypeLabel(order: order)
        setupOrderFilled(order: order)
        setupCancelButton(order: order)
        seperateLine.backgroundColor = UIColor.init(white: 0, alpha: 0.1)
    }
    
    func setupCancelButton(order: Order) {
        let (flag, text) = getOrderStatus(order: order)
        if flag {
            cancelButton.isEnabled = true
            cancelButton.backgroundColor = UIColor.tokenestBackground
            cancelButton.layer.borderColor = UIColor.clear.cgColor
        } else {
            cancelButton.isEnabled = false
            cancelButton.backgroundColor = UIColor.tokenestPending
            cancelButton.layer.borderColor = UIColor.clear.cgColor
        }
        cancelButton.title = text
        cancelButton.titleColor = UIColor.white
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.cornerRadius = 16
        cancelButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 12)
    }
    
    func getOrderStatus(order: Order) -> (Bool, String) {
        if order.orderStatus == .opened {
            let cancelledAll = UserDefaults.standard.bool(forKey: UserDefaultsKeys.cancelledAll.rawValue)
            if cancelledAll || isOrderCancelling(order: order) {
                return (false, LocalizedString("Cancelling", comment: ""))
            } else {
                return (true, LocalizedString("Cancel", comment: ""))
            }
        } else {
            return (false, order.orderStatus.description)
        }
    }
    
    func isOrderCancelling(order: Order) -> Bool {
        let cancellingOrders = UserDefaults.standard.stringArray(forKey: UserDefaultsKeys.cancellingOrders.rawValue) ?? []
        return cancellingOrders.contains(order.originalOrder.hash)
    }
    
    func setupTradingPairlabel(order: Order) {
        tradingPairLabel.text = order.tradingPairDescription
        tradingPairLabel.textColor = UIColor.tokenestTableFont
        tradingPairLabel.font = FontConfigManager.shared.getTitleFont()
        tradingPairLabel.setMarket()
    }
    
    func setupVolumeLabel(order: Order) {
        if order.originalOrder.side.lowercased() == "sell" {
            volumeLabel.text = "成交量 " + order.dealtAmountS.description
        } else if order.originalOrder.side.lowercased() == "buy" {
            volumeLabel.text = "成交量 " + order.dealtAmountB.description
        }
        volumeLabel.textColor = UIColor.tokenestTip
        volumeLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
    }
    
    func setupPriceLabel(order: Order) {
        var limit: Double = 0
        let pair = order.originalOrder.market.components(separatedBy: "-")
        if let price = PriceDataManager.shared.getPrice(of: pair[1]) {
            if order.originalOrder.side.lowercased() == "sell" {
                limit = order.originalOrder.amountBuy / order.originalOrder.amountSell
            } else if order.originalOrder.side.lowercased() == "buy" {
                limit = order.originalOrder.amountSell / order.originalOrder.amountBuy
            }
            priceLabel.text = limit.withCommas(6)
            displayLabel.text = (limit * price).currency
        } else {
            displayLabel.text = "--"
        }
        priceLabel.textColor = UIColor.tokenestTableFont
        priceLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        displayLabel.textColor = UIColor.tokenestTip
        displayLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
    }
    
    func setupOrderTypeLabel(order: Order) {
        orderTypeLabel.font = FontConfigManager.shared.getLabelSCFont(size: 12)
        orderTypeLabel.borderWidth = 1
        if order.originalOrder.side == "buy" {
            orderTypeLabel.text = "买单"
            orderTypeLabel.backgroundColor = UIColor.tokenestTableFont
            orderTypeLabel.textColor = UIColor.white
        } else if order.originalOrder.side == "sell" {
            orderTypeLabel.text = "卖单"
            orderTypeLabel.backgroundColor = UIColor.white
            orderTypeLabel.textColor = UIColor.tokenestTableFont
            orderTypeLabel.borderColor = UIColor.tokenestTableFont
        }
        orderTypeLabel.layer.cornerRadius = 2.0
        orderTypeLabel.layer.masksToBounds = true
    }
    
    func setupOrderFilled(order: Order) {
        var percent: Double = 0.0
        if order.originalOrder.side.lowercased() == "sell" {
            percent = order.dealtAmountS / order.originalOrder.amountSell
        } else if order.originalOrder.side.lowercased() == "buy" {
            percent = order.dealtAmountB / order.originalOrder.amountBuy
        }
        filledPieChart.theme_backgroundColor = GlobalPicker.backgroundColor
        filledPieChart.strokeColor = UIColor.tokenestPending.cgColor
        filledPieChart.textColor = UIColor.tokenestTip
        filledPieChart.textFont = FontConfigManager.shared.getLabelENFont(size: 10)
        filledPieChart.desiredLineWidth = 2
        filledPieChart.percentage = CGFloat(percent)
        filledPieChart.update()
    }

    @IBAction func pressedCancelButton(_ sender: Any) {
        if let btnAction = self.pressedCancelButtonClosure {
            btnAction()
        }
    }
    
    class func getCellIdentifier() -> String {
        return "OrderTableViewCell"
    }
    
    class func getHeight() -> CGFloat {
        return 80
    }
}
