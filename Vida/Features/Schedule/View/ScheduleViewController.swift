//
//  ScheduleViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class ScheduleViewController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelMessageError: UILabel!
    @IBOutlet weak var tableViewSchedule: UITableView!
    @IBOutlet weak var buttonAdd: UIButton!
    
    var listSchedule: [ScheduleViewModel] = []
    var presenter: SchedulePresenter!
    
    fileprivate var isReloadTable: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelTitle.text = "Agenda"
        buttonAdd.tintColor = Color.primary.value
        
        presenter = SchedulePresenter(view: self)
        
        tableViewSchedule.register(UINib(nibName: "ScheduleTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "ScheduleTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if (isReloadTable) {
            presenter.getSchedules()
            tableViewSchedule.reloadData()
        }
        isReloadTable = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.showSideMenu()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.hideSideMenu()
    }

    @IBAction func pressButtonMenu(_ sender: Any) {
        self.openMenuLeft()
    }
    
    @IBAction func pressButtonAdd(_ sender: Any) {
        ScheduleRouter().showAdd(at: appDelegate.navController!,
                                 scheduleViewModel: nil)
    }
}

extension ScheduleViewController {
    
    @objc fileprivate func callShowStretching() {
        isReloadTable = false
        ScheduleRouter().showStretching(at: appDelegate.navController!, delegate: self)
    }
    
    @objc fileprivate func callShowDrinkWater() {
        isReloadTable = false
        ScheduleRouter().showDrinkWater(at: appDelegate.navController!, delegate: self)
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listSchedule.count == 0) {
            return 3
        }
        return listSchedule.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleTableViewCell",
                                                 for: indexPath) as! ScheduleTableViewCell
        
        cell.selectionStyle = .none
        cell.delegate = self
        if self.listSchedule.count > 0 {
            cell.setValues(schedule: self.listSchedule[indexPath.row])
        } else {
            cell.realoadSkeletonView()
        }
        
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity: String = Util.replaceCaracterSpecial(value: self.listSchedule[indexPath.row].activity.uppercased())
        
        if (activity == Constrants.kStretching) {
            isReloadTable = false
            ScheduleRouter().showStretching(at: appDelegate.navController!, delegate: self)
        } else if (activity == "BEBER AGUA") {
            isReloadTable = false
            ScheduleRouter().showDrinkWater(at: appDelegate.navController!, delegate: self)
        } else {
            ScheduleRouter().showAdd(at: appDelegate.navController!,
                                     scheduleViewModel: self.listSchedule[indexPath.row])
            //            ScheduleRouter().showDetail(at: appDelegate.navController!,
            //                                        scheduleViewModel: self.listSchedule[indexPath.row])
        }
    }
}

extension ScheduleViewController: ScheduleViewProtocol {
    
    func returnSuccess(list: [ScheduleViewModel]) {
        self.tableViewSchedule.isHidden = false
        
        let todayString: String = Util.convertFromDateToString(date: Date(), format: "dd/MM/yyyy")
        var listReturn: [ScheduleViewModel] = []
        var startDateOld: String?
        var contPosition: Int = 0
        var stopCont: Bool = false
        
        var listOrder: [ScheduleViewModel] = list
        
        listOrder.sort(by: { (first: ScheduleViewModel, second: ScheduleViewModel) -> Bool in
            second.dateDate > first.dateDate
        })
        
        for schedule in listOrder {
            var scheduleViewModel: ScheduleViewModel = schedule
            if startDateOld == nil || schedule.date != startDateOld {
                // novo item na lista somente com a data.
                scheduleViewModel.newSection = true
            }
            listReturn.append(scheduleViewModel)
            startDateOld = schedule.date
            
            if (todayString != scheduleViewModel.date && !stopCont) {
                contPosition += 1
            } else {
                stopCont = true
            }
        }
        self.listSchedule = listReturn
        self.tableViewSchedule.reloadData()
        
        let indexPath = NSIndexPath(row: contPosition, section: 0)
        self.tableViewSchedule.scrollToRow(at: indexPath as IndexPath, at: .top, animated: false)
        
        if (self.appDelegate.fromPush != nil) {
            let fromPush: String = self.appDelegate.fromPush
            self.appDelegate.fromPush = nil
            
            if (fromPush == Constrants.kStretching) {
                Timer.scheduledTimer(timeInterval: 0.07, // 1 segundo
                    target: self,
                    selector: #selector(callShowStretching),
                    userInfo: nil,
                    repeats: false)
            } else {
                Timer.scheduledTimer(timeInterval: 0.07, // 1 segundo
                    target: self,
                    selector: #selector(callShowDrinkWater),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }
    
    func returnError(message: String) {
        self.appDelegate.fromPush = nil
        self.tableViewSchedule.isHidden = true
        self.labelMessageError.text = message
    }
}

extension ScheduleViewController: ScheduleTableViewCellDelegate {
    
    func callPhone(numberPhone: String) {
        self.callPhone(phone: numberPhone)
    }
}

extension ScheduleViewController: StretchingViewDelegate {
    
    func noReloadTable() {
        isReloadTable = false
    }
}
