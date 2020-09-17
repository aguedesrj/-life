//
//  SchedulePresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

class SchedulePresenter {
    
    fileprivate var view: ScheduleViewProtocol
    fileprivate var service: ScheduleService
    
    init(view: ScheduleViewProtocol) {
        self.view = view
        self.service = ScheduleService()
    }
}

extension SchedulePresenter {
    
    func getSchedules() {
        if Util.isNotConnectedToNetwork() {
            self.view.returnError(message: Constrants.failureConnectedToNetwork)
            return
        }
        
        self.service.getSchedules(success: { (result) in
            if result.count == 0 {
                self.view.returnError(message: "Nenhum evento na agenda.")
            } else {
                var list: [ScheduleViewModel] = []
                for schedule: Schedule in result {
                    list.append(ScheduleViewModel.init(id: schedule.id,
                                                       date: schedule.date,
                                                       hour: schedule.hour,
                        day: schedule.day,
                        month: schedule.month,
                        activity: schedule.activity,
                        description: schedule.description,
                        categoryId: schedule.categoryId,
                        categoryName: schedule.categoryName,
                        dateDate: schedule.dateDate))
                }
                self.view.returnSuccess(list: list)
            }
        }) { (error) in
            self.view.returnError(message: error.description)
        }
    }
}
