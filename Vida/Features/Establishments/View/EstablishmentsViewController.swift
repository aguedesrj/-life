//
//  EstablishmentsViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class EstablishmentsViewController: BaseViewController {

    @IBOutlet weak var collectionViewEstablishments: UICollectionView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    
    fileprivate var listEstablishments: [Establishments] = []
    
    var presenter: EstablishmentsPresenter!
    var viewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonBack.imageView?.tintColor = Color.primary.value
        
        labelTitle.text = "Estabelecimentos"
        
        self.presenter = EstablishmentsPresenter(view: self)
        
        self.collectionViewEstablishments.register(UINib(nibName: "EstablishmentsCollectionViewCell", bundle: nil),
                                             forCellWithReuseIdentifier: "EstablishmentsCollectionViewCell")
        
        // buscar as UFs de filtro
        self.presenter.getFilterUfs()
        
        // buscar os filtros
        self.presenter.getFilterEstablishments()
        
        // obter a lista de categorias
        self.presenter.getEstablishments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        collectionViewEstablishments.reloadData()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        if viewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func pressButtonFilter(_ sender: Any) {
        if self.presenter.returnFullFilterEstablishments {
            if viewController != nil {
                EstablishmentsRouter().showFilter(at: self,
                                                  presenter: self.presenter,
                                                  delegate: self)
            } else {
                EstablishmentsRouter().showFilter(at: appDelegate.navController!,
                                                  presenter: self.presenter,
                                                  delegate: self)
            }
        } else {
            self.showLoading()
        }
    }
}

extension EstablishmentsViewController: EstablishmentsViewProtocol {
    func returnFilterEstablishments() {
        // verifica se está em loading a tela.
        if self.progress != nil && !self.progress.isHide() {
            // exibir a tela de filtro
            self.hideLoading()
            if viewController != nil {
                EstablishmentsRouter().showFilter(at: self,
                                                  presenter: self.presenter,
                                                  delegate: self)
            } else {
                EstablishmentsRouter().showFilter(at: appDelegate.navController!,
                                                  presenter: self.presenter,
                                                  delegate: self)
            }
        }
    }
    
    func returnSuccess(list: [Establishments]) {
        self.listEstablishments = list
        self.collectionViewEstablishments.reloadData()
    }
}

extension EstablishmentsViewController: EstablishmentsCollectionViewProtocol {
    
    func callEstablishmentsDetail(establishments: Establishments) {
        if viewController != nil {
            EstablishmentsRouter().showDetail(at: self, establishments: establishments)
        } else {
            EstablishmentsRouter().showDetail(at: appDelegate.navController!, establishments: establishments)
        }
    }
    
    func callGetImage(image: UIImage, indexSelected: Int) {
        self.listEstablishments[indexSelected].image = image
    }
}

extension EstablishmentsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (listEstablishments.count == 0) {
            return 2 // default
        }
        return listEstablishments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EstablishmentsCollectionViewCell",
                                                      for: indexPath) as! EstablishmentsCollectionViewCell
        
        if self.listEstablishments.count > 0 {
            cell.delegate = self
            cell.setValuesViews(establishments: self.listEstablishments[indexPath.row], indexSelected: indexPath.row)
        }
        return cell
    }
}

extension EstablishmentsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.presenter.listEstablishmentsFilter[indexPath.row].selected {
            self.presenter.listEstablishmentsFilter[indexPath.row].selected = false
        } else {
            self.presenter.listEstablishmentsFilter[indexPath.row].selected = true
        }
        self.collectionViewEstablishments.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
}

extension EstablishmentsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        
        if Device.isIPhone5() {
            cellSize.height -= 130.0
        } else {
            cellSize.height = 275.0
        }
        
        return cellSize
    }
}

extension EstablishmentsViewController: EstablishmentsFilterViewProtocol {
    
    func callServiceWithFilter(changeFilter: Bool) {
        if changeFilter {
            self.listEstablishments.removeAll()
            self.collectionViewEstablishments.reloadData()
            
            var isFilter: Bool = false
            // verifica se a lista de Estabelicimentos algum foi selecionado
            buttonFilter.setImage(UIImage(named: "iconMainFilterReset"), for: .normal)
            for filter: EstablishmentsCategoryFilterViewModel in self.presenter.listEstablishmentsFilter {
                if filter.selected {
                    isFilter = true
                    break
                }
            }
            
            if !isFilter {
                // verifica se a lista de Região algum foi selecionado
                for filter: StateFederationFilterViewModel in self.presenter.listEstablishmentsUfsFilter {
                    if filter.selected {
                        isFilter = true
                        break
                    }
                }
            }
            
            if isFilter {
                buttonFilter.setImage(UIImage(named: "iconMainFilterDefined"), for: .normal)
            }
            
            self.presenter.getEstablishments()
        }
    }
    
    func callServiceWithFilter() {

    }
}
