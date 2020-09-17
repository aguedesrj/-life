//
//  InfoLifeFilterViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

protocol InfoLifeFilterViewProtocol {
    func callServiceWithFilter(listInfoLifeFilter: [InforLifeFilterViewModel], changeFilter: Bool)
}

class InfoLifeFilterViewController: BaseViewController {
    
    @IBOutlet weak var buttonOK: UIButton!
    @IBOutlet weak var collectionViewInfoLife: UICollectionView!

    var presenter: InfoLifePresenter!
    var delegate: InfoLifeFilterViewProtocol!
    
    fileprivate var listInfoLifeFilterBackup: [InforLifeFilterViewModel]!
    fileprivate var changeFilter: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionViewInfoLife.register(UINib(nibName: "InfoLifeFilterCollectionViewCell", bundle: nil),
                                             forCellWithReuseIdentifier: "InfoLifeFilterCollectionViewCell")

        let size: CGSize = self.buttonOK.frame.size
        self.buttonOK.layer.cornerRadius = size.height / 2
        self.buttonOK.layer.borderWidth = 2
        self.buttonOK.layer.borderColor = Color.primary.value.cgColor
        self.buttonOK.layer.masksToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listInfoLifeFilterBackup = self.presenter.listInfoLifeFilter
    }
    
    @IBAction func pressButtonOK(_ sender: Any) {
        delegate.callServiceWithFilter(listInfoLifeFilter: self.presenter.listInfoLifeFilter, changeFilter: changeFilter)
        self.dismiss(animated: true, completion: nil)
    }
}

extension InfoLifeFilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.listInfoLifeFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoLifeFilterCollectionViewCell",
                                                      for: indexPath) as! InfoLifeFilterCollectionViewCell
        
        let filter: InforLifeFilterViewModel = self.presenter.listInfoLifeFilter[indexPath.row]
        cell.setValuesFilter(name: filter.name, image: filter.image, selected: filter.selected)

        return cell
    }
}

extension InfoLifeFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeFilter = false
        if self.presenter.listInfoLifeFilter[indexPath.row].selected {
            self.presenter.listInfoLifeFilter[indexPath.row].selected = false
        } else {
            self.presenter.listInfoLifeFilter[indexPath.row].selected = true
        }
        
        // verifica se houve mudança no filtro
        if self.presenter.listInfoLifeFilter[indexPath.row].selected != listInfoLifeFilterBackup[indexPath.row].selected {
            changeFilter = true
        }
        
        self.collectionViewInfoLife.reloadData()
    }
}

extension InfoLifeFilterViewController: UICollectionViewDelegateFlowLayout {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewInfoLife?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize: CGSize = collectionView.bounds.size

        if Device.isIPhone5() {
            cellSize.width = 82.0
            cellSize.height = 82.0
        } else {
            var size: CGSize = self.collectionViewInfoLife.frame.size
            size.width -= 20 // espaciamento entre as células
            let cellSizeNew: CGFloat = size.width / 3.0
            cellSize.width = cellSizeNew
            cellSize.height = cellSizeNew
        }
        return cellSize
    }
}
