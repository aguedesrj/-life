//
//  TutorialCardTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class TutorialCardTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewTitle: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if Device.isIPhone5() {
            labelTitle.font = labelTitle.font.withSize(11)
        }
    }

    func setValues(tutorialCardDetail: TutorialCardDetail) {
        imageViewTitle.image = UIImage(named: tutorialCardDetail.nameImage)
        labelTitle.text = tutorialCardDetail.title
    }
}
