//
//  AssetTransactionTableViewCell.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/18/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class AssetTransactionTableViewCell: UITableViewCell {

    var transaction: Transaction?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLabel.font = FontConfigManager.shared.getLabelSCFont(size: 16)
        amountLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        dateLabel.font = FontConfigManager.shared.getLabelENFont(size: 16)
        statusLabel.font = FontConfigManager.shared.getLabelSCFont(size: 16)
    }
    
    func update() {
        if let transaction = transaction {
            switch transaction.type {
            case .convert_income:
                updateConvertIncome()
            case .convert_outcome:
                updateConvertOutcome()
            case .approved:
                updateApprove()
            case .cutoff, .canceledOrder:
                udpateCutoffAndCanceledOrder()
            default:
                updateDefault()
            }
            updateDateLabel()
            updateStatusLabel()
            titleLabel.text = transaction.type.description
        }
    }
    
    private func updateConvertIncome() {
        amountLabel.text = "+\(transaction!.value)"
        amountLabel.textColor = UIColor.tokenestUps
    }
    
    private func updateConvertOutcome() {
        amountLabel.text = "-\(transaction!.value)"
        amountLabel.textColor = UIColor.tokenestDowns
    }
    
    private func updateApprove() {
        let gas = GasDataManager.shared.getGasAmountInETH(by: "approve")
        amountLabel.text = "-\(gas.withCommas(6))"
        amountLabel.textColor = UIColor.tokenestDowns
    }
    
    private func udpateCutoffAndCanceledOrder() {
        let gas = GasDataManager.shared.getGasAmountInETH(by: "cancelOrder")
        amountLabel.text = "-\(gas.withCommas(6))"
        amountLabel.textColor = UIColor.tokenestDowns
    }
    
    private func updateDefault() {
        if let tx = self.transaction {
            if tx.type == .bought || tx.type == .received {
                amountLabel.textColor = UIColor.tokenestUps
                amountLabel.text = "+\(transaction!.value)"
            } else if tx.type == .sold || tx.type == .sent {
                amountLabel.textColor = UIColor.tokenestDowns
                amountLabel.text = "-\(transaction!.value)"
            }
        }
    }
    
    private func updateDateLabel() {
        if let tx = self.transaction {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "HH:mm MM/dd"
            if let date = dateFormatterGet.date(from: tx.createTime) {
                dateLabel.text = dateFormatterPrint.string(from: date)
            }
        }
    }
    
    private func updateStatusLabel() {
        if let tx = self.transaction {
            if tx.status == .success {
                statusLabel.textColor = UIColor.tokenestBackground
            } else if tx.status == .failed {
                statusLabel.textColor = UIColor.tokenestFailed
            } else if tx.status == .pending {
                statusLabel.textColor = UIColor.tokenestPending
            }
            statusLabel.text = tx.status.description
        }
    }

    class func getCellIdentifier() -> String {
        return "AssetTransactionTableViewCell"
    }

    class func getHeight() -> CGFloat {
        return 72
    }
}
