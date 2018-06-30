//
//  TradeCompleteViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class TradeCompleteViewController: UIViewController {

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

        // Do any additional setup after loading the view.
        setBackButton()
        setupErrorInfo()
        setupLabels()
        setupRows()
        setupButtons()
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
        exchangedLabel.font = UIFont(name: FontConfigManager.shared.getBold(), size: 40.0)
        exchangedLabel.font = FontConfigManager.shared.getRegularFont(size: 20.0)
        exchangedInfoLabel.textColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
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
        detailsButton.title = LocalizedString("Check Details", comment: "")
        detailsButton.setupRoundWhite()
        if isBalanceEnough() {
            detailsButton.isEnabled = true
            detailsButton.backgroundColor = UIColor.white
        } else {
            detailsButton.isEnabled = false
            detailsButton.layer.borderColor = UIColor.clear.cgColor
            detailsButton.backgroundColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)
        }
        doneButton.title = LocalizedString("Done", comment: "")
        doneButton.setupRoundBlack()
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
