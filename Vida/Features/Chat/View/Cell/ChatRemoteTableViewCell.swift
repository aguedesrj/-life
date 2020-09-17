//
//  ChatRemoteTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class ChatRemoteTableViewCell: UITableViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelMessage: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.backgroundColor = Color.primary.value
        viewMain.layer.cornerRadius = 12
        
        labelMessage.preferredMaxLayoutWidth = (UIScreen.main.bounds.width * 70) / 100
    }
}
