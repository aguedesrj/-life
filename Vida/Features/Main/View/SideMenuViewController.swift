//
//  SideMenuViewController.swift
//  ProjetoHome
//
//  Created by Vida
//  Copyright © 2019 Ebix. All rights reserved.
//

import UIKit
import SideMenu

protocol SideMenuViewDelegate {
    func positionTabBarNotLoggedIn()
    func takePicture()
    func choosePhoto()
}

class SideMenuViewController: BaseViewController {

    @IBOutlet var viewMain: GradientView!
    
    @IBOutlet weak var viewLoggedIn: UIView!
    @IBOutlet weak var imageViewLogged: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonExit: UIButton!
    @IBOutlet weak var constraintRightViewLoggedIn: NSLayoutConstraint!
    @IBOutlet weak var constraintLeftViewLoggedIn: NSLayoutConstraint!
    
    @IBOutlet weak var viewNotLoggedIn: UIView!
    @IBOutlet weak var buttonMore: UIButton!
    @IBOutlet weak var buttonMoreLoggedIn: UIButton!
    @IBOutlet weak var buttonClient: UIButton!
    @IBOutlet weak var constraintRightViewNotLoggedIn: NSLayoutConstraint!
    @IBOutlet weak var constraintLeftViewNotLoggedIn: NSLayoutConstraint!
    
    var delegate: SideMenuViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cornerRadius: CGFloat = 20
        let borderColor: UIColor = UIColor(red: 141.0/255.0, green: 62.0/255.0, blue: 155.0/255.0, alpha: 1.0)
        let borderWidth: CGFloat = 2

        viewMain.backgroundColor = .white
        viewMain.topColor = UIColor(red: 98.0/255.0, green: 19.0/255.0, blue: 109.0/255.0, alpha: 1.0)
        viewMain.bottomColor = UIColor(red: 129.0/255.0, green: 41.0/255.0, blue: 144.0/255.0, alpha: 1.0)
        
        // não logado
        viewNotLoggedIn.backgroundColor = .clear
        buttonMore.layer.cornerRadius = cornerRadius
        buttonMore.layer.borderColor = borderColor.cgColor
        buttonMore.layer.borderWidth = borderWidth
        buttonClient.layer.cornerRadius = cornerRadius
        
        // logado
        viewLoggedIn.backgroundColor = .clear
        buttonMoreLoggedIn.layer.cornerRadius = cornerRadius
        buttonMoreLoggedIn.layer.borderColor = borderColor.cgColor
        buttonMoreLoggedIn.layer.borderWidth = borderWidth
        buttonExit.layer.cornerRadius = cornerRadius
        buttonExit.layer.borderColor = borderColor.cgColor
        buttonExit.layer.borderWidth = borderWidth
    
        self.changeImageViewPhoto()
        
        if Device.isIPhone5() {
            let constant: CGFloat = 20.0
            constraintRightViewLoggedIn.constant = constant
            constraintLeftViewLoggedIn.constant = constant
            
            constraintRightViewNotLoggedIn.constant = constant
            constraintLeftViewNotLoggedIn.constant = constant
        }
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        let tapGesTureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imagePhotoUser(tapGestureRecognizer:)))
        imageViewLogged.isUserInteractionEnabled = true
        imageViewLogged.addGestureRecognizer(tapGesTureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        viewLoggedIn.isHidden = true
        viewNotLoggedIn.isHidden = true
        if (self.appDelegate.login == nil) {
            viewNotLoggedIn.isHidden = false
        } else {
            viewLoggedIn.isHidden = false
            labelName.text = self.appDelegate.login?.user?.name
            labelDescription.text = self.appDelegate.login?.user?.typeProfile.capitalized
        }
        
        // verifica se tem foto.
        self.getPhotoLocalUser()
    }
    
    @IBAction func pressButtonMore(_ sender: Any) {
        dismiss(animated: true) {
            TutorialRouter().presentDetailProduct(at: self.appDelegate.navController!)
        }
    }
    
    @IBAction func pressButtonClient(_ sender: Any) {
        dismiss(animated: true) {
            LoginRouter().present(at: self.appDelegate.navController!, delegateViewController: nil)
        }
    }
    
    @IBAction func pressButtonExit(_ sender: Any) {
        // sai do chat
        MainPresenter().logouChat()
        
        UserDefaults.standard.removeObject(forKey: Constrants.kLogin)
        UserDefaults.standard.removeObject(forKey: Constrants.kPassword)
        self.appDelegate.login = nil
        viewLoggedIn.isHidden = true
        viewNotLoggedIn.isHidden = false
        self.delegate.positionTabBarNotLoggedIn()
        
        // exibir a tela de login
        pressButtonClient(self)
    }
}

extension SideMenuViewController {
    
    fileprivate func getPhotoLocalUser() {
        if self.appDelegate.login != nil && self.appDelegate.login?.user != nil {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                let filename: String = "\((self.appDelegate.login?.user!.id)!).png"
                let imagePhoto: UIImage? = UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(filename).path)
                if (imagePhoto != nil) {
                    imageViewLogged.image = imagePhoto
                }
            }
        }
    }
    
    @objc func imagePhotoUser(tapGestureRecognizer: UITapGestureRecognizer) {
        openCameraLibraryAlert()
    }
    
    fileprivate func changeImageViewPhoto() {
        let sizeImageViewLogged: CGSize = imageViewLogged.frame.size
        imageViewLogged.layer.cornerRadius = sizeImageViewLogged.width / 2
        imageViewLogged.layer.borderColor = UIColor.white.cgColor
        imageViewLogged.layer.borderWidth = 2
        imageViewLogged.layer.masksToBounds = true
    }
    
    fileprivate func openCameraLibraryAlert() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // Create the actions
        let cameraAction = UIAlertAction(title: "Tirar Foto", style: UIAlertAction.Style.default) {
            UIAlertAction in

            self.dismiss(animated: true) {
                self.delegate.takePicture()
            }
        }
        
        let photoAction = UIAlertAction(title: "Escolher Foto", style: UIAlertAction.Style.default) {
            UIAlertAction in
            
            self.dismiss(animated: true) {
                self.delegate.choosePhoto()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.destructive) {
            UIAlertAction in
        }
        
        // Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(photoAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
