//
//  SwitchTradeTokenViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/14/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

enum SwitchTradeTokenType {
    case tokenS
    case tokenB
}

class SwitchTradeTokenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var statusBarBackgroundView: UIView!
    @IBOutlet weak var customizedNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var isFiltering = false
    var searchText: String = ""
    var filteredTokens = [Token]()
    var type: SwitchTradeTokenType = .tokenS

    let searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBarBackgroundView.backgroundColor = GlobalPicker.themeColor

        setupSearchBar()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        setBackButtonAndUpdateTitle(customizedNavigationBar: customizedNavigationBar, title: LocalizedString("选择代币", comment: ""))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func setupSearchBar() {
        searchBar.showsCancelButton = false
        searchBar.placeholder = LocalizedString("Search", comment: "")
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        let searchBarContainer = SearchBarContainerView(customSearchBar: searchBar)
        searchBarContainer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 44)
        navigationItem.titleView = searchBarContainer
    }
    
    func getTokens() -> [Token] {
        let tokens = TradeDataManager.shared.tokenS
        let tokenb = TradeDataManager.shared.tokenB
        if self.type == .tokenB {
            return TokenDataManager.shared.getErcTokensExcept(for: tokens.symbol)
        } else {
            return TokenDataManager.shared.getErcTokensExcept(for: tokenb.symbol)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredTokens.count
        } else {
            return getTokens().count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SwitchTradeTokenTableViewCell.getHeight()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: SwitchTradeTokenTableViewCell.getCellIdentifier()) as? SwitchTradeTokenTableViewCell
        if cell == nil {
            let nib = Bundle.main.loadNibNamed("SwitchTradeTokenTableViewCell", owner: self, options: nil)
            cell = nib![0] as? SwitchTradeTokenTableViewCell
        }
        let token: Token
        if isFiltering {
            token = filteredTokens[indexPath.row]
        } else {
            token = getTokens()[indexPath.row]
        }
        cell?.token = token
        cell?.update()

        if (type == .tokenS && token.symbol == TradeDataManager.shared.tokenS.symbol) || (type == .tokenB && token.symbol == TradeDataManager.shared.tokenB.symbol) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let token: Token
        if isFiltering {
            token = filteredTokens[indexPath.row]
        } else {
            token = getTokens()[indexPath.row]
        }
        switch type {
        case .tokenS:
            TradeDataManager.shared.changeTokenS(token)
        case .tokenB:
            TradeDataManager.shared.changeTokenB(token)
        }
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - SearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("searchBar textDidChange \(searchText)")
        self.searchText = searchText.trim()
        if self.searchText != "" {
            isFiltering = true
            filterContentForSearchText(self.searchText)
        } else {
            isFiltering = false
            tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("searchBarSearchButtonClicked")
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidBeginEditing")
        self.searchText = searchText.trim()
        if self.searchText != "" {
            isFiltering = true
        } else {
            isFiltering = false
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.pressSearchCancel))
        searchBar.becomeFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing")
    }
    
    @objc func pressSearchCancel(_ button: UIBarButtonItem) {
        print("pressSearchCancel")
        self.navigationItem.rightBarButtonItem = nil
        searchBar.resignFirstResponder()
        searchBar.text = nil
        isFiltering = false
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredTokens = TokenDataManager.shared.getTokens().filter({(token: Token) -> Bool in
            if token.symbol.range(of: searchText, options: .caseInsensitive) != nil {
                return true
            } else {
                return false
            }
        })
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .fade)
    }

}
