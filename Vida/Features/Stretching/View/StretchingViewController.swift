//
//  StretchingViewController.swift
//  Vida
//
//  Created by Vida on 23/10/19.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit

protocol StretchingViewDelegate {
    func noReloadTable()
}

class StretchingViewController: BaseViewController {

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
    
    @IBAction func pressButtonAlongamento(_ sender: Any) {
        let url: String = "\(appDelegate.environment.urlMainWeb)publicacao/7-lista-alongamentos/\(appDelegate.login!.token)"
        
        UIApplication.shared.open(URL(string: url)!,
                                  options: [:],
                                  completionHandler: nil)
    }
}
