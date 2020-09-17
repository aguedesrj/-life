//
//  DrinkWaterViewController.swift
//  Vida
//
//  Created by André Lessa Guedes on 03/01/20.
//  Copyright © 2020 Vida. All rights reserved.
//

import UIKit

class DrinkWaterViewController: BaseViewController {

    @IBOutlet weak var buttonBack: UIButton!
    
    var delegate: StretchingViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBack.imageView?.tintColor = Color.primary.value
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        delegate.noReloadTable()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pressButton(_ sender: Any) {
        let url: String = "\(appDelegate.environment.urlMainWeb)publicacao/8-importancia-beber-agua/\(appDelegate.login!.token)"
        
        UIApplication.shared.open(URL(string: url)!,
                                  options: [:],
                                  completionHandler: nil)
    }
}
