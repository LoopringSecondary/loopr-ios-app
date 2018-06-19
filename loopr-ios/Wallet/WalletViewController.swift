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

class WalletViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WalletBalanceTableViewCellDelegate, ContextMenuDelegate, QRCodeScanProtocol {

    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    private let refreshControl = UIRefreshControl()

    var assetTableView: UITableView = UITableView()
    var headerView = UILabel()
    var stickyView = UILabel()
    
    var isLaunching: Bool = true
    var isListeningSocketIO: Bool = false

    var contextMenuSourceView: UIView = UIView()

    let buttonInNavigationBar =  UIButton()
    var numberOfRowsInSection1: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavigationBar()
        
        
        self.view.backgroundColor = UIColor.white
        self.automaticallyAdjustsScrollViewInsets = true
        // self.edgesForExtendedLayout = .None
        
        let w = UIScreen.main.bounds.size.width
        
        headerView.backgroundColor = UIColor.green
        headerView.textColor = UIColor.white
        headerView.textAlignment = .center
        headerView.frame = CGRect.init(x: 0, y: 0, width: w, height: 80)
        self.view.addSubview(headerView)
        
        stickyView.backgroundColor = UIColor.red
        stickyView.textColor = UIColor.white
        stickyView.textAlignment = .center
        stickyView.frame = CGRect.init(x: 0, y: headerView.bottomY, width: w, height: 50)
        self.view.addSubview(stickyView)
        
        assetTableView.frame = CGRect.init(x: 0, y: stickyView.bottomY, width: w, height: self.view.height - stickyView.bottomY)
        assetTableView.delegate = self
        assetTableView.dataSource = self
        self.view.addSubview(assetTableView)
        
        assetTableView.dataSource = self
        assetTableView.delegate = self
        assetTableView.separatorStyle = .none
        
        // Avoid dragging a cell to the top makes the tableview shake
        assetTableView.estimatedRowHeight = 0
        assetTableView.estimatedSectionHeaderHeight = 0
        assetTableView.estimatedSectionFooterHeight = 0

        view.backgroundColor = UIColor.init(rgba: "#F3F6F8")
        assetTableView.backgroundColor = UIColor.init(rgba: "#F3F6F8") // = GlobalPicker.tableViewBackgroundColor // UIStyleConfig.tableViewBackgroundColor

        let qrCodebutton = UIButton(type: UIButtonType.custom)
        
        // TODO: smaller images.
        qrCodebutton.theme_setImage(["QRCode-white", "QRCode-white"], forState: UIControlState.normal)
        qrCodebutton.setImage(UIImage(named: "QRCode-black")?.alpha(0.3), for: .highlighted)
        qrCodebutton.addTarget(self, action: #selector(self.pressScanQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrCodebutton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let qrCodeBarButton = UIBarButtonItem(customView: qrCodebutton)
        // self.navigationItem.leftBarButtonItem = qrCodeBarButton

        let addBarButton = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(self.pressAddButton(_:)))
        // self.navigationItem.rightBarButtonItem = addBarButton
        
        // Disable refresh control
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            assetTableView.refreshControl = refreshControl
        } else {
            assetTableView.addSubview(refreshControl)
        }
        refreshControl.theme_tintColor = GlobalPicker.textColor
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
 
        // TODO: Unfinished
        // https://stackoverflow.com/questions/13364465/uirefreshcontrol-background-color
        // Creating view for extending background color
        //
        var frame = assetTableView.bounds
        frame.origin.y = -frame.size.height
        let backgroundView = UIImageView(frame: CGRect.init(x: 0, y: -100, width: assetTableView.bounds.width, height: 345))
        backgroundView.image = UIImage.init(named: "Tokenest-asset-background-image")
        // backgroundView.frame.height = 345
        backgroundView.autoresizingMask = .flexibleWidth
        // backgroundView.backgroundColor = UIColor.init(red: 59/255.0, green: 81/255.0, blue: 200/255.0, alpha: 1)
        
        // view.addSubview(backgroundView)
        // view.sendSubview(toBack: backgroundView)
        
        // Adding the view below the refresh control
        // assetTableView.insertSubview(backgroundView, at: 0)
        
        /*
        buttonInNavigationBar.frame = CGRect(x: 0, y: 0, width: 400, height: 40)
        buttonInNavigationBar.titleLabel?.font = FontConfigManager.shared.getNavigationTitleFont()
        buttonInNavigationBar.theme_setTitleColor(GlobalPicker.navigationBarTextColor, forState: .normal)
        buttonInNavigationBar.setTitleColor(UIColor.init(white: 0.8, alpha: 1), for: .highlighted)
        buttonInNavigationBar.addTarget(self, action: #selector(self.clickNavigationTitleButton(_:)), for: .touchUpInside)
        self.navigationItem.titleView = buttonInNavigationBar
        */
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
        qrScanButton.addTarget(self, action: #selector(self.pressScanQRCodeButton(_:)), for: UIControlEvents.touchUpInside)
        qrScanButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let qrCodeBarButton = UIBarButtonItem(customView: qrScanButton)
        navigationItem.leftBarButtonItem = qrCodeBarButton
        
        customizedNavigationBar.setItems([navigationItem], animated: false)
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
            viewController.parentControllerHasNavigationBar = false
            // viewController.delegate = self
            viewController.shouldPop = false
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
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
            self.assetTableView.reloadSections(IndexSet(integersIn: 1...1), with: .none)
        }
    }
    
    @objc func priceQuoteResponseReceivedNotification() {
        if !isLaunching {
            print("priceQuoteResponseReceivedNotification WalletViewController reload table")
            // assetTableView.reloadData()
            self.assetTableView.reloadSections(IndexSet(integersIn: 1...1), with: .none)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        CurrentAppWalletDataManager.shared.stopGetBalance()
        isListeningSocketIO = false
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating")
        isListeningSocketIO = true
        CurrentAppWalletDataManager.shared.startGetBalance()
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
            var cell = tableView.dequeueReusableCell(withIdentifier: WalletBalanceTableViewCell.getCellIdentifier()) as? WalletBalanceTableViewCell
            if cell == nil {
                let nib = Bundle.main.loadNibNamed("WalletBalanceTableViewCell", owner: self, options: nil)
                cell = nib![0] as? WalletBalanceTableViewCell
                cell?.selectionStyle = .none
                cell?.delegate = self
            }
            cell?.setup()
            if isLaunching {
                cell?.balanceLabel.setText("", animated: false)
            }
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
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UITableView.self) {
            if scrollView.contentOffset.x == 0 {
                let y = scrollView.contentOffset.y
                
                // scroll up
                if y > 0 {
                    struct Diff {
                        static var previousY: CGFloat = 0.0
                    }
                    
                    guard headerView.bottomY > 0.0 else {
                        return
                    }
                    
                    var bottomY = headerView.bottomY - fabs(y - Diff.previousY)
                    bottomY = bottomY >= 0.0 ? bottomY : 0.0
                    headerView.bottomY = bottomY
                    stickyView.y = headerView.bottomY
                    assetTableView.frame = CGRect.init(x: 0, y: stickyView.bottomY, width: assetTableView.width, height: self.view.height - stickyView.bottomY)
                    
                    Diff.previousY = y
                    if Diff.previousY >= headerView.height {
                        Diff.previousY = 0
                    }
                }
                // scroll down
                else if y < 0 {
                    if headerView.y >= 0 {
                        return
                    }
                    
                    var bottomY = headerView.bottomY + fabs(y)
                    bottomY = bottomY <= headerView.height ? bottomY : headerView.height
                    headerView.bottomY = bottomY
                    stickyView.y = headerView.bottomY
                    assetTableView.frame = CGRect.init(x: 0, y: stickyView.bottomY, width: assetTableView.width, height: self.view.height - stickyView.bottomY)
                }
            }
        }
    }

}
