//
//  HomeViewController.swift
//  Vida
//
//  Created by Vida on 08/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var collectionViewCards: UICollectionView!
    
    var presenter: HomePresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionViewCards.register(UINib(nibName: "HomeCardForEmployeesViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "HomeCardForEmployeesViewCell")
        
        self.collectionViewCards.register(UINib(nibName: "HomeCardCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "HomeCardCollectionViewCell")
        
        self.collectionViewCards.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.collectionViewCards.decelerationRate = UIScrollView.DecelerationRate(rawValue: 0.005000)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension HomeViewController: HomeViewProtocol {

}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardForEmployeesViewCell",
                                                          for: indexPath) as! HomeCardForEmployeesViewCell
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCollectionViewCell",
                                                          for: indexPath) as! HomeCardCollectionViewCell
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCollectionViewCell",
                                                          for: indexPath) as! HomeCardCollectionViewCell
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right
        
        return cellSize

    }
}
