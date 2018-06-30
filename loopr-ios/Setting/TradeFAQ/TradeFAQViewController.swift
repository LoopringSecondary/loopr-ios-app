//
//  TradeFQAViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/18/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class TradeFAQViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!

    @IBOutlet weak var tableView: UITableView!
    
    var tradeFAQPages: [TradeFAQPage] = [
        TradeFAQPage(title: "交易过程中哪些操作需要花钱？哪些操作不需要花钱？", fileName: "fee_0"),
        TradeFAQPage(title: "为什么我的订单成交价比我的卖价更高？或者比我的买价更低？", fileName: "fee_1"),
        TradeFAQPage(title: "为什么我的订单一直没有成交或者成交速度很慢？", fileName: "speed_0"),
        TradeFAQPage(title: "从下单到交易成交需要多长时间？", fileName: "speed_1"),
        TradeFAQPage(title: "如何比其他人更快地抢到订单？", fileName: "speed_2"),
        TradeFAQPage(title: "为什么我的订单没有出现在深度里？", fileName: "deep_0"),
        TradeFAQPage(title: "为什么交易深度中出现买价比卖价更高的订单？", fileName: "deep_1"),
        TradeFAQPage(title: "为什么我的订单没有出现在深度里？", fileName: "asset_0")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 13))
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("Trade FAQ", comment: ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tradeFAQPages.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TradeFAQTableViewCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: TradeFAQTableViewCell.getCellIdentifier()) as? TradeFAQTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("TradeFAQTableViewCell", owner: self, options: nil)
            cell = nib![0] as? TradeFAQTableViewCell
        }
        
        cell?.nameLabel.text = tradeFAQPages[indexPath.row].title

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let viewController = TradeFAQDetailViewController()
        viewController.tradeFAQPage = tradeFAQPages[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
