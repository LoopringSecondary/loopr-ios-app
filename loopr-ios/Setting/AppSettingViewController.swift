//
//  AppSettingViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AppSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: NSLocalizedString("Settings_in_grid", comment: ""))
        
        // Reload data if the data is updated.
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 49
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return userPreferencesSectionForCell(row: indexPath.row)
    }
    
    // Sections
    func userPreferencesSectionForCell(row: Int) -> UITableViewCell {
        switch row {
        case 0:
            return createDetailTableCell(title: NSLocalizedString("Currency", comment: ""), detailTitle: SettingDataManager.shared.getCurrentCurrency().name)
        case 1:
            return createSettingPasscodeTableView()
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                print("Setting currency")
                let viewController = SettingCurrencyViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            default:
                break
            }
        default:
            break
        }
    }

    func createSettingPasscodeTableView() -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SettingPasscodeTableViewCell.getCellIdentifier()) as? SettingPasscodeTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SettingPasscodeTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SettingPasscodeTableViewCell
            cell?.selectionStyle = .none
        }
        return cell!
    }

}
