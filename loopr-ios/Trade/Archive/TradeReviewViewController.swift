//
//  TradeConfirmationViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 3/13/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

class TradeReviewViewController: UIViewController {

    @IBOutlet weak var statusBar: UIView!
    @IBOutlet weak var customNavBar: UINavigationBar!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareOrderButton: UIButton!

    var tokenSView: TradeTokenView!
    var tokenBView: TradeTokenView!
    var arrowRightImageView: UIImageView = UIImageView()
    var qrcodeImageView: UIImageView!
    
    // To display QR code
    var qrcodeImageCIImage: CIImage!
    
    // To share QR code
    var qrcodeImage: UIImage!

    var order: OriginalOrder?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        statusBar.backgroundColor = GlobalPicker.themeColor
        setBackButtonAndUpdateTitle(customizedNavigationBar: customNavBar, title: "订单详情")

        // Setup UI in the scroll view
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        // let screenHeight = screensize.height
        
        let paddingY: CGFloat = 20
        let paddingTop: CGFloat = 30
        let padding: CGFloat = 15

        // QR code
        let qrCodeWidth: CGFloat = screenWidth*0.53*UIStyleConfig.scale
        qrcodeImageView = UIImageView(frame: CGRect(center: CGPoint(x: screenWidth/2, y: paddingTop + qrCodeWidth*0.5), size: CGSize(width: qrCodeWidth, height: qrCodeWidth)))
        scrollView.addSubview(qrcodeImageView)
        
        let tokenViewMinY: CGFloat = qrcodeImageView.frame.maxY + paddingY
        tokenSView = TradeTokenView(frame: CGRect(x: 10, y: tokenViewMinY, width: (screenWidth-30)/2, height: 180*UIStyleConfig.scale))
        scrollView.addSubview(tokenSView)
        
        tokenBView = TradeTokenView(frame: CGRect(x: (screenWidth+10)/2, y: tokenViewMinY, width: (screenWidth-30)/2, height: 180*UIStyleConfig.scale))
        scrollView.addSubview(tokenBView)
        
        arrowRightImageView = UIImageView(frame: CGRect(center: CGPoint(x: screenWidth/2, y: tokenBView.frame.minY + tokenBView.iconImageView.frame.midY), size: CGSize(width: 32*UIStyleConfig.scale, height: 32*UIStyleConfig.scale)))
        arrowRightImageView.image = UIImage.init(named: "Arrow-right-black")
        scrollView.addSubview(arrowRightImageView)

        scrollView.contentSize = CGSize(width: screenWidth, height: tokenBView.frame.maxY + padding)
        
        shareOrderButton.title = LocalizedString("Share Order", comment: "")
        shareOrderButton.setupRoundPurpleWithShadow()
        
        NotificationCenter.default.addObserver(self, selector: #selector(orderResponseReceivedNotification), name: .orderResponseReceived, object: nil)
    }

    @objc func orderResponseReceivedNotification() {
        let vc = TradeCompleteViewController()
        vc.order = self.order
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        guard let order = self.order else { return }
        // self.navigationController?.isNavigationBarHidden = false
        tokenSView.update(title: "You send", symbol: order.tokenSell, amount: order.amountSell)
        tokenBView.update(title: "You get", symbol: order.tokenBuy, amount: order.amountBuy)
        generateQRCode(order: order)
        qrcodeImageView.image = qrcodeImage
        
        // Remove the blur effect
        let scaleX = qrcodeImageView.frame.size.width / qrcodeImageCIImage.extent.size.width
        let scaleY = qrcodeImageView.frame.size.height / qrcodeImageCIImage.extent.size.height
        let transformedImage = qrcodeImageCIImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrcodeImageView.image = UIImage.init(ciImage: transformedImage)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func generateQRCode(order: OriginalOrder) {
        let hash = order.hash + TradeDataManager.seperator
        var data = hash.data(using: .isoLatin1, allowLossyConversion: false)!
        let authPrivateKey = order.authPrivateKey.data(using: .isoLatin1, allowLossyConversion: false)!
        data.append(authPrivateKey)
        let ciContext = CIContext()
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let upScaledImage = filter.outputImage?.transformed(by: transform)
            qrcodeImageCIImage = upScaledImage!
            let cgImage = ciContext.createCGImage(upScaledImage!, from: upScaledImage!.extent)
            qrcodeImage = UIImage(cgImage: cgImage!)
        }
    }

    @IBAction func pressedShareButton(_ sender: UIButton) {
        let text = LocalizedString("My Trade from Loopr-iOS", comment: "")
        let png = UIImagePNGRepresentation(qrcodeImage)
        let shareAll = [text, png!] as [Any]
        let activityVC = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
}
