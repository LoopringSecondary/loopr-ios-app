//
//  QRCodeViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 2/25/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit
import Social
import NotificationBannerSwift

class QRCodeViewController: UIViewController {
    
    var qrcodeImage: UIImage!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyAddressButton: UIButton!
    @IBOutlet weak var saveToAlbumButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.theme_backgroundColor = GlobalPicker.textColor
        addressLabel.theme_textColor = GlobalPicker.textColor
        addressLabel.font = FontConfigManager.shared.getLabelFont(size: 12)
        saveToAlbumButton.setTitle(NSLocalizedString("Save to Album", comment: ""), for: .normal)
        saveToAlbumButton.setupRoundPurple()
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address
        addressLabel.text = address
        let data = address?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        copyAddressButton.layer.shadowColor = UIColor.black.cgColor
        copyAddressButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        copyAddressButton.layer.shadowOpacity = 0.3
        copyAddressButton.layer.shadowRadius = 4
        copyAddressButton.clipsToBounds = false
        generateQRCode(from: data!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        qrcodeImageView.image = qrcodeImage
    }
    
    func generateQRCode(from data: Data) {
        let ciContext = CIContext()
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            let upScaledImage = filter.outputImage?.transformed(by: transform)
            let cgImage = ciContext.createCGImage(upScaledImage!, from: upScaledImage!.extent)
            qrcodeImage = UIImage(cgImage: cgImage!)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func pressedCopyAddressButton(_ sender: UIButton) {
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address
        print("pressedCopyAddressButton address: \(address)")
        UIPasteboard.general.string = address
        let banner = NotificationBanner.generate(title: "Copy address to clipboard successfully!", style: .success)
        banner.duration = 1
        banner.show()
    }
    
    @IBAction func pressedSaveToAlbum(_ sender: Any) {
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()!.address
        print("pressedSaveToAlbum address: \(address)")
        QRCodeSaveToAlbum.shared.save(image: qrcodeImage)
    }
    
    @IBAction func pressedCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
