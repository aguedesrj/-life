//
//  InfoLifeViewController.swift
//  Vida
//
//  Created by André Lessa Guedes on 19/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import SkeletonView

class InfoLifeViewController: BaseViewController {
    
    @IBOutlet weak var collectionViewInfoLife: UICollectionView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    
    fileprivate var listInfoLife: [InfoLife] = []
    fileprivate var returnScreenFilter: Bool = false
    
    var presenter: InfoLifePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buttonFilter.imageView?.tintColor = Color.primary.value
        
        labelTitle.text = "Info Vida"

        self.presenter = InfoLifePresenter(view: self)
        
        self.collectionViewInfoLife.register(UINib(nibName: "InfoLifeCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "InfoLifeCollectionViewCell")
        
        // buscar os filtros do info vida
        self.presenter.getFilterInfoLife()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !returnScreenFilter {
            // lista as publicações
            self.presenter.getInfoLife(listInfoLifeFilter:[])
            
            collectionViewInfoLife.reloadData()
        }
        self.returnScreenFilter = false
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
    
    @IBAction func pressButtonFilter(_ sender: Any) {
        if self.presenter.returnFullFilterInfoLife {
            InfoLifeRouter().showFilter(at: appDelegate.navController!,
                                        presenter: self.presenter,
                                        delegate: self)
        } else {
            self.showLoading()
        }
    }
}

extension InfoLifeViewController: InfoLifeViewProtocol {
    func returnFilterInfoLife() {
        // verifica se está em loading a tela.
        if self.progress != nil && !self.progress.isHide() {
            // exibir a tela de filtro
            self.hideLoading()
            InfoLifeRouter().showFilter(at: appDelegate.navController!,
                                        presenter: self.presenter,
                                        delegate: self)
        }
    }
    
    func returnSuccess(list: [InfoLife]) {
        self.listInfoLife = list
        self.collectionViewInfoLife.reloadData()
    }
}

extension InfoLifeViewController: InfoLifeFilterViewProtocol {
    
    func callServiceWithFilter(listInfoLifeFilter: [InforLifeFilterViewModel], changeFilter: Bool) {
        self.returnScreenFilter = changeFilter
        if changeFilter {
            self.listInfoLife.removeAll()
            self.collectionViewInfoLife.reloadData()
            
            buttonFilter.setImage(UIImage(named: "iconMainFilterReset"), for: .normal)
            for filter: InforLifeFilterViewModel in listInfoLifeFilter {
                if filter.selected {
                    buttonFilter.setImage(UIImage(named: "iconMainFilterDefined"), for: .normal)
                    break
                }
            }
            self.presenter.getInfoLife(listInfoLifeFilter: listInfoLifeFilter)
        }
    }
}

extension InfoLifeViewController: InfoLifeCollectionViewProtocol {
    
    func callInfoLifeDetail(infoLife: InfoLife) {
        InfoLifeRouter().showDetail(at: appDelegate.navController!,
                                    infoLife: infoLife)
    }
    
    func callGetImage(image: UIImage, indexSelected: Int) {
        self.listInfoLife[indexSelected].image = image
    }
}

extension InfoLifeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (listInfoLife.count == 0) {
            return 2 // default
        }
        return listInfoLife.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoLifeCollectionViewCell",
                                                      for: indexPath) as! InfoLifeCollectionViewCell
        
        if self.listInfoLife.count > 0 {
            cell.delegate = self
            cell.setValuesViews(infoLife: self.listInfoLife[indexPath.row], indexSelected: indexPath.row)
        } else {
            cell.realoadSkeletonView()
        }
        return cell
    }
}

extension InfoLifeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize: CGSize = collectionView.bounds.size

        if Device.isIPhone5() {
            cellSize.height -= 120.0
        } else {
            cellSize.height = 297.0
        }

        return cellSize
    }
}
