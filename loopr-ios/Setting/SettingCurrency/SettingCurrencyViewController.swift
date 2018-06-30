//
//  SettingCurrencyViewController.swift
//  loopr-ios
//
//  Created by kenshin on 2018/4/22.
//  Copyright © 2018年 Loopring. All rights reserved.
//

import UIKit

class SettingCurrencyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!

    @IBOutlet weak var tableView: UITableView!
    
    var currencies: [Currency] = SettingDataManager.shared.getSupportedCurrencies()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()

        view.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("Currency", comment: ""))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingCurrencyTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SettingCurrencyTableViewCell.getCellIdentifier()) as? SettingCurrencyTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingCurrencyTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingCurrencyTableViewCell
            cell?.selectionStyle = .none
        }
        cell?.currency = currencies[indexPath.row]
        if SettingDataManager.shared.getCurrentCurrency() == currencies[indexPath.row] {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        cell?.update()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        SettingDataManager.shared.setCurrentCurrency(currencies[indexPath.row])
        tableView.reloadData()
    }
}
