//
//  AssetDetailViewController.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/3/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AssetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ContextMenuDelegate {
    
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var typeButton: UIButton!
    @IBOutlet weak var moreButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var buttonHeightLayoutConstraint: NSLayoutConstraint!

    var asset: Asset?
    var isLaunching: Bool = true
    var transactions: [String: [Transaction]] = [:]
    var transactionDates: [String] = []
    let refreshControl = UIRefreshControl()
    var contextMenuSourceView: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
        setupNavigationBar()
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor
        
        view.theme_backgroundColor = GlobalPicker.backgroundColor
        tableView.theme_backgroundColor = GlobalPicker.backgroundColor
        
        tableView.dataSource = self
        tableView.delegate = self
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 10))
        footerView.backgroundColor = UIStyleConfig.tableViewBackgroundColor
        tableView.tableFooterView = footerView
        tableView.separatorStyle = .none
        
        view.backgroundColor = UIStyleConfig.tableViewBackgroundColor
        tableView.backgroundColor = UIStyleConfig.tableViewBackgroundColor
        
        // Receive button
        receiveButton.setTitle(LocalizedString("Receive", comment: ""), for: .normal)
        // Send button
        sendButton.setTitle(LocalizedString("Send", comment: ""), for: .normal)
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        refreshControl.theme_tintColor = GlobalPicker.textColor
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        // Creating view for extending background color
        var frame = tableView.bounds
        frame.origin.y = -frame.size.height
        let backgroundView = UIView(frame: frame)
        backgroundView.autoresizingMask = .flexibleWidth
        backgroundView.backgroundColor = UIColor.white
        
        // Adding the view below the refresh control
        tableView.insertSubview(backgroundView, at: 0)
    }
    
    func setup() {
        getTransactionsFromRelay()
        if let asset = self.asset {
            tokenImage.image = asset.icon
            symbolLabel.text = asset.symbol
            nameLabel.text = asset.name
            amountLabel.text = asset.display
            currencyLabel.text = asset.currency
        }
        symbolLabel.font = FontConfigManager.shared.getLabelENFont(size: 18)
        nameLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        amountLabel.font = FontConfigManager.shared.getLabelENFont(size: 18)
        currencyLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        typeButton.contentHorizontalAlignment = .left
        titleView.layer.shadowRadius = 4
        titleView.layer.shadowOpacity = 0.3
        titleView.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleView.layer.shadowColor = UIColor.black.cgColor
        titleView.layer.masksToBounds = false
    }
    
    func setupNavigationBar() {
        let title = asset?.symbol ?? ""
        
        // left bar button
        let backButton = UIButton(type: UIButtonType.custom)
        backButton.setImage(#imageLiteral(resourceName: "BackButtonImage-white"), for: .normal)
        backButton.setImage(#imageLiteral(resourceName: "BackButtonImage-white").alpha(0.3), for: .highlighted)
        backButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -16, bottom: 0, right: 8)
        backButton.addTarget(self, action: #selector(pressedBackButton(_:)), for: UIControlEvents.touchUpInside)
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        var barButton = UIBarButtonItem(customView: backButton)
        let navigationLeftItem = UINavigationItem()
        navigationLeftItem.leftBarButtonItem = barButton
        let navigationItem = UINavigationItem()
        navigationItem.title = title
        navigationItem.leftBarButtonItem = barButton
        
        // right bar button
        let rightButton = UIButton(type: UIButtonType.custom)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: -16)
        rightButton.titleLabel?.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        if self.asset?.symbol.uppercased() == "WETH" {
            rightButton.setImage(#imageLiteral(resourceName: "Tokenest-more-button"), for: .normal)
            rightButton.setImage(#imageLiteral(resourceName: "Tokenest-more-button").alpha(0.3), for: .highlighted)
            rightButton.addTarget(self, action: #selector(pressedMoreButton(_:)), for: UIControlEvents.touchUpInside)
        } else if self.asset?.symbol.uppercased() == "ETH" {
            rightButton.title = "转换"
            rightButton.addTarget(self, action: #selector(pushConvertController), for: UIControlEvents.touchUpInside)
        } else {
            rightButton.title = "交易"
            rightButton.addTarget(self, action: #selector(pushTradeController), for: UIControlEvents.touchUpInside)
        }
        
        // navigation item
        barButton = UIBarButtonItem(customView: rightButton)
        navigationItem.rightBarButtonItem = barButton
        customizedNavigationBar.setItems([navigationItem], animated: false)
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Data
        getTransactionsFromRelay()
    }
    
    func getTransactionsFromRelay() {
        if let asset = asset {
            CurrentAppWalletDataManager.shared.getTransactionsFromServer(asset: asset) { (transactions, error) in
                guard error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    if self.isLaunching {
                        self.isLaunching = false
                    }
                    self.transactions = transactions
                    self.transactionDates = transactions.keys.sorted(by: >)
                    self.tableView.reloadData()
                    // self.tableView.reloadSections(IndexSet(integersIn: 1...1), with: .fade)
                    self.refreshControl.endRefreshing()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if !isLaunching {
            getTransactionsFromRelay()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func pushTradeController() {
        let viewController = TradeViewController()
        viewController.hidesBottomBarWhenPushed = false
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func pushConvertController() {
        let viewController = ConvertETHViewController()
        viewController.asset = self.asset
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @objc func pressedMoreButton(_ sender: UIBarButtonItem) {
        contextMenuSourceView.frame = CGRect(x: self.view.frame.width + 10, y: customizedNavigationBar.bottomY, width: 1, height: 1)
        view.addSubview(contextMenuSourceView)
        
        let titles = ["转换为ETH", "交易"]
        let menuViewController = AddMenuViewController(rows: 2, titles: titles)
        menuViewController.didSelectRowClosure = { (index) -> Void in
            if index == 0 {
                self.pushConvertController()
            } else if index == 1 {
                self.pushTradeController()
            }
        }
        ContextMenu.shared.show(
            sourceViewController: self,
            viewController: menuViewController,
            options: ContextMenu.Options(containerStyle: ContextMenu.ContainerStyle(backgroundColor: UIColor.white), menuStyle: .minimal),
            sourceView: contextMenuSourceView,
            delegate: self
        )
    }
    
    @IBAction func pressedSendButton(_ sender: Any) {
        print("pressedSendButton")
        let viewController = SendViewController()
        viewController.asset = self.asset!
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func pressedReceiveButton(_ sender: Any) {
        print("pressedReceiveButton")
        let viewController = QRCodeViewController()
        viewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.75)
        self.present(viewController, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionDates.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        headerView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: CGRect(x: 16, y: 7, width: view.frame.size.width, height: 25))
        headerLabel.textColor = UIColor.gray
        headerLabel.text = transactionDates[section]
        headerLabel.font = FontConfigManager.shared.getLabelSCFont(size: 14)
        headerLabel.textColor = UIColor.tokenestFailed
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions[transactionDates[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AssetTransactionTableViewCell.getHeight()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AssetTransactionTableViewCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: AssetTransactionTableViewCell.getCellIdentifier()) as? AssetTransactionTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("AssetTransactionTableViewCell", owner: self, options: nil)
            cell = nib![0] as? AssetTransactionTableViewCell
        }
        cell?.transaction = self.transactions[transactionDates[indexPath.section]]![indexPath.row]
        cell?.update()
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        let transaction = self.transactions[transactionDates[indexPath.section]]![indexPath.row]
        let vc = AssetTransactionDetailViewController()
        vc.transaction = transaction
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func contextMenuWillDismiss(viewController: UIViewController, animated: Bool) {
    }
    
    func contextMenuDidDismiss(viewController: UIViewController, animated: Bool) {
        contextMenuSourceView.removeFromSuperview()
    }
}
