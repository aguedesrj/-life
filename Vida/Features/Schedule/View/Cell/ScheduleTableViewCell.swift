//
//  ScheduleTableViewCell.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView

protocol ScheduleTableViewCellDelegate {
    func callPhone(numberPhone: String)
}

class ScheduleTableViewCell: UITableViewCell {

    @IBOutlet weak var viewGradient: GradientView!
    @IBOutlet weak var labelMonth: UILabel!
    @IBOutlet weak var labelDay: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelHour: UILabel!
    @IBOutlet weak var constraintHeightViewTop: NSLayoutConstraint!
    @IBOutlet weak var viewSkeleton: UIView!
    @IBOutlet weak var labelCategory: UILabel!
    
    var delegate: ScheduleTableViewCellDelegate!
    
    fileprivate var schedule: ScheduleViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelDay.textColor = Color.primary.value
        labelName.textColor = Color.primary.value
        labelHour.textColor = Color.second.value
        labelCategory.textColor = UIColor(red: 169.0/255.0,
                                          green: 169.0/255.0,
                                          blue: 169.0/255.0,
                                          alpha: 1.0)
        viewSkeleton.layer.cornerRadius = 12.0
        if #available(iOS 11.0, *) {
            viewSkeleton.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        }
    }
    
    func setValues(schedule: ScheduleViewModel) {
        self.schedule = schedule
        
        viewSkeleton.hideSkeleton()
        viewSkeleton.isHidden = true
        
        labelName.text = schedule.activity
        labelCategory.text = schedule.categoryName.uppercased()
        let arrayHour: [String] = schedule.hour.components(separatedBy: ":")
        labelHour.text = "\(arrayHour[0]):\(arrayHour[1])"
        constraintHeightViewTop.constant = 0.0
        
        labelMonth.text = ""
        labelDay.text = ""
        if schedule.newSection {
            constraintHeightViewTop.constant = 15.0
            
            labelMonth.text = schedule.month[0..<2].uppercased()
            labelDay.text = schedule.day
        }
    }
}

extension ScheduleTableViewCell {
    
    func realoadSkeletonView() {
        super.awakeFromNib()

        isSkeletonable = true
        viewSkeleton.showAnimatedGradientSkeleton()
    }
}
