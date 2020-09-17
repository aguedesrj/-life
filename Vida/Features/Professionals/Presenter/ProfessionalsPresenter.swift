//
//  ProfessionalsPresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit

class ProfessionalsPresenter {
    
    fileprivate var view: ProfessionalsViewProtocol!
    fileprivate var service: ProfessionalsService!

    var listStateFederationFilter: [StateFederationFilterViewModel] = []
    var listHealthSpecialtyFilter: [HealthSpecialty] = []
    var healthSpecialtySelected: HealthSpecialty?
    var nameProfessional: String = ""
    
    init(view: ProfessionalsViewProtocol) {
        self.view = view
        self.service = ProfessionalsService()
    }
    
    init() {
        self.service = ProfessionalsService()
    }
}

extension ProfessionalsPresenter {
    
    func getDomainStates() {
        self.service.getDomainStates(success: { (result) in
            for stateFederation: StateFederation in result {
                let uf: StateFederationFilterViewModel =
                    StateFederationFilterViewModel.init(id: stateFederation.id,
                                                        code: stateFederation.code,
                                                        name: stateFederation.name,
                                                        selected: false)
                self.listStateFederationFilter.append(uf)
            }
        }) { (error) in
            //
        }
    }
    
    func getHealthSpecialty() {
        self.service.getHealthSpecialty(success: { (result) in
            self.listHealthSpecialtyFilter = result
        }) { (error) in
            //
        }
    }
    
    func getProfessionals() {
        // filtros...
        // verifica a seleção do filtro de UF
        var filterUf: String? = nil
        for filter: StateFederationFilterViewModel in self.listStateFederationFilter {
            if filter.selected {
                if filterUf == nil {
                    filterUf = ""
                }
                
                if (filterUf!.count > 0) {
                    filterUf!.append(",")
                }
                filterUf!.append("\(filter.id)")
            }
        }
        var nameProf: String? = nil
        if nameProfessional.count > 0 {
            nameProf = self.nameProfessional
        }
        
        var healthSpecialty: Int? = nil
        if self.healthSpecialtySelected != nil && (self.healthSpecialtySelected?.id)! > 0 {
            healthSpecialty = self.healthSpecialtySelected?.id
        }
        
        self.service.getProfessionals(nameProfessional: nameProf, healthSpecialty: healthSpecialty,
                                      filterUf: filterUf, success: { (result) in
            self.view.returnSuccess(list: result)
        }) { (error) in
            self.view.returnError()
        }
    }
    
    func getListStringHealthSpecialty() -> [String] {
        var listReturn: [String] = []
        listReturn.append("\(0)|TODAS AS ESPECIALIDADES")
        for healthSpecialty: HealthSpecialty in self.listHealthSpecialtyFilter {
            listReturn.append("\(healthSpecialty.id)|\(healthSpecialty.name.uppercased())")
        }
        return listReturn
    }
    
    func registerAccessProfessional() {
        self.service.registerAccessProfessional(success: { (result) in
            //
        }) { (error) in
            //
        }
    }
}
