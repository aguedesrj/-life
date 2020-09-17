//
//  TutorialDetailTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class TutorialDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelTitle.textColor = .white
        labelDescription.textColor = .white
    }

    func setValues(tutorialCardDetail: TutorialCardDetail, indexSelected: Int) {
        imageViewTitle.image = UIImage(named: tutorialCardDetail.nameImageDetail)
        labelTitle.text = tutorialCardDetail.title
        labelDescription.text = tutorialCardDetail.description
    }
}
