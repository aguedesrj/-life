//
//  TutorialDetailViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class TutorialDetailViewController: BaseViewController {

    @IBOutlet weak var tableViewDetail: UITableView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageViewBackground: UIImageView!
    @IBOutlet weak var labelDescription: UILabel!
    
    var indexSelected: Int!
    var tutorialCard: TutorialCard!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.labelTitle.text = tutorialCard.titleDetail
        self.tableViewDetail.register(UINib(nibName: "TutorialDetailTableViewCell", bundle: nil),
                                      forCellReuseIdentifier: "TutorialDetailTableViewCell")
        
        self.imageViewBackground.image = UIImage(named: tutorialCard.imageBackgroundDetail)
        
        if (indexSelected == 1) {
            labelTitle.textColor = Color.primary.value
            labelDescription.textColor = Color.primary.value
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension TutorialDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tutorialCard.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TutorialDetailTableViewCell",
                                                 for: indexPath) as! TutorialDetailTableViewCell
        
        cell.selectionStyle = .none
        cell.setValues(tutorialCardDetail: tutorialCard.list[indexPath.row],
                       indexSelected: indexPath.row)
        return cell
    }
}
