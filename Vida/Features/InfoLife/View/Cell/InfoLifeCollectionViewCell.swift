//
//  InfoLifeCollectionViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView

protocol InfoLifeCollectionViewProtocol {
    func callInfoLifeDetail(infoLife: InfoLife)
    func callGetImage(image: UIImage, indexSelected: Int)
}

class InfoLifeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelSeeAll: UILabel!
    @IBOutlet weak var imageViewSeeAll: UIImageView!
    
    var delegate: InfoLifeCollectionViewProtocol!
    
    fileprivate var infoLife: InfoLife!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Device.isIPhone5() {
            var sizeLabelTitle: CGSize = labelTitle.frame.size
            var sizeLabelDescription: CGSize = labelDescription.frame.size
            sizeLabelTitle.width -= 50.0
            sizeLabelDescription.width -= 50.0
            labelTitle.frame.size = sizeLabelTitle
            labelDescription.frame.size = sizeLabelDescription
        }
        
        imageView.layer.cornerRadius = 12
        if #available(iOS 11.0, *) {
            imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        imageView.layer.masksToBounds = true
        
        labelTitle.linesCornerRadius = 6
        labelDescription.linesCornerRadius = 6
        
        labelTitle.text = ""
        labelDescription.text = ""
        
        self.realoadSkeletonView()
    }
    
    @IBAction func pressButtonItemSelected(_ sender: Any) {
        if !self.labelSeeAll.isHidden {
            delegate.callInfoLifeDetail(infoLife: self.infoLife)
        }
    }
    
    func setValuesViews(infoLife: InfoLife, indexSelected: Int) {
        self.infoLife = infoLife
        
        self.valueViews(infoLife: infoLife)
        imageView.kf.setImage(
            with: URL(string: infoLife.urlImageDetach),
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

    func realoadSkeletonView() {
        super.awakeFromNib()
        
        isSkeletonable = true
        imageView.showAnimatedGradientSkeleton()
        labelSeeAll.isHidden = true
        imageViewSeeAll.isHidden = true
    }
}

extension InfoLifeCollectionViewCell {
    
    fileprivate func valueViews(infoLife: InfoLife) {
        self.imageView.hideSkeleton()
        
        self.labelTitle.text = infoLife.title
        self.labelDescription.text = infoLife.shortText
        
        self.labelSeeAll.isHidden = false
        self.imageViewSeeAll.isHidden = false
    }
}
