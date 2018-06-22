//
//  UIViewController+TableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 6/17/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createDetailTableCell(title: String, detailTitle: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: title)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .blue
        cell.textLabel?.text = title
        cell.textLabel?.font = FontConfigManager.shared.getLabelENFont()
        cell.detailTextLabel?.text = detailTitle
        cell.detailTextLabel?.font = FontConfigManager.shared.getLabelENFont()
        return cell
    }

    func createDetailTableCell(title: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: title)
        cell.accessoryType = .detailButton
        cell.selectionStyle = .blue
        cell.textLabel?.text = title
        cell.textLabel?.font = FontConfigManager.shared.getLabelENFont()
        return cell
    }
    
    func createBasicTableCell(title: String, detailTitle: String) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: title)
        cell.accessoryType = .none
        cell.selectionStyle = .none
        cell.textLabel?.text = title
        cell.textLabel?.font = FontConfigManager.shared.getLabelENFont()
        cell.detailTextLabel?.text = detailTitle
        cell.detailTextLabel?.font = FontConfigManager.shared.getLabelENFont()
        return cell
    }

}
