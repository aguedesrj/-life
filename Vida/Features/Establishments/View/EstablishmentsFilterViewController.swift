//
//  EstablishmentsFilterViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

protocol EstablishmentsFilterViewProtocol {
    func callServiceWithFilter(changeFilter: Bool)
}

class EstablishmentsFilterViewController: UIViewController {

    @IBOutlet weak var buttonOK: UIButton!
    @IBOutlet weak var collectionViewEstablishments: UICollectionView!
    @IBOutlet weak var constraintHeightCollectionViewEstablishments: NSLayoutConstraint!
    @IBOutlet weak var collectionViewRegion: UICollectionView!
    @IBOutlet weak var constraintHeightCollectionViewRegion: NSLayoutConstraint!
    
    var presenter: EstablishmentsPresenter!
    var delegate: EstablishmentsFilterViewProtocol!
    
    fileprivate let widthEstimatedCollectionViewRegion: Int = 68
    fileprivate let heightEstimatedCollectionViewRegion: Int = 35
    fileprivate var changeFilter: Bool = false
    fileprivate var listEstablishmentsBackup: [EstablishmentsCategoryFilterViewModel] = []
    fileprivate var listEstablishmentsUfsBackup: [StateFederationFilterViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewEstablishments.register(UINib(nibName: "InfoLifeFilterCollectionViewCell", bundle: nil),
                                             forCellWithReuseIdentifier: "InfoLifeFilterCollectionViewCell")
        
        self.collectionViewRegion.register(UINib(nibName: "EstablishmentsUfCollectionViewCell", bundle: nil),
                                             forCellWithReuseIdentifier: "EstablishmentsUfCollectionViewCell")

        let size: CGSize = self.buttonOK.frame.size
        self.buttonOK.layer.cornerRadius = size.height / 2
        self.buttonOK.layer.borderWidth = 2
        self.buttonOK.layer.borderColor = Color.primary.value.cgColor
        self.buttonOK.layer.masksToBounds = false
        
        var linesDecimal = Double(self.presenter.listEstablishmentsFilter.count) / 3.0
        self.constraintHeightCollectionViewEstablishments.constant *= CGFloat(ceil(linesDecimal))

        linesDecimal = Double(self.presenter.listEstablishmentsUfsFilter.count) / 4.0
        self.constraintHeightCollectionViewRegion.constant *= CGFloat(ceil(linesDecimal))
        
        collectionViewRegion.backgroundColor = UIColor.white
        collectionViewRegion.delaysContentTouches = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listEstablishmentsBackup = self.presenter.listEstablishmentsFilter
        listEstablishmentsUfsBackup = self.presenter.listEstablishmentsUfsFilter
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.collectionViewEstablishments.reloadData()
    }
    
    @IBAction func pressButtonOK(_ sender: Any) {
        delegate.callServiceWithFilter(changeFilter: changeFilter)
        self.dismiss(animated: true, completion: nil)
    }
}

extension EstablishmentsFilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == collectionViewEstablishments) {
            return self.presenter.listEstablishmentsFilter.count
        }
        return self.presenter.listEstablishmentsUfsFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == collectionViewEstablishments) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoLifeFilterCollectionViewCell",
                                                          for: indexPath) as! InfoLifeFilterCollectionViewCell
            
            let filter: EstablishmentsCategoryFilterViewModel = self.presenter.listEstablishmentsFilter[indexPath.row]
            cell.setValuesFilter(name: filter.name, image: filter.image, selected: filter.selected)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EstablishmentsUfCollectionViewCell", for: indexPath) as! EstablishmentsUfCollectionViewCell
        
        let stateFederation: StateFederationFilterViewModel = self.presenter.listEstablishmentsUfsFilter[indexPath.row]
        
        if (stateFederation.selected) {
            cell.labelTitle.textColor = UIColor.white
            cell.viewMain.backgroundColor = Color.primary.value
        } else {
            cell.labelTitle.textColor = Color.primary.value
            cell.viewMain.backgroundColor = UIColor.white
        }
        cell.labelTitle.text = "\(stateFederation.code)"

        return cell
    }
}

extension EstablishmentsFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeFilter = false
        if collectionView == collectionViewEstablishments {
            if self.presenter.listEstablishmentsFilter[indexPath.row].selected {
                self.presenter.listEstablishmentsFilter[indexPath.row].selected = false
            } else {
                self.presenter.listEstablishmentsFilter[indexPath.row].selected = true
            }
            self.collectionViewEstablishments.reloadData()
            
            // verifica se houve mudança no filtro
            if self.presenter.listEstablishmentsFilter[indexPath.row].selected != listEstablishmentsBackup[indexPath.row].selected {
                
                changeFilter = true
            }
        } else {
            if self.presenter.listEstablishmentsUfsFilter[indexPath.row].selected {
                self.presenter.listEstablishmentsUfsFilter[indexPath.row].selected = false
            } else {
                self.presenter.listEstablishmentsUfsFilter[indexPath.row].selected = true
            }
            self.collectionViewRegion.reloadData()
            
            // verifica se houve mudança no filtro
            if self.presenter.listEstablishmentsUfsFilter[indexPath.row].selected != listEstablishmentsUfsBackup[indexPath.row].selected {
                
                changeFilter = true
            }
        }
    }
}

extension EstablishmentsFilterViewController: UICollectionViewDelegateFlowLayout {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewEstablishments?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        if collectionView == collectionViewEstablishments {
            if Device.isIPhone5() {
                cellSize.width = 82.0
                cellSize.height = 82.0
            } else {
                var size: CGSize = self.collectionViewEstablishments.frame.size
                size.width -= 20 // espaciamento entre as células
                let cellSizeNew: CGFloat = size.width / 3.0
                cellSize.width = cellSizeNew
                cellSize.height = cellSizeNew
            }
        } else {
            cellSize.width = CGFloat(widthEstimatedCollectionViewRegion)
            cellSize.height = CGFloat(heightEstimatedCollectionViewRegion)
        }
        
        return cellSize
    }
}
