//
//  ProfessionalsDetailViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class ProfessionalsDetailViewController: BaseViewController {

    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var viewPhone: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var buttonEmail: UIButton!
    @IBOutlet weak var buttonPhone: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var labelPhones: UILabel!
    @IBOutlet weak var labelHealthPlan: UILabel!
    
    var professional: Professional!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let borderWidth: CGFloat = 2
        let cornerRadiusViewButton: CGFloat = 12

        viewPhone.backgroundColor = UIColor.white
        viewEmail.backgroundColor = UIColor.white
        
        viewPhone.backgroundColor = UIColor.white
        viewPhone.layer.cornerRadius = cornerRadiusViewButton
        viewPhone.layer.borderColor = Color.primary.value.cgColor
        viewPhone.layer.borderWidth = borderWidth
        
        viewEmail.backgroundColor = UIColor.white
        viewEmail.layer.cornerRadius = cornerRadiusViewButton
        viewEmail.layer.borderColor = Color.primary.value.cgColor
        viewEmail.layer.borderWidth = borderWidth
        
        viewBackground.backgroundColor = Color.primary.value
        
        labelName.text = professional.name
        labelHealthPlan.text = professional.healthPlan
        labelDescription.text = "\(professional.healthSpecialty.name.uppercased()) EM \(professional.city.name.uppercased()) - \(professional.city.stateFederation.code.uppercased())"
        
        labelAddress.text = "\(professional.address), \(professional.district) - \(professional.city.name) - \(professional.city.stateFederation.code)"
        
        var phones: String = ""
        if (!professional.phone.isEmpty) {
            phones = professional.phone
        }
        if (!professional.phoneCell.isEmpty) {
            if (!phones.isEmpty) {
                phones = "\(phones) - \(professional.phoneCell)"
            } else {
                phones = "\(professional.phoneCell)"
            }
        }
        labelPhones.text = "\(phones)"
        
        imageViewPhoto.kf.setImage (
            with: URL(string: professional.linkPhoto),
            placeholder: UIImage(named: "iconPlaceholderDetailProf"),
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
                self.imageViewPhoto.contentMode = .scaleAspectFill
            case .failure(let error):
                print("Erro: \(error.localizedDescription)")
            }
        }
        
        if professional.phone == "" {
            buttonPhone.isHidden = true
        }
        
        if professional.email == "" {
            buttonEmail.isHidden = true
        }
        
        ProfessionalsPresenter.init().registerAccessProfessional()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressButtonPhone(_ sender: Any) {
        self.callPhone(phone: professional.phone)
    }
    
    @IBAction func pressButtonEmail(_ sender: Any) {
        self.sendMail(email: professional.email)
    }
}
