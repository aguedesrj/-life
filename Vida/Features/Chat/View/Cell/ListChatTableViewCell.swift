//
//  ListChatTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView
import Kingfisher

class ListChatTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPhoto: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelSpecialty: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var imageViewSee: UIImageView!
    @IBOutlet weak var viewReference: UIView!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var constraintLeftLabelStatus: NSLayoutConstraint!
    
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
        labelStatus.linesCornerRadius = 6
        
        viewStatus.layer.cornerRadius = 4.0
        
        self.realoadSkeletonView()
    }
    
    func setValues(chatUserViewModel: ListChatUserViewModel) {
        labelName.hideSkeleton()
        labelSpecialty.hideSkeleton()
        labelStatus.hideSkeleton()
        imageViewPhoto.hideSkeleton()
        imageViewSee.isHidden = false
        
        labelName.text = chatUserViewModel.name
        labelSpecialty.text = chatUserViewModel.healthSpecialty.uppercased()
        labelStatus.text = "Online"
        labelStatus.textColor = UIColor.white
        viewStatus.backgroundColor = UIColor(red: 41.0/255.0, green: 144.0/255.0, blue: 52.0/255.0, alpha: 1.0)
        constraintLeftLabelStatus.constant = 6.0
        if !chatUserViewModel.online {
            labelStatus.text = "Offline"
            labelStatus.textColor =  UIColor(red: 169.0/255.0, green: 169.0/255.0, blue: 169.0/255.0, alpha: 1.0)
            viewStatus.backgroundColor = UIColor.white
            constraintLeftLabelStatus.constant = 0.0
        }

        imageViewPhoto.kf.indicatorType = .activity
        imageViewPhoto.kf.setImage(
            with: URL(string: chatUserViewModel.urlPhoto),
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

extension ListChatTableViewCell {
    func realoadSkeletonView() {
        super.awakeFromNib()
        
        isSkeletonable = true

        imageViewPhoto.showAnimatedGradientSkeleton()
        labelName.showAnimatedGradientSkeleton()
        labelSpecialty.showAnimatedGradientSkeleton()
        labelStatus.showAnimatedGradientSkeleton()
        imageViewSee.isHidden = true
    }
}
