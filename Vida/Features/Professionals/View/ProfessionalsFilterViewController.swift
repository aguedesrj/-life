//
//  ProfessionalsFilterViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import DropDown

protocol ProfessionalsFilterViewProtocol {
    func callServiceWithFilter(changeFilter: Bool)
}

class ProfessionalsFilterViewController: BaseViewController {

    @IBOutlet weak var viewName: UIView!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var viewSpecialty: UIView!
    @IBOutlet weak var labelSpecialty: UILabel!
    @IBOutlet weak var buttonOK: UIButton!
    @IBOutlet weak var collectionViewRegion: UICollectionView!
    @IBOutlet weak var constraintHeightCollectionViewRegion: NSLayoutConstraint!
    
    var presenter: ProfessionalsPresenter!
    var delegate: ProfessionalsFilterViewProtocol!
    
    fileprivate let widthEstimatedCollectionViewRegion: Int = 68
    fileprivate let heightEstimatedCollectionViewRegion: Int = 35
    fileprivate let chooseArticleDropDown = DropDown()
    fileprivate var changeFilter: Bool = false
    fileprivate var listStateFederationBackup: [StateFederationFilterViewModel] = []
    fileprivate var healthSpecialtyBackup: HealthSpecialty?
    fileprivate var nameProfessionalBackup: String = ""
    
    lazy var dropDowns: [DropDown] = {
        return [
            self.chooseArticleDropDown
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        collectionViewRegion.register(UINib(nibName: "EstablishmentsUfCollectionViewCell", bundle: nil),
                                           forCellWithReuseIdentifier: "EstablishmentsUfCollectionViewCell")
        collectionViewRegion.backgroundColor = UIColor.white
        collectionViewRegion.delaysContentTouches = false

        let linesDecimal = Double(self.presenter.listStateFederationFilter.count) / 4.0
        constraintHeightCollectionViewRegion.constant *= CGFloat(ceil(linesDecimal))
        
        layoutViews()
        
        prepareDropdown()
        
        // seta os dados
        textFieldName.text = self.presenter.nameProfessional
        if self.presenter.healthSpecialtySelected != nil {
            labelSpecialty.text = self.presenter.healthSpecialtySelected?.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listStateFederationBackup = self.presenter.listStateFederationFilter
        healthSpecialtyBackup = self.presenter.healthSpecialtySelected
        nameProfessionalBackup = self.presenter.nameProfessional
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.actionChoiceSpecialty))
        self.viewSpecialty.addGestureRecognizer(gesture)
    }
    
    @objc func actionChoiceSpecialty() {
        chooseArticleDropDown.show()
    }
    
    @IBAction func pressButtonOK(_ sender: Any) {
        self.presenter.nameProfessional = self.textFieldName.text!
        
//        if self.presenter.nameProfessional != nameProfessionalBackup {
//            changeFilter = true
//        }
//
//        if (self.presenter.healthSpecialtySelected != nil && healthSpecialtyBackup != nil) && (self.presenter.healthSpecialtySelected?.id != healthSpecialtyBackup?.id) {
//            changeFilter = true
//        }
        
        changeFilter = true
        
        delegate.callServiceWithFilter(changeFilter: changeFilter)
        self.dismiss(animated: true, completion: nil)
    }
}

extension ProfessionalsFilterViewController {
    
    fileprivate func layoutViews() {
        viewName.backgroundColor = UIColor(red: 243.0/255.0,
                                           green: 234.0/255.0,
                                           blue: 244.0/255.0,
                                           alpha: 1.0)
        viewName.layer.cornerRadius = 12
        viewName.layer.borderColor = Color.primary.value.cgColor
        viewName.layer.borderWidth = 2
        textFieldName.attributedPlaceholder =
            NSAttributedString(string: "Procure pelo nome do profissional",
                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 186.0/255.0,
                                                                                            green: 137.0/255.0,
                                                                                            blue: 193.0/255.0,
                                                                                            alpha: 1.0)])

        viewSpecialty.layer.cornerRadius = 12
        viewSpecialty.layer.borderColor = Color.primary.value.cgColor
        viewSpecialty.layer.borderWidth = 2
        viewSpecialty.backgroundColor = UIColor.white
        labelSpecialty.textColor = Color.primary.value
        
        let size: CGSize = buttonOK.frame.size
        buttonOK.layer.cornerRadius = size.height / 2
        buttonOK.layer.borderWidth = 2
        buttonOK.layer.borderColor = Color.primary.value.cgColor
        buttonOK.layer.masksToBounds = false
    }
    
    fileprivate func prepareDropdown() {
        let appearance = DropDown.appearance()
        appearance.backgroundColor = UIColor(white: 1, alpha: 1)
        appearance.selectionBackgroundColor = UIColor(red: 0.6494, green: 0.8155, blue: 1.0, alpha: 0.2)
        appearance.cornerRadius = 3
        appearance.shadowColor = UIColor(white: 0.6, alpha: 1)
        appearance.shadowOpacity = 0.9
        appearance.shadowRadius = 25
        appearance.animationduration = 0.25
        appearance.textColor = .darkGray
        appearance.cellHeight = 65
        
        self.chooseArticleDropDown.anchorView = self.viewSpecialty
        self.chooseArticleDropDown.bottomOffset = CGPoint(x: 0, y: self.viewSpecialty.bounds.height)
        self.chooseArticleDropDown.dataSource = self.presenter.getListStringHealthSpecialty()
        self.chooseArticleDropDown.selectionAction = { [weak self] (index, item) in
            let arrayItem: [String] = item.components(separatedBy: "|")
            let id: Int = Int(arrayItem[0])!
            let name: String = arrayItem[1]
            self!.labelSpecialty.text = name
            self!.presenter.healthSpecialtySelected = HealthSpecialty.init(id: id, name: name)
        }
        
        dropDowns.forEach { $0.dismissMode = .onTap }
        dropDowns.forEach { $0.direction = .any }
        dropDowns.forEach {
            $0.cellNib = UINib(nibName: "HealthSpecialtyDropDownCell", bundle: nil)
            $0.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
                guard let cell = cell as? HealthSpecialtyDropDownCell else { return }
                let arrayItem: [String] = item.components(separatedBy: "|")
                cell.optionLabel.text = "\(arrayItem[1])"
                cell.optionLabel.font = UIFont(name: "OpenSans-SemiBold", size: 12)
            }
        }
    }
}

extension ProfessionalsFilterViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter.listStateFederationFilter.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EstablishmentsUfCollectionViewCell", for: indexPath) as! EstablishmentsUfCollectionViewCell
        
        let stateFederation: StateFederationFilterViewModel = self.presenter.listStateFederationFilter[indexPath.row]
        
        if (stateFederation.selected) {
            cell.labelTitle.textColor = UIColor.white
            cell.viewMain.backgroundColor = Color.primary.value
        } else {
            cell.labelTitle.textColor = Color.primary.value
            cell.viewMain.backgroundColor = UIColor.white
        }
        cell.labelTitle.text = "\(stateFederation.code)"
        
        return cell
    }
}

extension ProfessionalsFilterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeFilter = false
        if self.presenter.listStateFederationFilter[indexPath.row].selected {
            self.presenter.listStateFederationFilter[indexPath.row].selected = false
        } else {
            self.presenter.listStateFederationFilter[indexPath.row].selected = true
        }
        self.collectionViewRegion.reloadData()
        
        // verifica se houve mudança no filtro
        if self.presenter.listStateFederationFilter[indexPath.row].selected != listStateFederationBackup[indexPath.row].selected {
            
            changeFilter = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10.0
    }
}

extension ProfessionalsFilterViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var cellSize: CGSize = collectionView.bounds.size
        cellSize.width = CGFloat(widthEstimatedCollectionViewRegion)
        cellSize.height = CGFloat(heightEstimatedCollectionViewRegion)
        
        return cellSize
    }
}
