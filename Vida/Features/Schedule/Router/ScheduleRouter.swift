//
//  ScheduleRouter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

final class ScheduleRouter {

    func showAdd(at navigation: UINavigationController, scheduleViewModel: ScheduleViewModel?) {
        
        let controller: AddScheduleViewController =
            AddScheduleViewController(nibName: "AddScheduleViewController", bundle: nil)
        
        controller.presenter = AddSchedulePresenter.init(view: controller, scheduleViewModel: scheduleViewModel)
        
        navigation.show(controller, sender: nil)
    }
    
    func showStretching(at navigation: UINavigationController, delegate: ScheduleViewController) {
        
        let controller: StretchingViewController =
            StretchingViewController(nibName: "StretchingViewController", bundle: nil)
        controller.delegate = delegate
        
        navigation.show(controller, sender: nil)
    }
    
    func showDrinkWater(at navigation: UINavigationController, delegate: ScheduleViewController) {
        
        let controller: DrinkWaterViewController =
            DrinkWaterViewController(nibName: "DrinkWaterViewController", bundle: nil)
        controller.delegate = delegate
        
        navigation.show(controller, sender: nil)
    }
    
    func showDetail(at navigation: UINavigationController, scheduleViewModel: ScheduleViewModel) {
        
        let controller: DetailScheduleViewController =
            DetailScheduleViewController(nibName: "DetailScheduleViewController", bundle: nil)
        
        controller.scheduleViewModel = scheduleViewModel
        
        navigation.show(controller, sender: nil)
    }
}
