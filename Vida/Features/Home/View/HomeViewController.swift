//
//  HomeViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var collectionViewCards: UICollectionView!
    @IBOutlet weak var viewShadow: UIView!
    @IBOutlet weak var constraintHeghtViewScroll: NSLayoutConstraint!
    @IBOutlet weak var constraintTopCollectionView: NSLayoutConstraint!
    
//    fileprivate var arrayHome: [AnyObject]!
    fileprivate var arrayHome: [HomeCard]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Device.isIPhone5() {
            constraintTopCollectionView.constant = 20.0
            constraintHeghtViewScroll.constant = 70.0
        }

        self.collectionViewCards.register(UINib(nibName: "HomeCardCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "HomeCardCollectionViewCell")
        
        self.collectionViewCards.contentInset = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)
        self.collectionViewCards.decelerationRate = UIScrollView.DecelerationRate.fast

        arrayHome = HomeCard.getValues()
        
//        self.viewShadowTabBar(view: self.viewShadow)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func pressButtonLogin(_ sender: Any) {
        if appDelegate.login == nil {
            LoginRouter().present(at: self.navigationController!)
        }
    }
}

extension HomeViewController: HomeViewProtocol {
    
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayHome.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCollectionViewCell",
                                                          for: indexPath) as! HomeCardCollectionViewCell
            
            cell.setValuesViews(homeCard: arrayHome[indexPath.row], indexSelected: indexPath.row)
            cell.delegate = self
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCollectionViewCell",
                                                          for: indexPath) as! HomeCardCollectionViewCell

            cell.setValuesViews(homeCard: arrayHome[indexPath.row], indexSelected: indexPath.row)
            cell.delegate = self
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCardCollectionViewCell",
                                                          for: indexPath) as! HomeCardCollectionViewCell

            cell.setValuesViews(homeCard: arrayHome[indexPath.row], indexSelected: indexPath.row)
            cell.delegate = self
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right
        if Device.isIPhone5() {
            cellSize.width += 15.0
            cellSize.height -= 30.0
        }
        
        return cellSize
    }
}

extension HomeViewController: HomeCardCollectionViewProtocol {
    
    func callMainDetail(indexSelected: Int) {
//        HomeRouter().showDetail(at: appDelegate.navController!,
//                                indexSelected: indexSelected,
//                                homeCard: arrayHome[indexSelected])
    }
}
