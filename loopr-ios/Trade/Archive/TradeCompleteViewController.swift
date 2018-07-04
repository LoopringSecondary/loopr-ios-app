//
//  TradeCompleteViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class TradeCompleteViewController: UIViewController {

    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var customNavBar: UINavigationBar!
    @IBOutlet weak var exchangedLabel: UILabel!
    @IBOutlet weak var exchangedInfoLabel: UILabel!
    @IBOutlet weak var detailsButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // Need TokenA
    var needATipLabel: UILabel = UILabel()
    var needAInfoLabel: UILabel = UILabel()
    var needAUnderline: UIView = UIView()
    // Need TokenB
    var needBTipLabel: UILabel = UILabel()
    var needBInfoLabel: UILabel = UILabel()
    
    var order: OriginalOrder?
    var errorTipInfo: [String] = []
    var verifyInfo: [String: Double]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusBar.backgroundColor = GlobalPicker.themeColor
        setBackButtonAndUpdateTitle(customizedNavigationBar: customNavBar, title: "提交结果")
        // Do any additional setup after loading the view.
        setBackButton()
        setupErrorInfo()
        setupLabels()
        setupRows()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupRows() {
        guard !isBalanceEnough() else { return }
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let padding: CGFloat = 15
        
        // 1st row: need A token
        needATipLabel.font = FontConfigManager.shared.getLabelENFont()
        needATipLabel.text = LocalizedString("You Need More", comment: "")
        needATipLabel.frame = CGRect(x: padding, y: padding, width: 150, height: 40)
        scrollView.addSubview(needATipLabel)
        needAInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        needAInfoLabel.textColor = .red
        needAInfoLabel.text = errorTipInfo[0]
        needAInfoLabel.textAlignment = .right
        needAInfoLabel.frame = CGRect(x: padding + 150, y: needATipLabel.frame.origin.y, width: screenWidth - padding * 2 - 150, height: 40)
        scrollView.addSubview(needAInfoLabel)
        
        guard errorTipInfo.count == 2 else { return }
        
        needAUnderline.frame = CGRect(x: padding, y: needATipLabel.frame.maxY, width: screenWidth - padding * 2, height: 1)
        needAUnderline.backgroundColor = UIStyleConfig.underlineColor
        scrollView.addSubview(needAUnderline)
        
        // 2nd row: need B token
        needBTipLabel.font = FontConfigManager.shared.getLabelENFont()
        needBTipLabel.text = LocalizedString("You Need More", comment: "")
        needBTipLabel.frame = CGRect(x: padding, y: needATipLabel.frame.maxY + padding, width: 150, height: 40)
        scrollView.addSubview(needBTipLabel)
        needBInfoLabel.font = FontConfigManager.shared.getLabelENFont()
        needBInfoLabel.textColor = .red
        needBInfoLabel.textAlignment = .right
        needBInfoLabel.frame = CGRect(x: padding + 150, y: needBTipLabel.frame.origin.y, width: screenWidth - padding * 2 - 150, height: 40)
        scrollView.addSubview(needBInfoLabel)
    }
    
    func setupLabels() {
        exchangedLabel.textColor = UIColor.tokenestTableFont
        exchangedLabel.font = FontConfigManager.shared.getLabelSCFont(size: 40, type: "Bold")
        exchangedInfoLabel.textColor = UIColor.tokenestTip
        exchangedInfoLabel.font = FontConfigManager.shared.getLabelSCFont(size: 21)
        
        if isBalanceEnough() {
            exchangedLabel.text = LocalizedString("Placed!", comment: "")
            exchangedInfoLabel.text = LocalizedString("Congradualations! Your order has been submited!", comment: "")
        } else {
            exchangedLabel.text = LocalizedString("Attention!", comment: "")
            exchangedInfoLabel.text = LocalizedString("Your order has not been submited! Please make sure you have enough balance to complete the trade.", comment: "")
        }
    }
    
    func isBalanceEnough() -> Bool {
        return errorTipInfo.count == 0
    }
    
    func setupButtons() {
        doneButton.title = LocalizedString("Done", comment: "")
        detailsButton.title = LocalizedString("Check Details", comment: "")
        
        detailsButton.layer.shadowRadius = 4
        detailsButton.layer.shadowColor = UIColor.tokenestBackground.cgColor
        detailsButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        detailsButton.clipsToBounds = false
        doneButton.layer.shadowRadius = 8
        doneButton.layer.shadowColor = UIColor.tokenestLightShadow.cgColor
        doneButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        doneButton.clipsToBounds = false
        
        if isBalanceEnough() {
            detailsButton.isHidden = false
        } else {
            detailsButton.isHidden = true
        }
    }
    
    func setupErrorInfo() {
        if let info = self.verifyInfo {
            for item in info {
                if item.key.starts(with: "MINUS_") {
                    let key = item.key.components(separatedBy: "_")[1]
                    self.errorTipInfo.append("\(item.value.withCommas()) \(key)")
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedDetailsButton(_ sender: UIButton) {
        if let original = self.order {
            let order = Order(originalOrder: original, orderStatus: .finished)
            let viewController = OrderDetailViewController()
            viewController.order = order
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @IBAction func pressedDoneButton(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
