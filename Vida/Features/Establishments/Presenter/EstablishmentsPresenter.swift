//
//  EstablishmentsPresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class EstablishmentsPresenter {
    
    fileprivate var view: EstablishmentsViewProtocol
    fileprivate var service: EstablishmentsService
    fileprivate var listResult: [EstablishmentsCategory]!
    
    var listEstablishmentsFilter: [EstablishmentsCategoryFilterViewModel] = []
    var listEstablishmentsUfsFilter: [StateFederationFilterViewModel] = []
    var returnFullFilterEstablishments: Bool = false
    
    init(view: EstablishmentsViewProtocol) {
        self.view = view
        self.service = EstablishmentsService()
    }
}

extension EstablishmentsPresenter {
    
    func getFilterUfs() {
        self.service.getEstablishmentsUfs(success: { (result) in
            for stateFederation: StateFederation in result {
                let uf: StateFederationFilterViewModel =
                    StateFederationFilterViewModel.init(id: stateFederation.id,
                                                        code: stateFederation.code,
                                                        name: stateFederation.name,
                                                        selected: false)
                self.listEstablishmentsUfsFilter.append(uf)
            }
        }) { (error) in
            //
        }
    }
    
    func getFilterEstablishments() {
        // obter a lista de filtros...
        self.service.getEstablishmentsCategory(success: { (result) in
            self.listResult = result
            var cont: Int = 0
            for establishmentsCategory: EstablishmentsCategory in result {
                cont += 1
                var establishmentsCategoryFilter: EstablishmentsCategoryFilterViewModel =
                    EstablishmentsCategoryFilterViewModel.init(id: establishmentsCategory.id,
                                                         name: establishmentsCategory.name,
                                                         url: establishmentsCategory.icon,
                                                         selected: false)
                
                if (!establishmentsCategoryFilter.url.isEmpty) {
                    let options: KingfisherOptionsInfo = [.callbackQueue(.mainAsync)]
                    KingfisherManager.shared.retrieveImage(with: URL(string: establishmentsCategoryFilter.url)!, options: options, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            establishmentsCategoryFilter.image = value.image
                            self.listEstablishmentsFilter.append(establishmentsCategoryFilter)
                            if (cont == self.listResult.count) {
                                // ordenar a lista...
                                self.orderFilterEstablishments()
                            }
                        case .failure(let error):
                            print("Error: \(error)")
                            if (cont == self.listResult.count) {
                                if self.listEstablishmentsFilter.count == 0 {
                                    self.view.returnFilterEstablishments()
                                } else {
                                    // ordenar a lista...
                                    self.orderFilterEstablishments()
                                }
                            }
                        }
                    }
                } else {
                    self.listEstablishmentsFilter.append(establishmentsCategoryFilter)
                }
            }
        }) { (error) in
            // tenta novamente
            self.getFilterEstablishments()
        }
    }
    
    fileprivate func orderFilterEstablishments() {
        // ordernar pelo código
        self.listEstablishmentsFilter.sort(by: { (first: EstablishmentsCategoryFilterViewModel,
            second: EstablishmentsCategoryFilterViewModel) -> Bool in
            
            second.id > first.id
        })
        self.returnFullFilterEstablishments = true
        self.view.returnFilterEstablishments()
    }
    
    func getEstablishments() {
        // verifica a seleção do filtro de categorias
        var filterEstablishmentsCategory: String = ""
        for filter: EstablishmentsCategoryFilterViewModel in self.listEstablishmentsFilter {
            if filter.selected {
                if (filterEstablishmentsCategory.count > 0) {
                    filterEstablishmentsCategory.append(",")
                }
                filterEstablishmentsCategory.append("\(filter.id)")
            }
        }
        
        // verifica a seleção do filtro de UF
        var filterEstablishmentsUf: String = ""
        for filter: StateFederationFilterViewModel in self.listEstablishmentsUfsFilter {
            if filter.selected {
                if (filterEstablishmentsUf.count > 0) {
                    filterEstablishmentsUf.append(",")
                }
                filterEstablishmentsUf.append("\(filter.id)")
            }
        }
        
        self.service.getEstablishments(filterEstablishmentsCategory: filterEstablishmentsCategory,
                                 filterEstablishmentsUf: filterEstablishmentsUf, success: { (result) in
            //
            self.view.returnSuccess(list: result)
        }) { (error) in
            // tenta novamente
            self.getEstablishments()
        }
    }
}
