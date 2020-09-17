//
//  InfoLifeFilterCollectionViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class InfoLifeFilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        viewMain.backgroundColor = UIColor.white
        viewMain.layer.cornerRadius = 12
        viewMain.layer.borderColor = Color.primary.value.cgColor
        viewMain.layer.borderWidth = 2
        
        if Device.isIPhone5() {
            labelTitle.font = UIFont(name: "OpenSans-Bold", size: 9)
        }
    }
    
    func setValuesFilter(name: String, image: UIImage?, selected: Bool) {
        imageViewIcon.image = nil
        if selected {
            viewMain.backgroundColor = Color.primary.value
            labelTitle.textColor = UIColor.white
            labelTitle.text = name.uppercased()
            if (image != nil) {
                imageViewIcon.image = image!.withRenderingMode(.alwaysTemplate)
                imageViewIcon.tintColor = UIColor.white
            }
        } else {
            viewMain.backgroundColor = UIColor.white
            labelTitle.textColor = Color.primary.value
            labelTitle.text = name.uppercased()
            if (image != nil) {
                imageViewIcon.image = image!.withRenderingMode(.alwaysTemplate)
                imageViewIcon.tintColor = Color.primary.value
            }
        }
    }
}
