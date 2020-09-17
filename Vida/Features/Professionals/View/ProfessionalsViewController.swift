//
//  ProfessionalsViewController.swift
//  Vida
//
//  Created by Vida.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class ProfessionalsViewController: BaseViewController {

    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableViewProfessionals: UITableView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelMessageError: UILabel!
    
    fileprivate var listProfessionals: [Professional] = []
    
    var presenter: ProfessionalsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonFilter.imageView?.tintColor = Color.primary.value
        buttonBack.imageView?.tintColor = Color.primary.value

        labelTitle.text = "Profissionais de Saúde"
        if (Device.isIPhone4() || Device.isIPhone5()) {
            labelTitle.font = labelTitle.font.withSize(16)
        }
        
        self.presenter = ProfessionalsPresenter(view: self)
        
        self.tableViewProfessionals.register(UINib(nibName: "ProfessionalsTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "ProfessionalsTableViewCell")
        
        // lista de especialidades
        self.presenter.getHealthSpecialty()
        
        // lista de estados
        self.presenter.getDomainStates()
        
        // lista de profissionais.
        self.presenter.getProfessionals()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressButtonFilter(_ sender: Any) {
        ProfessionalsRouter().showFilter(at: appDelegate.navController!,
                                    presenter: self.presenter,
                                    delegate: self)
    }
}

extension ProfessionalsViewController: ProfessionalsFilterViewProtocol {
    
    func callServiceWithFilter(changeFilter: Bool) {
        if changeFilter {
            self.listProfessionals.removeAll()
            self.tableViewProfessionals.isHidden = false
            self.tableViewProfessionals.reloadData()
            
            var isFilter: Bool = false
            // verifica se a lista de Estabelicimentos algum foi selecionado
            buttonFilter.setImage(UIImage(named: "iconMainFilterReset"), for: .normal)
            for filter: StateFederationFilterViewModel in self.presenter.listStateFederationFilter {
                if filter.selected {
                    isFilter = true
                    break
                }
            }
            
            if !isFilter {
                // verifica se alguma especialidade foi selecionada
                if self.presenter.healthSpecialtySelected != nil &&
                    (self.presenter.healthSpecialtySelected?.id)! > 0 {
                    
                    isFilter = true
                }
            }
            
            if !isFilter {
                // verifica se digitou algum nome de um profissional
                if self.presenter.nameProfessional != nil && self.presenter.nameProfessional.count > 0 {
                    isFilter = true
                }
            }
            
            if isFilter {
                buttonFilter.setImage(UIImage(named: "iconMainFilterDefined"), for: .normal)
            }
            
            self.presenter.getProfessionals()
        }
    }
}

extension ProfessionalsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listProfessionals.count == 0) {
            return 3
        }
        return self.listProfessionals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfessionalsTableViewCell",
                                                 for: indexPath) as! ProfessionalsTableViewCell
        
        cell.selectionStyle = .none
        if self.listProfessionals.count > 0 {
            cell.setValues(professional: self.listProfessionals[indexPath.row])
        } else {
            cell.realoadSkeletonView()
        }
        
        return cell
    }
}

extension ProfessionalsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ProfessionalsRouter().showDetail(at: self.appDelegate.navController!,
                                         professional: self.listProfessionals[indexPath.row])
    }
}

extension ProfessionalsViewController: ProfessionalsViewProtocol {
    func returnSuccess(list: [Professional]) {
        if list.count == 0 {
            self.tableViewProfessionals.isHidden = true
            self.labelMessageError.text = Constrants.kMessageRecordNotFound
            return
        }
        
        self.listProfessionals = list
        
        if !self.presenter.nameProfessional.isEmpty {
            let name1: String = Util.replaceCaracterSpecial(value: self.presenter.nameProfessional)
            var listResult: [Professional] = []
            for professional in list {
                let name2: String = Util.replaceCaracterSpecial(value: professional.name)
                
                if name2.contains("\(name1)") {
                    listResult.append(professional)
                }
            }

            if listResult.count == 0 {
                self.tableViewProfessionals.isHidden = true
                self.labelMessageError.text = Constrants.kMessageRecordNotFound
                return
            }
            self.listProfessionals = listResult
        }
        
        self.tableViewProfessionals.isHidden = false
        self.tableViewProfessionals.reloadData()
    }
    
    func returnError() {
        self.tableViewProfessionals.isHidden = true
        if Util.isNotConnectedToNetwork() {
            self.labelMessageError.text = Constrants.failureConnectedToNetwork
            return
        }
        self.labelMessageError.text = Constrants.kMessageRecordNotFound
    }
}
