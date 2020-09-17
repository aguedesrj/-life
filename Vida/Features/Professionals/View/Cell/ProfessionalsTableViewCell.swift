//
//  ProfessionalsTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

class ProfessionalsTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecialty: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewSee: UIImageView!
    @IBOutlet weak var viewReference: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewReference.layer.cornerRadius = 8.0
        imageViewPhoto.backgroundColor = Color.primary.value
        imageViewPhoto.layer.cornerRadius = 8.0
        if #available(iOS 11.0, *) {
            imageViewPhoto.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        imageViewPhoto.layer.masksToBounds = true
        
        labelName.textColor = Color.primary.value
        labelName.linesCornerRadius = 6
        labelSpecialty.linesCornerRadius = 6
        labelAddress.linesCornerRadius = 6
        
        self.realoadSkeletonView()
    }

    func setValues(professional: Professional) {
        labelName.hideSkeleton()
        labelSpecialty.hideSkeleton()
        labelAddress.hideSkeleton()
        imageViewPhoto.hideSkeleton()
        imageViewSee.isHidden = false
        
        labelName.text = professional.name
        labelSpecialty.text = professional.healthSpecialty.name.uppercased()
        labelAddress.text = "\(professional.city.name) - \(professional.city.stateFederation.code)"
        
        imageViewPhoto.kf.indicatorType = .activity
        imageViewPhoto.kf.setImage(
            with: URL(string: professional.linkPhoto),
            placeholder: UIImage(named: "iconPlaceholderListProf"),
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
    }
}

extension ProfessionalsTableViewCell {
    func realoadSkeletonView() {
        super.awakeFromNib()
        
        isSkeletonable = true
        imageViewPhoto.showAnimatedGradientSkeleton()
        labelName.showAnimatedGradientSkeleton()
        labelSpecialty.showAnimatedGradientSkeleton()
        labelAddress.showAnimatedGradientSkeleton()
        imageViewSee.isHidden = true
    }
}
