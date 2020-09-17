//
//  DetailProductViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

class DetailProductViewController: UIViewController {

    @IBOutlet weak var imageViewSetaEmployees: UIImageView!
    @IBOutlet weak var imageViewSetaPartners: UIImageView!
    @IBOutlet weak var imageViewSetaCompanies: UIImageView!
    
    fileprivate var array: [TutorialCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageViewSetaEmployees.tintColor = Color.second.value
        imageViewSetaPartners.tintColor = Color.primary.value
        imageViewSetaCompanies.tintColor = Color.second.value
        
        array = TutorialCard.getValues()
    }
    
    @IBAction func pressButtonClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pressButtonEmployees(_ sender: Any) {
        TutorialRouter().showDetail(at: self, indexSelected: 0, tutorialCard: array[0])
    }
    
    @IBAction func pressButtonPartners(_ sender: Any) {
        TutorialRouter().showDetail(at: self, indexSelected: 1, tutorialCard: array[1])
    }
    
    @IBAction func pressButtonCompanies(_ sender: Any) {
        TutorialRouter().showDetail(at: self, indexSelected: 2, tutorialCard: array[2])
    }
}
