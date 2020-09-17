//
//  PartnersCollectionViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class PartnersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageViewPartners: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setValues(partnersViewModel: PartnersViewModel) {
        labelTitle.text = partnersViewModel.title
        labelDescription.text = partnersViewModel.description
        imageViewPartners.image = UIImage(named: partnersViewModel.image)
    }
}
