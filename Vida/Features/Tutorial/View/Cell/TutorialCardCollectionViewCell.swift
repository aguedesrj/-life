//
//  TutorialCardCollectionViewCell.swift
//  Vida
//
//  Created by Vida on 14/04/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

protocol TutorialCardCollectionViewProtocol {
    func callMainDetail(indexSelected: Int)
}

class TutorialCardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var tableViewCell: UITableView!
    @IBOutlet weak var constraintTopTableView: NSLayoutConstraint!
    
    var delegate: TutorialCardCollectionViewProtocol!
    
    fileprivate var indexSelected: Int!
    fileprivate var arrayDetail: [TutorialCardDetail]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewMain.layer.cornerRadius = 8.0
        viewMain.layer.shadowColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.17).cgColor
        viewMain.layer.shadowOffset = CGSize.zero
        viewMain.layer.shadowOpacity = 1.5
        viewMain.layer.shadowRadius = 4.0
        viewMain.layer.masksToBounds = false
        
        self.tableViewCell.register(UINib(nibName: "TutorialCardTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "TutorialCardTableViewCell")
        
        self.tableViewCell.rowHeight = 60.0
        self.tableViewCell.dataSource = self
        
        if Device.isIPhone5() {
            constraintTopTableView.constant = 15.0
        }
    }
    
    func setValuesViews(tutorialCard: TutorialCard, indexSelected: Int) {
        self.arrayDetail = tutorialCard.list
        self.indexSelected = indexSelected
        
        labelTitle.text = tutorialCard.title
        tableViewCell.reloadData()
    }
    
    @IBAction func pressButtonSeeItAll(_ sender: Any) {
        delegate.callMainDetail(indexSelected: self.indexSelected)
    }
}

extension TutorialCardCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialCardTableViewCell",
                                                 for: indexPath) as! TutorialCardTableViewCell
        
        cell.selectionStyle = .none
        cell.setValues(tutorialCardDetail: arrayDetail[indexPath.row])
        return cell
    }
}
