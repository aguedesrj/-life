//
//  EstablishmentsDetailViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import Atributika
import SkeletonView
import SafariServices

class EstablishmentsDetailViewController: BaseViewController {

    @IBOutlet weak var labelDescriptionScanQrCode: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewEstablishments: UIImageView!
    @IBOutlet weak var labelDescriptionEstablishments: UILabel!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var viewSite: UIView!
    @IBOutlet weak var constraintHeightImageViewLocation: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImageViewLocation: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightImageViewPhone: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImageViewPhone: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightImageViewEmail: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImageViewEmail: NSLayoutConstraint!
    @IBOutlet weak var constraintHeightImageViewSite: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImageViewSite: NSLayoutConstraint!
    @IBOutlet weak var viewButtonQrCode: GradientView!
    @IBOutlet weak var labelPhone: UILabel!
    
    var establishments: Establishments!
    var viewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let size: CGSize = viewButtonQrCode.frame.size
        viewButtonQrCode.layer.cornerRadius = size.height / 2
        
        let borderWidth: CGFloat = 2
        let cornerRadiusViewButton: CGFloat = 12
        let constraintImageView: CGFloat = 30.0
        
        if Device.isIPhone5() {
            constraintHeightImageViewLocation.constant = constraintImageView
            constraintWidthImageViewLocation.constant = constraintImageView
            
            constraintHeightImageViewPhone.constant = constraintImageView
            constraintWidthImageViewPhone.constant = constraintImageView
            
            constraintHeightImageViewEmail.constant = constraintImageView
            constraintWidthImageViewEmail.constant = constraintImageView
            
            constraintHeightImageViewSite.constant = constraintImageView
            constraintWidthImageViewSite.constant = constraintImageView
        }
        
        viewLocation.backgroundColor = UIColor.white
        viewLocation.layer.cornerRadius = cornerRadiusViewButton
        viewLocation.layer.borderColor = Color.primary.value.cgColor
        viewLocation.layer.borderWidth = borderWidth
        
        viewPhone.backgroundColor = UIColor.white
        viewPhone.layer.cornerRadius = cornerRadiusViewButton
        viewPhone.layer.borderColor = Color.primary.value.cgColor
        viewPhone.layer.borderWidth = borderWidth
        
        viewEmail.backgroundColor = UIColor.white
        viewEmail.layer.cornerRadius = cornerRadiusViewButton
        viewEmail.layer.borderColor = Color.primary.value.cgColor
        viewEmail.layer.borderWidth = borderWidth
        
        viewSite.backgroundColor = UIColor.white
        viewSite.layer.cornerRadius = cornerRadiusViewButton
        viewSite.layer.borderColor = Color.primary.value.cgColor
        viewSite.layer.borderWidth = borderWidth

        labelDescriptionScanQrCode.text = "\(establishments.discount.percentage)% de Desconto"
        labelTitle.text = establishments.name
//        labelAddress.text = "ESTABELECIMENTO EM \(establishments.city.name.uppercased()) - \(establishments.stateFederation.code.uppercased())"
        
        labelAddress.text = "\(establishments.address), \(establishments.district) - \(establishments.city.name) - \(establishments.city.stateFederation.code)"
        
        var phones: String = ""
        if (!establishments.phone.isEmpty) {
            phones = establishments.phone
        }
        if (!establishments.phoneCell.isEmpty) {
            if (!phones.isEmpty) {
                phones = "\(phones) - \(establishments.phoneCell)"
            } else {
                phones = "\(establishments.phoneCell)"
            }
        }
        labelPhone.text = "\(phones)"
        
        imageViewEstablishments.kf.setImage(
            with: URL(string: establishments.urlImage),
            placeholder: UIImage(named: "imageCardPlaceholder"),
            options: [
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(Constrants.kTransitionFadeImage)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Sucesso: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Erro: \(error.localizedDescription)")
            }
        }
        
//        let style = Style
//            .font(UIFont(name: "OpenSans-SemiBold", size: 14)!)
//            .foregroundColor(UIColor(red: 80.0/255.0,
//                                     green: 80.0/255.0,
//                                     blue: 80.0/255.0,
//                                     alpha: 1.0))
        
        labelDescriptionEstablishments.attributedText = establishments.text //establishments.debugDescription
//            .styleAll(style)
            .attributedString
        
        viewLocation.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(self.handleLocation(_:))))
        viewPhone.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(self.handlePhone(_:))))
        viewEmail.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(self.handleEmail(_:))))
        viewSite.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                             action: #selector(self.handleWebSite(_:))))
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        if viewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func pressButtonScanQrCode(_ sender: Any) {
        if viewController != nil {
            EstablishmentsRouter().showQRCode(at: self, establishments: establishments)
        } else {
            EstablishmentsRouter().showQRCode(at: appDelegate.navController!, establishments: establishments)
        }
    }
}

extension EstablishmentsDetailViewController {
    
    @objc func handleLocation(_ sender: UITapGestureRecognizer? = nil) {
        if (!establishments.address.isEmpty) {
            var address: String = establishments.address
            if (!establishments.district.isEmpty) {
                address = "\(address),\(establishments.district)"
            }
            if (!establishments.city.name.isEmpty) {
                address = "\(address),\(establishments.city.name)"
            }
            if (!establishments.stateFederation.name.isEmpty) {
                address = "\(address),\(establishments.stateFederation.code)"
            }
            
            address = address.replacingOccurrences(of: " ", with: "+")
            
            // browser
            let stringUrl: String = "https://www.google.com.br/maps?q=\(Util.replaceCaracterSpecial(value: address.removeCharactersSpecialForOpenWebSite))"
            
            UIApplication.shared.open(URL(string: stringUrl)!, options: [:], completionHandler: nil)
        }
    }
    
    @objc func handlePhone(_ sender: UITapGestureRecognizer? = nil) {
        if (!establishments.phone.isEmpty) {
            self.callPhone(phone: establishments.phone)
        }
    }
    
    @objc func handleEmail(_ sender: UITapGestureRecognizer? = nil) {
        if (!establishments.email.isEmpty) {
            self.sendMail(email: establishments.email)
        }
    }
    
    @objc func handleWebSite(_ sender: UITapGestureRecognizer? = nil) {
        if (!establishments.webSite.isEmpty) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            var safariView: SFSafariViewController!
            if establishments.webSite.contains("http") {
                safariView = SFSafariViewController(url: URL(string: establishments.webSite)!,
                                                    configuration: config)
            } else {
                safariView = SFSafariViewController(url: URL(string: "http://\(establishments.webSite)")!, configuration: config)
            }
            present(safariView, animated: true)
        }
    }
}
