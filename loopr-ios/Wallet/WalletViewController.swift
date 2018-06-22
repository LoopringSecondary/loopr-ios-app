//
//  WalletViewController.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/1/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import NotificationBannerSwift
import SwiftTheme
import SideMenu

class WalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, WalletBalanceDelegate, ContextMenuDelegate, QRCodeScanProtocol {

    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    private let refreshControl = UIRefreshControl()

    var assetTableView: UITableView = UITableView()
    var headerViewView = WalletBalanceTableViewCellViewController()
    var headerHeightConstraint: NSLayoutConstraint!

    var isLaunching: Bool = true
    var isListeningSocketIO: Bool = false

    var contextMenuSourceView: UIView = UIView()

    let buttonInNavigationBar =  UIButton()
    var numberOfRowsInSection1: Int = 0
    
    var previousY: CGFloat = 0.0
    let backgroundImageHeight: CGFloat = 345 - 20 + 32
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpHeader()
        setUpTableView()
        
        self.view.backgroundColor = UIColor.white

        view.backgroundColor = UIColor.init(rgba: "#F3F6F8")
        assetTableView.backgroundColor = UIColor.clear
        assetTableView.separatorStyle = .none
        
        let qrCodebutton = UIButton(type: UIButtonType.custom)
        
        // TODO: smaller images.
        qrCodebutton.theme_setImage(["QRCode-white", "QRCode-white"], forState: UIControlState.normal)
        qrCodebutton.setImage(UIImage(named: "QRCode-black")?.alpha(0.3), for: .highlighted)
        qrCodebutton.addTarget(self, action: #selector(self.pressScanQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrCodebutton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        _ = UIBarButtonItem(customView: qrCodebutton)
        // self.navigationItem.leftBarButtonItem = qrCodeBarButton

        _ = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.pressAddButton(_:)))
        // self.navigationItem.rightBarButtonItem = addBarButton
        
        // Disable refresh control
        // Add Refresh Control to Table View
        refreshControl.bounds = CGRect.init(x: refreshControl.bounds.origin.x, y: backgroundImageHeight - 10, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        if #available(iOS 10.0, *) {
            assetTableView.refreshControl = refreshControl
        } else {
            // assetTableView.addSubview(refreshControl)
        }
        refreshControl.theme_tintColor = GlobalPicker.textColor
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
 
        /*
        buttonInNavigationBar.frame = CGRect(x: 0, y: 0, width: 400, height: 40)
        buttonInNavigationBar.titleLabel?.font = FontConfigManager.shared.getNavigationTitleFont()
        buttonInNavigationBar.theme_setTitleColor(GlobalPicker.navigationBarTextColor, forState: .normal)
        buttonInNavigationBar.setTitleColor(UIColor.init(white: 0.8, alpha: 1), for: .highlighted)
        buttonInNavigationBar.addTarget(self, action: #selector(self.clickNavigationTitleButton(_:)), for: .touchUpInside)
        self.navigationItem.titleView = buttonInNavigationBar
        */
        
        setupNavigationBar()
        bringSubviewsToFront()
    }
    
    func setupNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        
        customizedNavigationBar.backgroundColor = UIColor.clear
        customizedNavigationBar.isTranslucent = true
        customizedNavigationBar.setBackgroundImage(UIImage(), for: .default)
        customizedNavigationBar.shadowImage = UIImage()
        
        let navigationItem = UINavigationItem()
        navigationItem.title = "TOKENEST"
        
        let qrScanButton = UIButton(type: .custom)
        qrScanButton.setImage(UIImage.init(named: "Scan-white"), for: .normal)
        qrScanButton.setImage(UIImage(named: "Scan-white")?.alpha(0.3), for: .highlighted)
        qrScanButton.addTarget(self, action: #selector(self.pressScanQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrScanButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let qrCodeBarButton = UIBarButtonItem(customView: qrScanButton)
        navigationItem.rightBarButtonItem = qrCodeBarButton
        
        let switchWalletButton = UIButton(type: .custom)
        switchWalletButton.setImage(UIImage.init(named: "Tokenest-switch-wallet"), for: .normal)
        switchWalletButton.setImage(UIImage(named: "Tokenest-switch-wallet")?.alpha(0.3), for: .highlighted)
        switchWalletButton.addTarget(self, action: #selector(self.pressedSwitchWalletButton(_:)), for: UIControlEvents.touchUpInside)
        switchWalletButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let switchWalletBarButton = UIBarButtonItem(customView: switchWalletButton)
        navigationItem.leftBarButtonItem = switchWalletBarButton
        
        customizedNavigationBar.setItems([navigationItem], animated: false)
        
        // Left menu
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: SelectWalletViewController())
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        SideMenuManager.default.menuAnimationFadeStrength = 0.71
        SideMenuManager.default.menuShadowColor = UIColor.clear
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.black
        SideMenuManager.default.menuFadeStatusBar = false
        SideMenuManager.default.menuWidth = UIScreen.main.bounds.width * 294/375
    }
    
    func bringSubviewsToFront() {
        view.bringSubview(toFront: headerViewView.view)
        view.bringSubview(toFront: customizedNavigationBar)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data
        getBalanceFromRelay()
    }
    
    func getBalanceFromRelay() {
        guard CurrentAppWalletDataManager.shared.getCurrentAppWallet() != nil else {
            return
        }

        CurrentAppWalletDataManager.shared.getBalanceAndPriceQuote(address: CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address, completionHandler: { _, error in
            print("receive CurrentAppWalletDataManager.shared.getBalanceAndPriceQuote() in WalletViewController")
            guard error == nil else {
                print("error=\(String(describing: error))")
                let banner = NotificationBanner.generate(title: "Sorry. Network error", style: .info)
                banner.duration = 2.0
                banner.show()
                return
            }
            DispatchQueue.main.async {
                if self.isLaunching {
                    self.isLaunching = false
                }
                self.assetTableView.reloadData()
                self.headerViewView.setup()
                self.refreshControl.endRefreshing()
            }
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
        
        getBalanceFromRelay()
        SendCurrentAppWalletDataManager.shared.getNonceFromEthereum()
        if let cell = assetTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? WalletBalanceTableViewCell {
            cell.startUpdateBalanceLabelTimer()
        }
        let buttonTitle = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.name ?? NSLocalizedString("Wallet", comment: "")
        buttonInNavigationBar.title = buttonTitle
        
        // TODO: in the new design, no right image
        // buttonInNavigationBar.setRightImage(imageName: "Arrow-down-black", imagePaddingTop: 0, imagePaddingLeft: 20, titlePaddingRight: 0)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isListeningSocketIO = true
        CurrentAppWalletDataManager.shared.startGetBalance()
        // Add observer.
        NotificationCenter.default.addObserver(self, selector: #selector(balanceResponseReceivedNotification), name: .balanceResponseReceived, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(priceQuoteResponseReceivedNotification), name: .priceQuoteResponseReceived, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        showNavigationBar()

        guard CurrentAppWalletDataManager.shared.getCurrentAppWallet() != nil else {
            return
        }

        CurrentAppWalletDataManager.shared.stopGetBalance()
        isListeningSocketIO = false
        NotificationCenter.default.removeObserver(self, name: .balanceResponseReceived, object: nil)
        NotificationCenter.default.removeObserver(self, name: .priceQuoteResponseReceived, object: nil)
        
        if let cell = assetTableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? WalletBalanceTableViewCell {
            cell.stopUpdateBalanceLabelTimer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setResultOfScanningQRCode(valueSent: String, type: QRCodeType) {
        if type == .submitOrder {
            AuthorizeDataManager.shared.getSubmitOrder { (_, error) in
                guard error == nil, let order = AuthorizeDataManager.shared.submitOrder else { return }
                DispatchQueue.main.async {
                    let vc = PlaceOrderConfirmationViewController()
                    vc.order = order
                    vc.isSigning = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if type == .login {
            AuthorizeDataManager.shared._authorizeLogin { (_, error) in
                let result = error == nil ? true : false
                DispatchQueue.main.async {
                    let vc = LoginResultViewController()
                    vc.result = result
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if type == .cancelOrder {
            AuthorizeDataManager.shared.getCancelOrder { (_, error) in
                let result = error == nil ? true : false
                DispatchQueue.main.async {
                    let vc = LoginResultViewController()
                    vc.result = result
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else if type == .convert {
            AuthorizeDataManager.shared.getConvertTx { (_, error) in
                let result = error == nil ? true : false
                DispatchQueue.main.async {
                    let vc = LoginResultViewController()
                    vc.result = result
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
    
    @objc func clickNavigationTitleButton(_ button: UIButton) {
        print("select another wallet.")
        let viewController = SelectWalletViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pressScanQRCodeButton(_ button: UIBarButtonItem) {
        print("pressScanQRCodeButton")
        if CurrentAppWalletDataManager.shared.getCurrentAppWallet() != nil {
            let viewController = ScanQRCodeViewController()
            // viewController.delegate = self
            viewController.shouldPop = false
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    @objc func pressedSwitchWalletButton(_ button: UIBarButtonItem) {
        print("pressedSwitchWalletButton")
        present(SideMenuManager.default.menuLeftNavigationController!, animated: true, completion: nil)
    }
    
    @objc func pressAddButton(_ button: UIBarButtonItem) {
        contextMenuSourceView.frame = CGRect(x: self.view.frame.width-10, y: -5, width: 1, height: 1)
        view.addSubview(contextMenuSourceView)
        
        let icons = [UIImage(named: "Scan-white")!, UIImage(named: "Add-token")!]
        let titles = [NSLocalizedString("Scan QR Code", comment: ""), NSLocalizedString("Add Token", comment: "")]
        let menuViewController = AddMenuViewController(rows: 2, titles: titles, icons: icons)
        menuViewController.didSelectRowClosure = { (index) -> Void in
            if index == 0 {
                print("Selected Scan QR code")
                let viewController = ScanQRCodeViewController()
                viewController.delegate = self
                viewController.shouldPop = false
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            } else if index == 1 {
                print("Selected Add Token")
                let viewController = AddTokenViewController()
                viewController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(viewController, animated: true)
            }
        }
        ContextMenu.shared.show(
            sourceViewController: self,
            viewController: menuViewController,
            options: ContextMenu.Options(containerStyle: ContextMenu.ContainerStyle(backgroundColor: UIColor.black), menuStyle: .minimal),
            sourceView: contextMenuSourceView,
            delegate: self
        )
    }
    
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
        print("will dismiss")
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        print("did dismiss")
        contextMenuSourceView.removeFromSuperview()
    }
    
    @objc func balanceResponseReceivedNotification() {
        if !isLaunching && isListeningSocketIO {
            print("balanceResponseReceivedNotification WalletViewController reload table")
            // assetTableView.reloadData()
            // self.assetTableView.reloadSections(IndexSet(integersIn: 1...1), with: .none)
        }
    }
    
    @objc func priceQuoteResponseReceivedNotification() {
        if !isLaunching {
            print("priceQuoteResponseReceivedNotification WalletViewController reload table")
            // assetTableView.reloadData()
            // self.assetTableView.reloadSections(IndexSet(integersIn: 1...1), with: .none)
        }
    }
    
    // Scroll view delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        CurrentAppWalletDataManager.shared.stopGetBalance()
        isListeningSocketIO = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("change: \(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y < 0 {
            headerViewView.view.y = 0
            headerViewView.balanceLabel.alpha = 1.0
        } else {
            headerViewView.view.y = -scrollView.contentOffset.y
            headerViewView.balanceLabel.alpha = (70 - scrollView.contentOffset.y)/70
            
            // TODO: add more animation if needed. We can even update the navigation bar title.

            if headerViewView.view.y <= -200 {
                headerViewView.view.y = -200
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        isListeningSocketIO = true
        // CurrentAppWalletDataManager.shared.startGetBalance()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if isLaunching {
            return 1
        }
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            numberOfRowsInSection1 = CurrentAppWalletDataManager.shared.getAssetsWithHideSmallAssetsOption().count
            return numberOfRowsInSection1
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let backgroundImageHeight: CGFloat = 345 - 20 // self.view.frame.height * 0.6
            return backgroundImageHeight + 32
        } else {
            return AssetTableViewCell.getHeight()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCell(withIdentifier: WalletClearTableViewCell.getCellIdentifier()) as? WalletClearTableViewCell
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("WalletClearTableViewCell", owner: self, options: nil)
                cell = nib![0] as? WalletClearTableViewCell
                cell?.selectionStyle = .none
                // cell?.delegate = self
            }
            /*
            cell?.setup()
            if isLaunching {
                cell?.balanceLabel.setText("", animated: false)
            }
            */
            return cell!
        } else {
            var cell = tableView.dequeueReusableCell(withIdentifier: AssetTableViewCell.getCellIdentifier()) as? AssetTableViewCell
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("AssetTableViewCell", owner: self, options: nil)
                cell = nib![0] as? AssetTableViewCell
            }
            cell?.asset = CurrentAppWalletDataManager.shared.getAssetsWithHideSmallAssetsOption()[indexPath.row]
            cell?.update()
            return cell!
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            tableView.deselectRow(at: indexPath, animated: true)
            let asset = CurrentAppWalletDataManager.shared.getAssetsWithHideSmallAssetsOption()[indexPath.row]
            // let viewController = AssetSwipeViewController()
            let viewController = AssetDetailViewController()
            viewController.asset = asset
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    func updateTableView(isHideSmallAsset: Bool) {
        if !isLaunching {
            if isHideSmallAsset {
                var rows: [IndexPath] = []
                let lastRow = CurrentAppWalletDataManager.shared.getAssetsWithHideSmallAssetsOption().count
                for i in lastRow..<numberOfRowsInSection1 {
                    rows.append(IndexPath.init(row: i, section: 1))
                }
                self.assetTableView.deleteRows(at: rows, with: .top)
            } else {
                var rows: [IndexPath] = []
                let lastRow = CurrentAppWalletDataManager.shared.getAssetsWithHideSmallAssetsOption().count
                for i in numberOfRowsInSection1..<lastRow {
                    rows.append(IndexPath.init(row: i, section: 1))
                }
                self.assetTableView.insertRows(at: rows, with: .top)
            }
        }
    }
    
    func setUpHeader() {
        headerViewView.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerViewView.view)
        headerHeightConstraint = headerViewView.view.heightAnchor.constraint(equalToConstant: backgroundImageHeight)
        headerHeightConstraint.isActive = true
        let constraints: [NSLayoutConstraint] = [
            headerViewView.view.topAnchor.constraint(equalTo: view.topAnchor),
            headerViewView.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerViewView.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        headerViewView.delegate = self
    }
    
    func setUpTableView() {
        assetTableView = UITableView()
        assetTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(assetTableView)
        let constraints: [NSLayoutConstraint] = [
            assetTableView.topAnchor.constraint(equalTo: view.topAnchor),
            assetTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            assetTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            assetTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        assetTableView.dataSource = self
        assetTableView.delegate = self
    }
    
    func pressedSendButton() {
        let viewController = SendViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    func pressedReceiveButton() {
        
    }
}
