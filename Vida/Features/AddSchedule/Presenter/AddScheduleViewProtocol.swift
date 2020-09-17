//
//  AddScheduleViewProtocol.swift
//  Vida
//
//  Created by Vida on 17/10/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

protocol AddScheduleViewProtocol {
    func showLoading()
    func successListSpecialty()
    func errorListSpecialty()
    func successInsert(message: String)
    func errorInsert(message: String)
    func successRemove(message: String)
    func errorRemove(message: String)
    // campos
    func errorValidFieldActivity(message: String)
    func errorValidFieldSpecialty(message: String)
    func errorValidFieldDate(message: String)
}
