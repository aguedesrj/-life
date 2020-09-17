//
//  StoresPartnerViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class StoresPartnerViewController: BaseViewController {

    @IBOutlet weak var tableViewStores: UITableView!
    
    fileprivate var presenter: EstablishmentsPresenter!
    fileprivate var listEstablishments: [Establishments] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = EstablishmentsPresenter(view: self)

        self.tableViewStores.register(UINib(nibName: "StoresPartnerTableViewCell", bundle: nil),
                                             forCellReuseIdentifier: "StoresPartnerTableViewCell")
        
        // buscar as UFs de filtro
        self.presenter.getFilterUfs()
        
        // buscar os filtros
        self.presenter.getFilterEstablishments()
        
        // obter a lista de categorias
        self.presenter.getEstablishments()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension StoresPartnerViewController {
    
}

extension StoresPartnerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (listEstablishments.count == 0) {
            return 3
        }
        return self.listEstablishments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StoresPartnerTableViewCell",
                                                 for: indexPath) as! StoresPartnerTableViewCell
        
        cell.selectionStyle = .none
        if self.listEstablishments.count > 0 {
            cell.setValues(establishments: self.listEstablishments[indexPath.row])
        } else {
            cell.realoadSkeletonView()
        }
        
        return cell
    }
}

extension StoresPartnerViewController: EstablishmentsViewProtocol {
    
    func returnSuccess(list: [Establishments]) {
        self.listEstablishments = list
        self.tableViewStores.reloadData()
    }
    
    func returnFilterEstablishments() {
        // verifica se está em loading a tela.
        if self.progress != nil && !self.progress.isHide() {
            // exibir a tela de filtro
            self.hideLoading()
//            EstablishmentsRouter().showFilter(at: appDelegate.navController!,
//                                              presenter: self.presenter,
//                                              delegate: self)
        }
    }
}

extension StoresPartnerViewController: EstablishmentsFilterViewProtocol {
    func callServiceWithFilter(changeFilter: Bool) {
        if changeFilter {
            self.listEstablishments.removeAll()
            self.tableViewStores.reloadData()
            
            self.presenter.getEstablishments()
        }
    }
}
