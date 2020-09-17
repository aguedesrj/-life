//
//  AddScheduleViewController.swift
//  Vida
//
//  Created by Vida on 17/10/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import DropDown

class AddScheduleViewController: BaseViewController {

    @IBOutlet weak var textFieldActivity: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldCategory: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldObs: SkyFloatingLabelTextField!
    @IBOutlet weak var textFieldDate: SkyFloatingLabelTextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    var presenter: AddSchedulePresenter!
    
    fileprivate let chooseArticleDropDown = DropDown()
    fileprivate var calendarCategorySelected: CalendarCategory!
    fileprivate var datePicker: UIDatePicker = UIDatePicker()
    fileprivate var labelTitleDatePicker: UILabel?
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        prepareScreen()
        
        prepareDropdown()
        
        presenter.getCalendarCategory()
        
        addValues()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressButtonSend(_ sender: Any) {
        presenter.send(activity: textFieldActivity.text!,
                       category: calendarCategorySelected,
                       description: textFieldObs.text!,
                       date: textFieldDate.text!)
    }
    
    @IBAction func pressButtonCategory(_ sender: Any) {
        chooseArticleDropDown.show()
    }
    
    @IBAction func pressButtonDelete(_ sender: Any) {
        let alert = UIAlertController(title: "Apagar Agenda",
                                      message: "Deseja apagar este agendamento?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sim", style: .default, handler: { (alert: UIAlertAction!) in
            // remover agenda...
            self.presenter.remove()
        }))
        
        alert.addAction(UIAlertAction(title: "Não", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension AddScheduleViewController {
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        textFieldDate.errorMessage = ""
        textFieldDate.text = Util.convertFromDateToString(date: datePicker.date,
                                                          format: "dd/MM/yyyy HH:mm")
    }
    
    @objc func doneDatePicker() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        if Device.isIPhone5() {
            contentInset.bottom = keyboardFrame.size.height + 40.0
        } else {
            contentInset.bottom = keyboardFrame.size.height
        }
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    fileprivate func prepareScreen() {
        if #available(iOS 12, *) {
            textFieldActivity.textContentType = .oneTimeCode
        } else {
            textFieldActivity.textContentType = .init(rawValue: "")
        }
        
        if (self.presenter.scheduleViewModelSelected == nil) {
            buttonDelete.isHidden = true
        } else {
            buttonDelete.tintColor = .white
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name:UIResponder.keyboardWillHideNotification, object: nil)
        
        textFieldActivity.setMaterialLayout()
        textFieldCategory.setMaterialLayout()
        textFieldObs.setMaterialLayout()
        textFieldDate.setMaterialLayout()
        
        datePicker.datePickerMode = .dateAndTime
        datePicker.backgroundColor = .white
        datePicker.minimumDate = Date()
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)),
                             for: .valueChanged)
        
        let doneButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: #selector(self.doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        labelTitleDatePicker = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 22.0, height: 14.0))
        labelTitleDatePicker?.textAlignment = NSTextAlignment.center
        labelTitleDatePicker?.sizeToFit()
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.setItems([spaceButton, UIBarButtonItem(customView: self.labelTitleDatePicker!),
                          spaceButton, doneButton], animated: true)
        toolbar.sizeToFit()
        
        textFieldDate.inputView = datePicker
        textFieldDate.inputAccessoryView = toolbar
        
        if Device.isIPhone5() {
            labelTitle.font = UIFont(name: "Montserrat-SemiBold", size: 16.0)
        }
    }
    
    fileprivate func prepareDropdown() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 3
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        appearance.cellHeight = 65
        
        self.chooseArticleDropDown.anchorView = self.textFieldCategory
        self.chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: self.textFieldCategory.bounds.height)
        self.chooseArticleDropDown.selectionAction = { [weak self] (index, item) in
            let arrayItem: [String] = item.components(separatedBy: "|")
            let id: Int = Int(arrayItem[0])!
            let name: String = arrayItem[1]
            
            self!.textFieldCategory.errorMessage = ""
            self!.textFieldCategory.text = name
            self!.calendarCategorySelected = CalendarCategory.init(id: id, name: name)
        }
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "HealthSpecialtyDropDownCell", bundle: nil)
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? HealthSpecialtyDropDownCell else { return }
                let arrayItem: [String] = item.components(separatedBy: "|")
                cell.optionLabel.text = "\(arrayItem[1])"
                cell.optionLabel.font = UIFont(name: "OpenSans-SemiBold", size: 12)
            }
        }
    }
    
    fileprivate func addValues() {
        if (self.presenter.scheduleViewModelSelected != nil) {
            textFieldActivity.text = self.presenter.scheduleViewModelSelected?.activity
            textFieldCategory.text = self.presenter.scheduleViewModelSelected?.categoryName
            textFieldObs.text = self.presenter.scheduleViewModelSelected?.description
            
            let arrayHour: [String] = self.presenter.scheduleViewModelSelected!.hour.components(separatedBy: ":")
            textFieldDate.text = "\(self.presenter.scheduleViewModelSelected!.date) \(arrayHour[0]):\(arrayHour[1])"
            
            datePicker.setDate(try! Util.convertFromStringToDate(dateString: textFieldDate.text!,
                                                            format: "dd/MM/yyyy HH:mm"), animated: true)

            self.calendarCategorySelected = CalendarCategory
                .init(id: self.presenter.scheduleViewModelSelected!.categoryId,
                      name: self.presenter.scheduleViewModelSelected!.categoryName)
        }
    }
}

extension AddScheduleViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textFieldActivity {
            textFieldActivity.errorMessage = ""
        } else if textField == textFieldDate {
            textFieldDate.errorMessage = ""
        } else if textField == textFieldCategory {
            textFieldCategory.errorMessage = ""
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldActivity {
            self.view.endEditing(true)
            chooseArticleDropDown.show()
        } else if textField == textFieldCategory {
            textFieldDate.becomeFirstResponder()
        } else if textField == textFieldDate {
            textFieldObs.becomeFirstResponder()
        } else if textField == textFieldObs {
            textField.resignFirstResponder()
            pressButtonSend(self)
        }
        return true
    }
}

extension AddScheduleViewController: AddScheduleViewProtocol {
    func successListSpecialty() {
        self.chooseArticleDropDown.dataSource = self.presenter.getListStringHealthSpecialty()
    }
    
    func errorListSpecialty() {
        self.showAlert(message: Constrants.messageSystemUnavailable)
    }
    
    func successInsert(message: String) {
        //
        self.hideLoading()
        
        let alert = UIAlertController(title: "Sucesso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (result) in
            self.pressButtonBack(self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorInsert(message: String) {
        self.showAlert(message: message)
    }
    
    func errorValidFieldActivity(message: String) {
        textFieldActivity.errorColor = UIColor.red
        textFieldActivity.errorMessage = message
    }
    
    func errorValidFieldSpecialty(message: String) {
        textFieldCategory.errorColor = UIColor.red
        textFieldCategory.errorMessage = message
    }
    
    func errorValidFieldDate(message: String) {
        textFieldDate.errorColor = UIColor.red
        textFieldDate.errorMessage = message
    }
    
    func successRemove(message: String) {
        self.hideLoading()
        
        let alert = UIAlertController(title: "Sucesso", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (result) in
            self.pressButtonBack(self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func errorRemove(message: String) {
        self.showAlert(message: message)
    }
}
