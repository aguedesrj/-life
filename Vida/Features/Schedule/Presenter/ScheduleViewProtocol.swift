//
//  ScheduleViewProtocol.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation

protocol ScheduleViewProtocol: class {
    func returnSuccess(list: [ScheduleViewModel])
    func returnError(message: String)
}
