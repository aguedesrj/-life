//
//  InfoLifePresenter.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class InfoLifePresenter {
    
    fileprivate var view: InfoLifeViewProtocol!
    fileprivate var service: InfoLifeService!
    fileprivate var listResult: [InfoLifeCategory]!
    
    var listInfoLifeFilter: [InforLifeFilterViewModel]!
    var returnFullFilterInfoLife: Bool = false
    
    init(view: InfoLifeViewProtocol) {
        self.view = view
        self.service = InfoLifeService()
    }
    
    init() {
        self.service = InfoLifeService()
    }
}

extension InfoLifePresenter {
    
    func getFilterInfoLife() {
        // obter a lista de filtros...
        self.service.getInfoLifeCategory(success: { (result) in
            self.listResult = result
            self.listInfoLifeFilter = []
            var cont: Int = 0
            for infoLifeCategory: InfoLifeCategory in result {
                cont += 1
                var infoLifeFilter: InforLifeFilterViewModel =
                    InforLifeFilterViewModel.init(id: infoLifeCategory.id,
                                                  name: infoLifeCategory.name,
                                                  url: infoLifeCategory.icon,
                                                  selected: false)
                
                if infoLifeFilter.url != "" {
                    let options: KingfisherOptionsInfo = [.callbackQueue(.mainAsync)]
                    KingfisherManager.shared.retrieveImage(with: URL(string: infoLifeFilter.url)!, options: options, progressBlock: nil) { result in
                        switch result {
                        case .success(let value):
                            infoLifeFilter.image = value.image
                            self.listInfoLifeFilter.append(infoLifeFilter)
                            if (cont == self.listResult.count) {
                                // ordenar a lista...
                                self.orderFilterInfoLife()
                            }
                        case .failure(let error):
                            print("Error: \(error)")
                            self.listInfoLifeFilter.append(infoLifeFilter)
                            if (cont == self.listResult.count) {
                                if self.listInfoLifeFilter.count == 0 {
                                    self.view.returnFilterInfoLife()
                                } else {
                                    // ordenar a lista...
                                    self.orderFilterInfoLife()
                                }
                            }
                        }
                    }
                } else {
                    self.listInfoLifeFilter.append(infoLifeFilter)
                    if (cont == self.listResult.count) {
                        // ordenar a lista...
                        self.orderFilterInfoLife()
                    }
                }
            }
        }) { (error) in
            // tenta novamente
            self.getFilterInfoLife()
        }
    }
    
    fileprivate func orderFilterInfoLife() {
        // ordernar pelo código
        self.listInfoLifeFilter?.sort(by: { (first: InforLifeFilterViewModel,
            second: InforLifeFilterViewModel) -> Bool in
            
            second.id > first.id
        })
        self.returnFullFilterInfoLife = true
        self.view.returnFilterInfoLife()
    }
    
    
    
    func getInfoLife(listInfoLifeFilter: [InforLifeFilterViewModel]?) {
        // verifica a seleção do filtro
        var filterInfoLife: String = ""
        for filter: InforLifeFilterViewModel in listInfoLifeFilter! {
            if filter.selected {
                if (filterInfoLife.count > 0) {
                    filterInfoLife.append(",")
                }
                filterInfoLife.append("\(filter.id)")
            }
        }
        
        self.service.getInfoLife(categorys: filterInfoLife, success: { (result) in
            //
            self.view.returnSuccess(list: result)
        }) { (error) in
            // tenta novamente
            self.getInfoLife(listInfoLifeFilter: listInfoLifeFilter)
        }
    }
    
    func registerAccessInfoVida() {
        self.service.registerAccessInfoVida(success: { (result) in
            //
        }) { (error) in
            //
        }
    }
}
