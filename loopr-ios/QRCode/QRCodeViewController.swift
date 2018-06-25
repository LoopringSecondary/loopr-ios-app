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

protocol QRCodeViewControllerDelegate: class {
    func dismissQRCodeViewController()
}

class QRCodeViewController: UIViewController {
    
    weak var delegate: QRCodeViewControllerDelegate?

    var qrcodeImage: UIImage!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyAddressButton: UIButton!
    @IBOutlet weak var saveToAlbumButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        view.theme_backgroundColor = GlobalPicker.textColor
        addressLabel.theme_textColor = GlobalPicker.textColor
        addressLabel.font = FontConfigManager.shared.getLabelENFont(size: 12)
        
        copyAddressButton.layer.shadowColor = UIColor.black.cgColor
        copyAddressButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        copyAddressButton.layer.shadowRadius = 4
        copyAddressButton.clipsToBounds = false

        saveToAlbumButton.setTitle(NSLocalizedString("Save to Album", comment: ""), for: .normal)
        saveToAlbumButton.layer.shadowColor = UIColor.tokenestBackground.cgColor
        saveToAlbumButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        saveToAlbumButton.layer.shadowRadius = 4
        saveToAlbumButton.clipsToBounds = false
        
        let address = CurrentAppWalletDataManager.shared.getCurrentAppWallet()?.address
        addressLabel.text = address
        let data = address?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
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
        delegate?.dismissQRCodeViewController()
        self.dismiss(animated: true, completion: nil)
    }
}
