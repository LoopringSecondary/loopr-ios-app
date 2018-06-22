//
//  AssetDetailViewController.swift
//  loopr-ios
//
//  Created by Xiao Dou Dou on 2/3/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AssetDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    
    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var typeButton: UIButton!
    
    var asset: Asset?
    var isLaunching: Bool = true
    
    var transactions: [String: [Transaction]] = [:]
    var transactionDates: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var receiveButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var buttonHeightLayoutConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: asset?.symbol ?? "")
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
        receiveButton.setTitle(NSLocalizedString("Receive", comment: ""), for: .normal)
        receiveButton.setupRoundBlack(height: 40)
        
        // Send button
        sendButton.setTitle(NSLocalizedString("Send", comment: ""), for: .normal)
        sendButton.setupRoundBlack(height: 40)
        
        buttonHeightLayoutConstraint.constant = 40
        
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
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if !isLaunching {
            getTransactionsFromRelay()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func pressedSendButton(_ sender: Any) {
        print("pressedSendButton")
        let viewController = SendAssetViewController()
        viewController.asset = self.asset!
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    @IBAction func pressedReceiveButton(_ sender: Any) {
        print("pressedReceiveButton")
        let viewController = QRCodeViewController()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return transactionDates.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        headerView.backgroundColor = UIColor.white
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
        headerLabel.textColor = UIColor.gray
        headerLabel.text = transactionDates[section]
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
}
