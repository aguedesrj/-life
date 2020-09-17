//
//  EstablishmentsQRCodeViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class EstablishmentsQRCodeViewController: BaseViewController {

    @IBOutlet weak var viewQrCode: UIView!
    @IBOutlet weak var viewQrCodeSub: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewQrCode: UIImageView!
    @IBOutlet weak var labelQrCode: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var labelDescriptionDiscount: UILabel!
    @IBOutlet weak var imageViewLogoEstablishments: UIImageView!
    @IBOutlet weak var imageViewBgQrCode: UIImageView!
    @IBOutlet weak var labelNameEstablishments: UILabel!
    @IBOutlet weak var buttonClose: UIButton!
    
    var establishments: Establishments!
    var viewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonClose.imageView?.tintColor = UIColor.white
        
        viewQrCode.layer.cornerRadius = 25
        
        viewQrCodeSub.layer.cornerRadius = 25
        viewQrCodeSub.layer.shadowColor = UIColor(red: 98.0/255.0, green:  19.0/255.0, blue:  109.0/255.0, alpha: 1.0).cgColor
        viewQrCodeSub.layer.shadowOpacity = 1
        viewQrCodeSub.layer.shadowOffset = CGSize.zero
        viewQrCodeSub.layer.shadowRadius = 8
        
        imageViewBgQrCode.layer.cornerRadius = 25
        viewQrCodeSub.layer.borderWidth = 1
        viewQrCodeSub.layer.borderColor = UIColor(red: 98.0/255.0, green:  19.0/255.0, blue:  109.0/255.0, alpha: 1.0).cgColor

        labelQrCode.text = establishments.code
        var qrCode = QRCode(establishments.code)
        qrCode!.color = CIColor(red: 80.0/255.0, green:  80.0/255.0, blue:  80.0/255.0, alpha: 1.0)
        imageViewQrCode.image = qrCode!.image
        
        labelDiscount.text = "\(establishments.discount.percentage)% de"
        labelDescriptionDiscount.text = "Desconto"
        
        labelNameEstablishments.text = establishments.name
    }
    
    @IBAction func pressButtonClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
