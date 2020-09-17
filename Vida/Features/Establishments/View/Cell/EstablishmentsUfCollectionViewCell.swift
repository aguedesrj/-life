//
//  EstablishmentsUfCollectionViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class EstablishmentsUfCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let size: CGSize = viewMain.frame.size
        viewMain.layer.cornerRadius = size.height / 2
        
        viewMain.layer.borderColor = Color.primary.value.cgColor
        viewMain.layer.borderWidth = 2.0
    }

}
