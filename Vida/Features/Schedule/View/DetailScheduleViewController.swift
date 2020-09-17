//
//  DetailScheduleViewController.swift
//  Vida
//
//  Created by Vida on 29/10/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class DetailScheduleViewController: UIViewController {

    @IBOutlet weak var labeldActivity: UILabel!
    @IBOutlet weak var labelCategory: UILabel!
    @IBOutlet weak var labelObs: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    
    var scheduleViewModel: ScheduleViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labeldActivity.text = scheduleViewModel.activity
        labelCategory.text = scheduleViewModel.categoryName
        let arrayHour: [String] = scheduleViewModel.hour.components(separatedBy: ":")
        labelDate.text = "\(scheduleViewModel.date) \(arrayHour[0]):\(arrayHour[1])"
        labelObs.text = scheduleViewModel.description
        
        if Device.isIPhone5() {
            labelTitle.font = UIFont(name: "Montserrat-SemiBold", size: 16.0)
        }
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
