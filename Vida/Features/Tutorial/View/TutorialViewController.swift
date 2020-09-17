//
//  TutorialViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class TutorialViewController: BaseViewController {

    @IBOutlet weak var collectionViewCards: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var constraintTopCollectionView: NSLayoutConstraint!
    @IBOutlet weak var constraintBottonCollectionView: NSLayoutConstraint!
    @IBOutlet weak var constraintTopLabelDescription: NSLayoutConstraint!
    
    fileprivate var array: [TutorialCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        constraintTopLabelDescription.constant = 42.0
        if Device.isIPhone5() {
            constraintTopLabelDescription.constant = 20.0
            constraintTopCollectionView.constant = 170
            constraintBottonCollectionView.constant = 60
        } else if Device.isIPhone6() {
            constraintTopCollectionView.constant = 160
            constraintBottonCollectionView.constant = 60
        }
        
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(red: 213.0/255.0, green: 184.0/255.0, blue: 218.0/255.0, alpha: 1.0)
        pageControl.currentPageIndicatorTintColor = Color.primary.value

        self.collectionViewCards.register(UINib(nibName: "TutorialCardCollectionViewCell", bundle: nil),
                                          forCellWithReuseIdentifier: "TutorialCardCollectionViewCell")
        
        self.collectionViewCards.contentInset = UIEdgeInsets.init(top: 0, left: 40, bottom: 0, right: 40)
        self.collectionViewCards.decelerationRate = UIScrollView.DecelerationRate.fast
        
        array = TutorialCard.getValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func pressButtonJump(_ sender: Any) {
        UserDefaults.standard.set(Constrants.kTutorial, forKey: Constrants.kTutorial)
        self.dismiss(animated: true, completion: nil)
        MainRouter().show(at: self.appDelegate.navController!)
    }
}

extension TutorialViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCardCollectionViewCell",
                                                      for: indexPath) as! TutorialCardCollectionViewCell
        switch indexPath.row {
        case 0:
            cell.setValuesViews(tutorialCard: array[indexPath.row], indexSelected: indexPath.row)
        case 1:
            cell.setValuesViews(tutorialCard: array[indexPath.row], indexSelected: indexPath.row)
        default:
            cell.setValuesViews(tutorialCard: array[indexPath.row], indexSelected: indexPath.row)
        }
        
        cell.delegate = self
        return cell
    }
}

extension TutorialViewController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionViewCards.contentOffset, size: collectionViewCards.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionViewCards.indexPathForItem(at: visiblePoint)
        pageControl.currentPage = (indexPath?.item)!
    }
}

extension TutorialViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        
        cellSize.width -= collectionView.contentInset.left
        cellSize.width -= collectionView.contentInset.right
        if Device.isIPhone5() {
            cellSize.width += 15.0
            cellSize.height += 100.0
        } else if Device.isIPhoneXAndXS() {
            cellSize.height -= 30.0
        }
        
        return cellSize
    }
}

extension TutorialViewController: TutorialCardCollectionViewProtocol {
    
    func callMainDetail(indexSelected: Int) {
        TutorialRouter().showDetail(at: self,
                                indexSelected: indexSelected,
                                tutorialCard: array[indexSelected])
    }
}
