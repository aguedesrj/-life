//
//  ScanQrCodeVerifiedViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class ScanQrCodeVerifiedViewController: BaseViewController {
    
    @IBOutlet weak var viewQrCode: UIView!
    @IBOutlet weak var viewQrCodeSub: UIView!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var imageViewLogoEstablishments: UIImageView!
    @IBOutlet weak var imageViewBgQrCode: UIImageView!
    @IBOutlet weak var labelNameEstablishments: UILabel!
    @IBOutlet weak var imageViewPhotoUser: UIImageView!
    @IBOutlet weak var labelNameUser: UILabel!
    @IBOutlet weak var labelOfficeUser: UILabel!
    
    var establishments: Establishments!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewQrCode.layer.cornerRadius = 25
        let sizeImageViewPhotoUser: CGSize = imageViewPhotoUser.bounds.size
        imageViewPhotoUser.layer.cornerRadius = sizeImageViewPhotoUser.width / 2
        
        viewQrCodeSub.layer.cornerRadius = 25
        viewQrCodeSub.layer.shadowColor = UIColor(red: 98.0/255.0, green:  19.0/255.0, blue:  109.0/255.0, alpha: 1.0).cgColor
        viewQrCodeSub.layer.shadowOpacity = 1
        viewQrCodeSub.layer.shadowOffset = CGSize.zero
        viewQrCodeSub.layer.shadowRadius = 8
        
        imageViewBgQrCode.layer.cornerRadius = 25
        viewQrCodeSub.layer.borderWidth = 1
        viewQrCodeSub.layer.borderColor = UIColor(red: 98.0/255.0, green:  19.0/255.0, blue:  109.0/255.0, alpha: 1.0).cgColor
        
        labelNameUser.text = self.appDelegate.login?.user?.name
        labelOfficeUser.text = self.appDelegate.login?.user?.typeProfile.capitalized
        
        labelDiscount.text = "\(establishments.discount.percentage)% de Desconto autorizado!"
        labelNameEstablishments.text = establishments.name
        
        changeImageViewPhoto()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ScanQrCodeVerifiedViewController {
    
    fileprivate func changeImageViewPhoto() {
        let sizeImageViewLogged: CGSize = imageViewPhotoUser.frame.size
        imageViewPhotoUser.layer.cornerRadius = sizeImageViewLogged.width / 2
        imageViewPhotoUser.layer.borderColor = UIColor.white.cgColor
        imageViewPhotoUser.layer.borderWidth = 2
        imageViewPhotoUser.layer.masksToBounds = true
        imageViewPhotoUser.tintColor = Color.primary.value
        
        if self.appDelegate.login != nil && self.appDelegate.login?.user != nil {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                let filename: String = "\((self.appDelegate.login?.user!.id)!).png"
                let imagePhoto: UIImage? = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(filename).path)
                if (imagePhoto != nil) {
                    imageViewPhotoUser.image = imagePhoto
                }
            }
        }
    }
}
