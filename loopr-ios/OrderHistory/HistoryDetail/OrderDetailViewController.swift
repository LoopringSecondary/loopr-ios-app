//
//  OrderDetailViewController.swift
//  loopr-ios
//
//  Created by kenshin on 2018/4/12.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var order: Order?
    
    var marketLabel: UILabel = UILabel()
    var typeLabel: UILabel = UILabel()
    var filledPieChart: CircleChart = CircleChart()
    var qrcodeImageView: UIImageView!
    var qrcodeImage: UIImage!
    var amountLabel: UILabel = UILabel()
    var displayLabel: UILabel = UILabel()
    
    // Amount
    var amountTipLabel: UILabel = UILabel()
    var amountInfoLabel: UILabel = UILabel()
    var amountUnderline: UIView = UIView()
    // Status
    var statusTipLabel: UILabel = UILabel()
    var statusInfoLabel: UILabel = UILabel()
    var statusUnderline: UIView = UIView()
    // Total
    var totalTipLabel: UILabel = UILabel()
    var totalInfoLabel: UILabel = UILabel()
    // Trade
    var tradeTipLabel: PaddingLabel = PaddingLabel()
    // Filled
    var filledTipLabel: UILabel = UILabel()
    var filledInfoLabel: UILabel = UILabel()
    var filledUnderline: UIView = UIView()
    // ID
    var idTipLabel: UILabel = UILabel()
    var idInfoLabel: UILabel = UILabel()
    var idUnderline: UIView = UIView()
    // Date
    var dateTipLabel: UILabel = UILabel()
    var dateInfoLabel: UILabel = UILabel()
    var dateUnderline: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statusBar.backgroundColor = GlobalPicker.themeColor
        self.setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: "订单详情")
        setupQRCodeButton()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupQRCodeButton() {
        guard order?.originalOrder.orderType == .p2pOrder && order?.orderStatus == .opened else {
            return
        }
        let qrCodebutton = UIButton(type: UIButtonType.custom)
        // TODO: smaller images.
        qrCodebutton.theme_setImage(["QRCode-black", "QRCode-white"], forState: UIControlState.normal)
        qrCodebutton.setImage(UIImage(named: "QRCode-black")?.alpha(0.3), for: .highlighted)
        qrCodebutton.addTarget(self, action: #selector(self.pressQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrCodebutton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let qrCodeBarButton = UIBarButtonItem(customView: qrCodebutton)
        self.navigationItem.rightBarButtonItem = qrCodeBarButton
    }
    
    @objc func pressQRCodeButton(_ sender: UIButton) {
        if let order = self.order {
            let viewController = OrderQRCodeViewController()
            viewController.order = order.originalOrder
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func setupOrderType(order: Order) {
        if order.originalOrder.side == "buy" {
            typeLabel.backgroundColor = UIColor.tokenestTableFont
            typeLabel.textColor = UIColor.white
            typeLabel.text = "买单"
        } else if order.originalOrder.side == "sell" {
            typeLabel.backgroundColor = UIColor.white
            typeLabel.textColor = UIColor.tokenestTableFont
            typeLabel.borderColor = UIColor.tokenestTableFont
            typeLabel.text = "卖单"
        }
        typeLabel.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        typeLabel.borderWidth = 1
        typeLabel.layer.cornerRadius = 6.0
        typeLabel.layer.masksToBounds = true
    }
    
    func setupOrderFilled(order: Order) {
        var percent: Double = 0.0
        if order.originalOrder.side.lowercased() == "sell" {
            percent = order.dealtAmountS / order.originalOrder.amountSell
        } else if order.originalOrder.side.lowercased() == "buy" {
            percent = order.dealtAmountB / order.originalOrder.amountBuy
        }
        filledPieChart.backgroundColor = UIColor.clear
        filledPieChart.strokeColor = UIColor.tokenestPending.cgColor
        filledPieChart.textColor = UIColor.tokenestTip
        filledPieChart.textFont = FontConfigManager.shared.getLabelENFont(size: 20)
        filledPieChart.desiredLineWidth = 5
        filledPieChart.percentage = CGFloat(percent)
        filledInfoLabel.text = (percent * 100).rounded().description + "%"
    }
    
    func setupOrderAmount(order: Order) {
        if order.originalOrder.side.lowercased() == "sell" {
            amountLabel.text = order.dealtAmountS.description + " " + order.originalOrder.tokenSell
            amountInfoLabel.text = order.dealtAmountS.description + " / " + order.originalOrder.amountSell.description + " " + order.originalOrder.tokenSell
            totalInfoLabel.text = order.originalOrder.amountBuy.withCommas(6) + " " + order.originalOrder.tokenBuy
            if let price = PriceDataManager.shared.getPrice(of: order.originalOrder.tokenSell) {
                let total = price * order.originalOrder.amountSell
                displayLabel.text = total.currency
            }
        } else if order.originalOrder.side.lowercased() == "buy" {
            amountLabel.text = order.dealtAmountB.description + " " + order.originalOrder.tokenBuy
            amountInfoLabel.text = order.dealtAmountB.description + " / " + order.originalOrder.amountBuy.description + " " + order.originalOrder.tokenBuy
            totalInfoLabel.text = order.originalOrder.amountSell.description + " " + order.originalOrder.tokenSell
            if let price = PriceDataManager.shared.getPrice(of: order.originalOrder.tokenBuy) {
                let total = price * order.originalOrder.amountBuy
                displayLabel.text = total.currency
            }
        }
        amountLabel.font = FontConfigManager.shared.getLabelENFont(size: 40)
        amountLabel.textColor = UIColor.tokenestTableFont
        displayLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        displayLabel.textColor = UIColor.tokenestTip
    }
    
    func setup() {
        guard let order = self.order else { return }

        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let padding: CGFloat = 15
        let labelHeight: CGFloat = 40
        
        marketLabel.text = order.tradingPairDescription
        marketLabel.font = UIFont.init(name: FontConfigManager.shared.getLight(), size: 30)
        marketLabel.textAlignment = .center
        marketLabel.textColor = UIColor.tokenestTip
        marketLabel.frame = CGRect(x: 0, y: 50, width: screenWidth, height: 40)
        scrollView.addSubview(marketLabel)
        
        setupOrderType(order: order)
        let contendWidth = marketLabel.intrinsicContentSize.width
        typeLabel.textAlignment = .center
        typeLabel.frame = CGRect(x: (screenWidth + contendWidth) / 2 + 5, y: marketLabel.frame.origin.y + 5, width: 40, height: 24)
        scrollView.addSubview(typeLabel)
        
        let circleChartWidth: CGFloat = round(screenWidth*0.3)
        let rect = CGRect(x: (screenWidth - circleChartWidth) / 2, y: marketLabel.frame.maxY + padding, width: circleChartWidth, height: circleChartWidth)
        filledPieChart = CircleChart(frame: rect)
        scrollView.addSubview(filledPieChart)
        setupOrderFilled(order: order)
        
        setupOrderAmount(order: order)
        amountLabel.textAlignment = .center
        amountLabel.frame = CGRect(x: 0, y: filledPieChart.frame.maxY + padding, width: screenWidth, height: 40)
        scrollView.addSubview(amountLabel)
        
        displayLabel.textAlignment = .center
        displayLabel.frame = CGRect(x: 0, y: amountLabel.frame.maxY + padding, width: screenWidth, height: 40)
        scrollView.addSubview(displayLabel)

        // setup rows
        // 1st row: amount
        amountTipLabel.font = FontConfigManager.shared.getLabelENFont()
        amountTipLabel.text = LocalizedString("Filled/Amount", comment: "")
        amountTipLabel.textColor = .tokenestTip
        amountTipLabel.frame = CGRect(x: padding, y: displayLabel.frame.maxY + padding*3, width: 150, height: labelHeight)
        scrollView.addSubview(amountTipLabel)
        
        amountInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        amountInfoLabel.textColor = .tokenestTableFont
        amountInfoLabel.textAlignment = .right
        amountInfoLabel.frame = CGRect(x: padding + 200, y: amountTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 200, height: labelHeight)
        scrollView.addSubview(amountInfoLabel)
        amountUnderline.frame = CGRect(x: padding, y: amountTipLabel.frame.maxY, width: screenWidth - padding * 2, height: 0.5)
        amountUnderline.backgroundColor = UIStyleConfig.underlineColor
        scrollView.addSubview(amountUnderline)
        
        // 2nd row: status
        statusTipLabel.font = FontConfigManager.shared.getLabelENFont()
        statusTipLabel.text = LocalizedString("Status", comment: "")
        statusTipLabel.textColor = .tokenestTip
        statusTipLabel.frame = CGRect(x: padding, y: amountTipLabel.frame.maxY + padding, width: 150, height: labelHeight)
        scrollView.addSubview(statusTipLabel)
        
        statusInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        statusInfoLabel.text = order.orderStatus.description
        statusInfoLabel.textColor = .tokenestTableFont
        statusInfoLabel.textAlignment = .right
        statusInfoLabel.frame = CGRect(x: padding + 200, y: statusTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 200, height: labelHeight)
        scrollView.addSubview(statusInfoLabel)
        
        statusUnderline.frame = CGRect(x: padding, y: statusTipLabel.frame.maxY, width: screenWidth - padding * 2, height: 0.5)
        statusUnderline.backgroundColor = UIStyleConfig.underlineColor
        scrollView.addSubview(statusUnderline)
        
        // 3rd row: total
        totalTipLabel.font = FontConfigManager.shared.getLabelENFont()
        totalTipLabel.text = LocalizedString("Total", comment: "")
        totalTipLabel.textColor = .tokenestTip
        totalTipLabel.frame = CGRect(x: padding, y: statusTipLabel.frame.maxY + padding, width: 150, height: labelHeight)
        scrollView.addSubview(totalTipLabel)
        
        totalInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        totalInfoLabel.textColor = .tokenestTableFont
        totalInfoLabel.textAlignment = .right
        totalInfoLabel.frame = CGRect(x: padding + 200, y: totalTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 200, height: labelHeight)
        scrollView.addSubview(totalInfoLabel)
        
        // 4th row: trade
        tradeTipLabel.font = FontConfigManager.shared.getLabelENFont()
        tradeTipLabel.text = LocalizedString("Trade", comment: "")
        tradeTipLabel.textColor = .tokenestTableFont
        tradeTipLabel.backgroundColor = UIStyleConfig.underlineColor
        tradeTipLabel.frame = CGRect(x: 0, y: totalTipLabel.frame.maxY + padding, width: screenWidth, height: labelHeight)
        tradeTipLabel.leftInset = padding
        scrollView.addSubview(tradeTipLabel)
        
        // 5th row: filled
        filledTipLabel.font = FontConfigManager.shared.getLabelENFont()
        filledTipLabel.text = LocalizedString("Filled", comment: "")
        filledTipLabel.textColor = .tokenestTip
        filledTipLabel.frame = CGRect(x: padding, y: tradeTipLabel.frame.maxY + padding, width: 150, height: labelHeight)
        
        scrollView.addSubview(filledTipLabel)
        filledInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        filledInfoLabel.textAlignment = .right
        filledInfoLabel.frame = CGRect(x: padding + 200, y: filledTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 200, height: labelHeight)
        filledInfoLabel.textColor = .tokenestTableFont
        scrollView.addSubview(filledInfoLabel)
        
        filledUnderline.frame = CGRect(x: padding, y: filledTipLabel.frame.maxY, width: screenWidth - padding * 2, height: 0.5)
        filledUnderline.backgroundColor = UIStyleConfig.underlineColor
        scrollView.addSubview(filledUnderline)
        
        // 6th row: ID
        idTipLabel.font = FontConfigManager.shared.getLabelENFont()
        idTipLabel.text = LocalizedString("ID", comment: "")
        idTipLabel.textColor = .tokenestTip
        idTipLabel.frame = CGRect(x: padding, y: filledTipLabel.frame.maxY + padding, width: 50, height: labelHeight)
        scrollView.addSubview(idTipLabel)
        
        idInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        idInfoLabel.text = order.originalOrder.hash
        idInfoLabel.textColor = .tokenestTableFont
        idInfoLabel.textAlignment = .right
        idInfoLabel.lineBreakMode = .byTruncatingMiddle
        idInfoLabel.frame = CGRect(x: padding + 200, y: idTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 200, height: labelHeight)
        scrollView.addSubview(idInfoLabel)
        idUnderline.frame = CGRect(x: padding, y: idTipLabel.frame.maxY, width: screenWidth - padding * 2, height: 0.5)
        idUnderline.backgroundColor = UIStyleConfig.underlineColor
        scrollView.addSubview(idUnderline)
        
        // 7th row: date
        dateTipLabel.font = FontConfigManager.shared.getLabelENFont()
        dateTipLabel.text = LocalizedString("Time", comment: "")
        dateTipLabel.textColor = .tokenestTip
        dateTipLabel.frame = CGRect(x: padding, y: idTipLabel.frame.maxY + padding, width: 150, height: labelHeight)
        scrollView.addSubview(dateTipLabel)
        dateInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        
        let time = UInt(order.originalOrder.validSince)
        dateInfoLabel.text = DateUtil.convertToDate(time, format: "yyyy-MM-dd HH:mm")
        dateInfoLabel.textColor = .tokenestTableFont
        dateInfoLabel.textAlignment = .right
        dateInfoLabel.frame = CGRect(x: padding + 200, y: dateTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 200, height: labelHeight)
        scrollView.addSubview(dateInfoLabel)
        
        dateUnderline.frame = CGRect(x: padding, y: dateTipLabel.frame.maxY, width: screenWidth - padding * 2, height: 0.5)
        dateUnderline.backgroundColor = UIStyleConfig.underlineColor
        scrollView.addSubview(dateUnderline)
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: screenWidth, height: dateTipLabel.frame.maxY + 30)
    }

}
