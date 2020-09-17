//
//  StoresPartnerTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView

class StoresPartnerTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var labelDiscount: UILabel!
    @IBOutlet weak var labelNameEstablishments: UILabel!
    @IBOutlet weak var viewMain: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 14.0
    }
    
    func setValues(establishments: Establishments) {
        labelDiscount.hideSkeleton()
        labelNameEstablishments.hideSkeleton()
        imageViewLogo.hideSkeleton()
        
        labelNameEstablishments.text = establishments.name
        labelDiscount.text = "\(establishments.discount.percentage)% de"
        
        imageViewLogo.kf.indicatorType = .activity
        imageViewLogo.kf.setImage(
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
    }
}

extension StoresPartnerTableViewCell {
    func realoadSkeletonView() {
        super.awakeFromNib()
        
        isSkeletonable = true
        imageViewLogo.showAnimatedGradientSkeleton()
        labelDiscount.showAnimatedGradientSkeleton()
        labelNameEstablishments.showAnimatedGradientSkeleton()
    }
}
