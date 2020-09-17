//
//  EstablishmentsCollectionViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView

protocol EstablishmentsCollectionViewProtocol {
    func callEstablishmentsDetail(establishments: Establishments)
    func callGetImage(image: UIImage, indexSelected: Int)
}

class EstablishmentsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var labelAddress: UILabel!
    @IBOutlet weak var imageViewSeeAll: UIImageView!
    
    var delegate: EstablishmentsCollectionViewProtocol!
    
    fileprivate var establishments: Establishments!
    
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
        
        labelAddress.isHidden = true
        imageViewSeeAll.isHidden = true
        
        imageView.layer.cornerRadius = 12
        if #available(iOS 11.0, *) {
            imageView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
        imageView.layer.masksToBounds = true
        
        labelTitle.linesCornerRadius = 6
        labelDescription.linesCornerRadius = 6
        
        self.realoadSkeletonView()
    }
    
    @IBAction func pressButtonItemSelected(_ sender: Any) {
        if !self.labelAddress.isHidden {
            delegate.callEstablishmentsDetail(establishments: self.establishments)
        }
    }
    
    func setValuesViews(establishments: Establishments, indexSelected: Int) {
        self.establishments = establishments
        self.valueViews(establishments: self.establishments)
        imageView.kf.setImage(
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

    fileprivate func realoadSkeletonView() {
        super.awakeFromNib()
        
        isSkeletonable = true
        imageView.isSkeletonable = true
        labelTitle.isSkeletonable = true
        labelDescription.isSkeletonable = true
        
        viewMain.showAnimatedGradientSkeleton()
    }
}

extension EstablishmentsCollectionViewCell {
    
    fileprivate func valueViews(establishments: Establishments) {
        self.imageView.hideSkeleton()
        self.labelTitle.hideSkeleton()
        self.labelDescription.hideSkeleton()
        
        self.labelTitle.text = establishments.name
        self.labelDescription.text = "\(establishments.discount.percentage)% de desconto"
        self.labelAddress.text = "\(establishments.city.name.uppercased()) - \(establishments.stateFederation.code.uppercased())"
        
        self.labelAddress.isHidden = false
        self.imageViewSeeAll.isHidden = false
    }
}
