//
//  UpdatedSettingViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class UpdatedSettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!

    @IBOutlet weak var qrcodeButton: UIButton!
    @IBOutlet weak var myAddressInfoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var settingsTableView: UITableView!

    @IBOutlet weak var selectionGridView: UIView!
    
    @IBOutlet weak var item1: UIButton!
    @IBOutlet weak var item2: UIButton!
    @IBOutlet weak var item3: UIButton!
    @IBOutlet weak var item4: UIButton!
    @IBOutlet weak var item5: UIButton!
    @IBOutlet weak var item6: UIButton!
    
    @IBOutlet weak var presentedBackgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()
        
        // settingsTableView.backgroundColor = UIColor.clear
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.separatorStyle = .none
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 11))
        // TODO: only top-left and top-right corner of a UIView
        // headerView.cornerRadius = 2
        settingsTableView.tableHeaderView = headerView

        qrcodeButton.setImage(UIImage.init(named: "Tokenest-setting-qrcode"), for: .normal)
        qrcodeButton.setImage(UIImage.init(named: "Tokenest-setting-qrcode")?.alpha(0.6), for: .highlighted)
        qrcodeButton.addTarget(self, action: #selector(self.pressedQRCodeButton(_:)), for: .touchUpInside)

        myAddressInfoLabel.text = NSLocalizedString("My Wallet Address", comment: "")
        myAddressInfoLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        myAddressInfoLabel.textColor = UIColor.init(rgba: "#8493F4")

        addressLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        addressLabel.textColor = UIColor.white
        // In the system line break mode, "..." is not centered.
        addressLabel.textAlignment = .center
        addressLabel.lineBreakMode = .byTruncatingMiddle
        
        copyButton.setTitle(NSLocalizedString("Copy", comment: ""), for: .normal)
        copyButton.clipsToBounds = true
        copyButton.setTitleColor(.gray, for: .disabled)
        copyButton.setTitleColor(GlobalPicker.themeColor, for: .normal)
        copyButton.setTitleColor(UIColor.init(white: 0.5, alpha: 1), for: .highlighted)
        copyButton.titleLabel?.font = UIFont(name: FontConfigManager.shared.getBold(), size: 14)
        copyButton.layer.cornerRadius = 28 * 0.5
        copyButton.addTarget(self, action: #selector(self.pressedCopyButton(_:)), for: .touchUpInside)

        presentedBackgroundView.backgroundColor = UIColor.clear
        presentedBackgroundView.isHidden = true
        view.bringSubview(toFront: presentedBackgroundView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        setupNavigationBar()
        addressLabel.text = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address.getAddressFormat()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // showNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        customizedNavigationBar.backgroundColor = UIColor.clear
        customizedNavigationBar.isTranslucent = true
        customizedNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customizedNavigationBar.shadowImage = UIImage()

        let navigationItem = UINavigationItem()
        navigationItem.title = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.name
        
        // TODO: Needs an icon
        let qrScanButton = UIButton(type: UIButtonType.custom)
        qrScanButton.setImage(UIImage.init(named: "Scan-white"), for: .normal)
        qrScanButton.setImage(UIImage(named: "Scan")?.alpha(0.3), for: .highlighted)
        qrScanButton.addTarget(self, action: #selector(self.pressedScanQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrScanButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let qrCodeBarButton = UIBarButtonItem(customView: qrScanButton)
        navigationItem.rightBarButtonItem = qrCodeBarButton

        customizedNavigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc func pressedQRCodeButton(_ sender: Any) {
        let viewController = QRCodeViewController()
        viewController.delegate = self
        viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        presentedBackgroundView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            self.presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc func pressedScanQRCodeButton(_ sender: Any) {
        print("Selected Scan QR code")
        let viewController = ScanQRCodeViewController()
        // viewController.delegate = self
        viewController.shouldPop = false
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedCopyButton(_ button: UIButton) {
        print("pressedCopyButton")
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address
        print("pressedCopyAddressButton address: \(address)")
        UIPasteboard.general.string = address
        let banner = NotificationBanner.generate(title: "Copy address to clipboard successfully!", style: .success)
        banner.duration = 1
        banner.show()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UpdatedSettingTableViewCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: UpdatedSettingTableViewCell.getCellIdentifier()) as? UpdatedSettingTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("UpdatedSettingTableViewCell", owner: self, options: nil)
            cell = nib![0] as? UpdatedSettingTableViewCell
            
            // TODO: what is the selection style?
            // cell?.selectionStyle = .none
        }
        
        switch indexPath.row {
        case 0:
            cell?.iconImageView.image = UIImage.init(named: "Tokenest-setting-wallet-management")
            cell?.nameLabel.text = NSLocalizedString("Wallet Management", comment: "")
        case 1:
            cell?.iconImageView.image = UIImage.init(named: "Tokenest-trading-setting")
            cell?.nameLabel.text = NSLocalizedString("Trading_settings_in_grid", comment: "")
        case 2:
            cell?.iconImageView.image = UIImage.init(named: "Tokenest-app-settings")
            cell?.nameLabel.text = NSLocalizedString("Settings_in_grid", comment: "")
        case 3:
            cell?.iconImageView.image = UIImage.init(named: "Tokenest-trading-faq")
            cell?.nameLabel.text = NSLocalizedString("Trade FAQ", comment: "")
        default:
            break
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            let viewController = SettingManageWalletViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case 1:
            let viewController = TradingSettingViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case 2:
            let viewController = AppSettingViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        case 3:
            let viewController = TradeFAQViewController()
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        default:
            break
        }
    }
}

extension UpdatedSettingViewController: QRCodeViewControllerDelegate {
    func dismissQRCodeViewController() {
        UIView.animate(withDuration: 0.3, animations: {
            self.presentedBackgroundView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }, completion: { (_) in
            self.presentedBackgroundView.isHidden = true
        })
    }
}
