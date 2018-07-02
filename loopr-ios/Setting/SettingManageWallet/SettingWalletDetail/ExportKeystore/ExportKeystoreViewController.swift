//
//  ExportKeystoreViewController.swift
//  loopr-ios
//
//  Created by xiaoruby on 7/1/18.
//  Copyright © 2018 Loopring. All rights reserved.
//

import UIKit

protocol ExportKeystoreViewControllerDelegate: class {
    func dismissExportKeystoreViewController()
}

class ExportKeystoreViewController: UIViewController {
    
    weak var delegate: ExportKeystoreViewControllerDelegate?
    
    private var keystore: String = ""
    
    @IBOutlet weak var exportViewBackground: UIView!
    
    let exportKeystoreSwipeViewController = ExportKeystoreSwipeViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .custom
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)

        setupExportViewBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setKeystore(_ keystore: String) {
        self.keystore = keystore
        exportKeystoreSwipeViewController.setKeystore(keystore)
    }
    
    func setupExportViewBackground() {
        exportKeystoreSwipeViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exportKeystoreSwipeViewController.view)
        let topConstraint = NSLayoutConstraint(item: exportKeystoreSwipeViewController.view, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: exportViewBackground, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 10)
        let bottomConstraint = NSLayoutConstraint(item: exportKeystoreSwipeViewController.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: exportViewBackground, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)

        let constraints: [NSLayoutConstraint] = [
            topConstraint,
            bottomConstraint,
            exportKeystoreSwipeViewController.view.leadingAnchor.constraint(equalTo: exportViewBackground.leadingAnchor),
            exportKeystoreSwipeViewController.view.trailingAnchor.constraint(equalTo: exportViewBackground.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        // exportKeystoreSwipeViewController.delegate = self
        
        exportKeystoreSwipeViewController.view.layer.cornerRadius = 7.5
        exportKeystoreSwipeViewController.view.clipsToBounds = true
        
        addChildViewController(exportKeystoreSwipeViewController)
    }

    @IBAction func pressedCloseButton(_ sender: Any) {
        delegate?.dismissExportKeystoreViewController()
        self.dismiss(animated: true, completion: nil)
    }
    
}
