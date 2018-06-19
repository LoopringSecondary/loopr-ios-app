//
//  UpdatedSettingViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import NotificationBannerSwift

class UpdatedSettingViewController: UIViewController {
    
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!

    @IBOutlet weak var qrcodeButton: UIButton!
    @IBOutlet weak var myAddressInfoLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    @IBOutlet weak var selectionGridView: UIView!
    
    @IBOutlet weak var item1: UIButton!
    @IBOutlet weak var item2: UIButton!
    @IBOutlet weak var item3: UIButton!
    @IBOutlet weak var item4: UIButton!
    @IBOutlet weak var item5: UIButton!
    @IBOutlet weak var item6: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationBar()

        qrcodeButton.setImage(UIImage.init(named: "Tokenest-setting-qrcode"), for: .normal)
        qrcodeButton.setImage(UIImage.init(named: "Tokenest-setting-qrcode")?.alpha(0.6), for: .highlighted)

        myAddressInfoLabel.text = NSLocalizedString("My Wallet Address", comment: "")
        myAddressInfoLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        myAddressInfoLabel.textColor = UIColor.init(rgba: "#8493F4")

        addressLabel.font = FontConfigManager.shared.getLabelFont(size: 16)
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
        
        selectionGridView.backgroundColor = UIColor.init(white: 1, alpha: 0.98)
        selectionGridView.cornerRadius = 7.5
        selectionGridView.clipsToBounds = true
        
        // Update grid
        let iconTitlePadding: CGFloat = 15
        
        item1.backgroundColor = UIColor.clear
        item1.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        item1.set(image: UIImage.init(named: "Tokenest-airdrop"), title: NSLocalizedString("Airdrop", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .normal)
        item1.set(image: UIImage.init(named: "Tokenest-airdrop")?.alpha(0.6), title: NSLocalizedString("Airdrop", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .highlighted)
        item1.setTitleColor(UIColor.black, for: .normal)
        item1.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        item1.addTarget(self, action: #selector(self.pressedItem1Button(_:)), for: .touchUpInside)
        
        item2.backgroundColor = UIColor.clear
        item2.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        item2.set(image: UIImage.init(named: "Tokenest-trading-faq"), title: NSLocalizedString("Trade FAQ", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .normal)
        item2.set(image: UIImage.init(named: "Tokenest-trading-faq")?.alpha(0.6), title: NSLocalizedString("Trade FAQ", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .highlighted)
        item2.setTitleColor(UIColor.black, for: .normal)
        item2.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        item2.addTarget(self, action: #selector(self.pressedItem2Button(_:)), for: .touchUpInside)
        
        item3.backgroundColor = UIColor.clear
        item3.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        item3.set(image: UIImage.init(named: "Tokenest-question-feedback"), title: NSLocalizedString("Feedback", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .normal)
        item3.set(image: UIImage.init(named: "Tokenest-question-feedback")?.alpha(0.6), title: NSLocalizedString("Feedback", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .highlighted)
        item3.setTitleColor(UIColor.black, for: .normal)
        item3.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        item3.addTarget(self, action: #selector(self.pressedItem3Button(_:)), for: .touchUpInside)
        
        item4.backgroundColor = UIColor.clear
        item4.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        item4.set(image: UIImage.init(named: "Tokenest-app-settings"), title: NSLocalizedString("Settings_in_grid", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .normal)
        item4.set(image: UIImage.init(named: "Tokenest-app-settings")?.alpha(0.6), title: NSLocalizedString("Settings_in_grid", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .highlighted)
        item4.setTitleColor(UIColor.black, for: .normal)
        item4.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        item4.addTarget(self, action: #selector(self.pressedItem4Button(_:)), for: .touchUpInside)

        item5.backgroundColor = UIColor.clear
        item5.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        item5.set(image: UIImage.init(named: "Tokenest-trading-setting"), title: NSLocalizedString("Trading_settings_in_grid", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .normal)
        item5.set(image: UIImage.init(named: "Tokenest-trading-setting")?.alpha(0.6), title: NSLocalizedString("Trading_settings_in_grid", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .highlighted)
        item5.setTitleColor(UIColor.black, for: .normal)
        item5.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        item5.addTarget(self, action: #selector(self.pressedItem5Button(_:)), for: .touchUpInside)

        item6.backgroundColor = UIColor.clear
        item6.titleLabel?.font = FontConfigManager.shared.getLabelFont(size: 14.0)
        item6.set(image: UIImage.init(named: "Tokenest-settings-quit"), title: NSLocalizedString("Quit", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .normal)
        item6.set(image: UIImage.init(named: "Tokenest-settings-quit")?.alpha(0.6), title: NSLocalizedString("Quit", comment: ""), titlePosition: .bottom, additionalSpacing: iconTitlePadding, state: .highlighted)
        item6.setTitleColor(UIColor.black, for: .normal)
        item6.setTitleColor(UIColor.init(white: 0, alpha: 0.6), for: .highlighted)
        item6.addTarget(self, action: #selector(self.pressedItem6Button(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        addressLabel.text = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showNavigationBar()
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        customizedNavigationBar.backgroundColor = UIColor.clear
        customizedNavigationBar.isTranslucent = true
        customizedNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customizedNavigationBar.shadowImage = UIImage()

        let navigationItem = UINavigationItem()
        navigationItem.title = "TOKENEST"
        
        // TODO: Needs an icon
        let qrScanButton = UIButton(type: UIButtonType.custom)
        qrScanButton.setImage(UIImage.init(named: "Scan-white"), for: .normal)
        qrScanButton.setImage(UIImage(named: "Scan")?.alpha(0.3), for: .highlighted)
        qrScanButton.addTarget(self, action: #selector(self.pressQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrScanButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let qrCodeBarButton = UIBarButtonItem(customView: qrScanButton)
        navigationItem.leftBarButtonItem = qrCodeBarButton

        customizedNavigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc func pressQRCodeButton(_ sender: Any) {
        print("Selected Scan QR code")
        let viewController = ScanQRCodeViewController()
        viewController.parentControllerHasNavigationBar = false
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

    @objc func pressedItem1Button(_ button: UIButton) {
        print("pressedItem1Button")
    }

    @objc func pressedItem2Button(_ button: UIButton) {
        print("pressedItem2Button")
    }
    
    @objc func pressedItem3Button(_ button: UIButton) {
        print("pressedItem3Button")
        let viewController = TradeFAQViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedItem4Button(_ button: UIButton) {
        print("pressedItem4Button")
        let viewController = AppSettingViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedItem5Button(_ button: UIButton) {
        print("pressedItem5Button")
        let viewController = TradingSettingViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressedItem6Button(_ button: UIButton) {
        print("pressedItem6Button")
    }
}
