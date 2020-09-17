//
//  AddSchedulePresenter.swift
//  Vida
//
//  Created by Vida on 17/10/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

class AddSchedulePresenter {
    
    fileprivate var view: AddScheduleViewProtocol
    fileprivate var service: ScheduleService
    
    var listCalendarCategoryFilter: [CalendarCategory] = []
    var scheduleViewModelSelected: ScheduleViewModel?
    
    init(view: AddScheduleViewProtocol, scheduleViewModel: ScheduleViewModel?) {
        self.view = view
        self.service = ScheduleService()
        self.scheduleViewModelSelected = scheduleViewModel
    }
}

extension AddSchedulePresenter {
    
    func getCalendarCategory() {
        self.service.getCalendarCategory(success: { (result) in
            self.listCalendarCategoryFilter = result
            self.view.successListSpecialty()
        }) { (error) in
            self.view.errorListSpecialty()
        }
    }
    
    func getListStringHealthSpecialty() -> [String] {
        var listReturn: [String] = []
        for item: CalendarCategory in self.listCalendarCategoryFilter {
            listReturn.append("\(item.id)|\(item.name.capitalized)")
        }
        return listReturn
    }
    
    func remove() {
        self.view.showLoading()
        service.remove(idAgenda: scheduleViewModelSelected!.id, success: { (result) in
            //
            self.view.successRemove(message: result)
        }) { (error) in
            //
            self.view.errorRemove(message: Constrants.messageSystemUnavailable)
        }
    }
    
    func send(activity: String, category: CalendarCategory?, description: String, date: String) {
        var validFields: Bool = true
        let messageError: String = "Campo obrigatório"
        
        if (activity.isCleanedStringEmpty) {
            self.view.errorValidFieldActivity(message: messageError)
            validFields = false
        }
        
        if (category == nil || category!.name.isCleanedStringEmpty) {
            self.view.errorValidFieldSpecialty(message: messageError)
            validFields = false
        }
        
        if (date.isCleanedStringEmpty) {
            self.view.errorValidFieldDate(message: messageError)
            validFields = false
        }
        
        if validFields {
            let arrayDate: [String] = date.components(separatedBy: " ")
            let dateParam: String = arrayDate[0]
            let hourParam: String = "\(arrayDate[1]):00"
            
            var idAgenda: Int?
            if (scheduleViewModelSelected != nil) {
                idAgenda = scheduleViewModelSelected?.id
            }

            print("************ ENVIANDO DATAPARAM: \(dateParam) \(hourParam) ************")
            self.view.showLoading()
            service.insert(idAgenda: idAgenda, activity: activity, category: category!.id, description: description, date: dateParam, hour: hourParam, success: { (result) in
                //
                self.view.successInsert(message: result)
            }) { (error) in
                //
                self.view.errorInsert(message: Constrants.messageSystemUnavailable)
            }
        }
    }
}
