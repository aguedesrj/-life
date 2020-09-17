//
//  PartnersViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class PartnersViewController: BaseViewController {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var collectionViewPartners: UICollectionView!
    
    var listPartners: [PartnersViewModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = "Parceiros Vida"
        
        collectionViewPartners.register(UINib(nibName: "PartnersCollectionViewCell", bundle: nil),
                                                   forCellWithReuseIdentifier: "PartnersCollectionViewCell")


        listPartners.append(PartnersViewModel.init(title: "Estabelecimentos", description: "Descontos em lojas credenciadas", image: "iconPartnersEstablishments"))
        listPartners.append(PartnersViewModel.init(title: "Profissionais de Saúde", description: "Busque por especialistas", image: "iconPartnersProfessionals"))
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
}

extension PartnersViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listPartners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PartnersCollectionViewCell",
                                                      for: indexPath) as! PartnersCollectionViewCell
        
        cell.setValues(partnersViewModel: listPartners[indexPath.row])
        return cell
    }
}

extension PartnersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if Util.isNotConnectedToNetwork() {
            self.showAlert(message: Constrants.failureConnectedToNetwork)
            return
        }
        
        switch indexPath.row {
            case 0:
                EstablishmentsRouter().show(at: self.appDelegate.navController!)
                break
            default:
                ProfessionalsRouter().show(at: self.appDelegate.navController!)
                break
        }
    }
}

extension PartnersViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var cellSize: CGSize = collectionView.bounds.size
        if Device.isIPhone5() {
            cellSize.width = 293.0
            cellSize.height = 200.0
        } else {
            cellSize.width = 343.0
            cellSize.height = 225.0
        }
        return cellSize
    }
}
