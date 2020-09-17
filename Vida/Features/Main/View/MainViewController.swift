//
//  HomeViewController.swift
//  ProjetoHome
//
//  Created by Vida
//  Copyright © 2019 Ebix. All rights reserved.
//

import UIKit
import SideMenu
import AVFoundation
import CropViewController

class MainViewController: BaseViewController {

    @IBOutlet var viewBotton: UIView!
    @IBOutlet var viewPageControl: UIView!
    @IBOutlet var buttonInfoLife: UIButton!
    @IBOutlet var buttonPartners: UIButton!
    @IBOutlet var buttonChat: UIButton!
    @IBOutlet var viewShadow: UIView!
    @IBOutlet var buttonQrCode: UIButton!
    @IBOutlet var viewButtonQrCode: GradientView!
    @IBOutlet var buttonSchedule: UIButton!
    
    fileprivate var indexPageSelectedForLogin: Int = 0
    fileprivate var indexPageSelected: Int = 0
    fileprivate var pageViewController : UIPageViewController?
    fileprivate var viewControllers = [UIViewController]()
    fileprivate var croppingStyle = CropViewCroppingStyle.default
    fileprivate var croppedRect = CGRect.zero
    fileprivate var croppedAngle = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                       navigationOrientation : .horizontal,
                                                       options: nil)
        self.pageViewController?.view.frame.size = self.viewPageControl.frame.size
        self.viewPageControl.addSubview(self.pageViewController!.view)
        
        viewControllers.append(InfoLifeViewController(nibName: "InfoLifeViewController", bundle: nil))
        viewControllers.append(ScheduleViewController(nibName: "ScheduleViewController", bundle: nil))
        viewControllers.append(PartnersViewController(nibName: "PartnersViewController", bundle: nil))
        viewControllers.append(ListChatViewController(nibName: "ListChatViewController", bundle: nil))
        
        self.pageViewController?.setViewControllers([viewControllers[0]], direction: .forward, animated: true, completion: nil)

        let sideMenuViewController = UIStoryboard(name: "SideMenuViewController", bundle: nil).instantiateViewController(withIdentifier: "left") as! SideMenuViewController
        
        sideMenuViewController.delegate = self
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController:
            sideMenuViewController)
        
        menuLeftNavigationController.navigationBar.tintColor = .white
        menuLeftNavigationController.navigationBar.isTranslucent = false
        
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        SideMenuManager.default.menuPresentMode = .menuSlideIn
        
        SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.default.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        
        SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
        SideMenuManager.default.menuFadeStatusBar = false
        
        SideMenuManager.default.menuEnableSwipeGestures = true
        
        self.showSideMenu()
        
        self.viewShadowTabBar(view: self.viewShadow)
        
        //default
        changeButtonsTabBar(index: indexPageSelected)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // verifica se veio do push
        if self.appDelegate.pageIdPush != nil && self.appDelegate.login != nil {
            if self.appDelegate.pageIdPush == "INFOVIDA" {
                changePageForPush(indexPageSelected: 0)
            } else if self.appDelegate.pageIdPush == "AGENDA" ||
                self.appDelegate.pageIdPush == Constrants.kStretching ||
                self.appDelegate.pageIdPush == Constrants.kDrinkWater {
                
                if (self.appDelegate.pageIdPush == Constrants.kStretching ||
                    self.appDelegate.pageIdPush == Constrants.kDrinkWater) {
                    
                    // serve para abrir a tela de alongamento ou de beber água depois que lista as agendas.
                    self.appDelegate.fromPush = self.appDelegate.pageIdPush
                }
                changePageForPush(indexPageSelected: 1)
            } else if self.appDelegate.pageIdPush == "CHAT" {
                changePageForPush(indexPageSelected: 3)
            }
            self.appDelegate.pageIdPush = nil
        }
        
        // verifica se não está logado
        if (self.appDelegate.login == nil) {
            LoginRouter().present(at: self.appDelegate.navController!,
                                  delegateViewController: nil)
        }
    }
    
    @IBAction func pressButtonInfoLife(_ sender: Any) {
        indexPageSelected = 0
        changeButtonsTabBar(index: indexPageSelected)
        self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                    direction: .forward,
                                                    animated: false,
                                                    completion: nil)
    }
    
    @IBAction func pressButtonSchedule(_ sender: Any) {
        if (self.appDelegate.login == nil) {
            indexPageSelectedForLogin = 1
            // abrir a tela de login
            LoginRouter().present(at: self.navigationController!, delegateViewController: self)
            return
        }
        indexPageSelected = 1
        changeButtonsTabBar(index: indexPageSelected)
        self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                    direction: .forward,
                                                    animated: false,
                                                    completion: nil)
    }
    
    @IBAction func pressButtonPartners(_ sender: Any) {
        if (self.appDelegate.login == nil) {
            indexPageSelectedForLogin = 2
            // abrir a tela de login
            LoginRouter().present(at: self.navigationController!, delegateViewController: self)
            return
        }
        indexPageSelected = 2
        changeButtonsTabBar(index: indexPageSelected)
        self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                    direction: .forward,
                                                    animated: false,
                                                    completion: nil)
    }
    
    @IBAction func pressButtonChat(_ sender: Any) {
        if (self.appDelegate.login == nil) {
            indexPageSelectedForLogin = 3
            // abrir a tela de login
            LoginRouter().present(at: self.navigationController!, delegateViewController: self)
            return
        }
        indexPageSelected = 3
        changeButtonsTabBar(index: indexPageSelected)
        self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                    direction: .reverse,
                                                    animated: false,
                                                    completion: nil)
    }
    
    @IBAction func pressButtonQrCode(_ sender: Any) {
        if (self.appDelegate.login == nil) {
            // abrir a tela de login
            LoginRouter().present(at: self.navigationController!, delegateViewController: nil)
            return
        }
        
        if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
            ScanQrCodeRoute().show(at: self.navigationController!)
        } else {
            AVCaptureDevice.requestAccess(for: .video) { (granted: Bool) in
                if (granted) {
                    ScanQrCodeRoute().show(at: self.navigationController!)
                } else {
                    // Sem permissão
                    self.showAlert(message: "O Vida não possui permissão de acessar a câmera.")
                    return
                }
            }
        }
    }
}

extension MainViewController {
    
    fileprivate func changePageForPush(indexPageSelected: Int) {
        self.indexPageSelected = indexPageSelected
        
        changeButtonsTabBar(index: self.indexPageSelected)
        self.pageViewController?.setViewControllers([viewControllers[self.indexPageSelected]],
                                                    direction: .reverse,
                                                    animated: false,
                                                    completion: nil)
    }
    
    fileprivate func changeButtonsTabBar(index: Int) {
        buttonInfoLife.setImage(UIImage(named: "iconMainTabBarLifeOff"), for: .normal)
        buttonSchedule.setImage(UIImage(named: "iconMainTabBarScheduleOff"), for: .normal)
        buttonPartners.setImage(UIImage(named: "iconMainTabBarPartnersOff"), for: .normal)
        buttonChat.setImage(UIImage(named: "iconMainTabBarChatOff"), for: .normal)
        
        switch index {
        case 0:
            buttonInfoLife.setImage(UIImage(named: "iconMainTabBarLifeOn"), for: .normal)
            break
        case 1:
            buttonSchedule.setImage(UIImage(named: "iconMainTabBarScheduleOn"), for: .normal)
            break
        case 2:
            buttonPartners.setImage(UIImage(named: "iconMainTabBarPartnersOn"), for: .normal)
            break
        default:
            buttonChat.setImage(UIImage(named: "iconMainTabBarChatOn"), for: .normal)
            break
        }
    }

    fileprivate func viewShadowTabBar(view: UIView) {
        view.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor, UIColor.white.cgColor]
        gradient.locations = [0.0, 1.0, 1.0]
        view.layer.addSublayer(gradient)
    }

}

extension MainViewController: SideMenuViewDelegate {
    
    func positionTabBarNotLoggedIn() {
        // remover as viewsController já criadas.
        viewControllers.removeAll()
        
        // recriadas.
        viewControllers.append(InfoLifeViewController(nibName: "InfoLifeViewController", bundle: nil))
        viewControllers.append(ScheduleViewController(nibName: "ScheduleViewController", bundle: nil))
        viewControllers.append(PartnersViewController(nibName: "PartnersViewController", bundle: nil))
        viewControllers.append(ListChatViewController(nibName: "ListChatViewController", bundle: nil))
        
        self.pressButtonInfoLife(self)
    }
    
    func takePicture() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func choosePhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: {
                if #available(iOS 11, *) {
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.primary.value], for: .normal)
                    UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.primary.value], for: .highlighted)
                } else {
                    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: 0,vertical: -60), for:UIBarMetrics.default)
                }

            })
        }
    }
}

extension MainViewController: LoginViewDelegate {
    
    func goTabBarSelected() {
        switch indexPageSelectedForLogin {
        case 1:
            indexPageSelected = indexPageSelectedForLogin
            changeButtonsTabBar(index: indexPageSelected)
            self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                        direction: .forward,
                                                        animated: false,
                                                        completion: nil)
            break
        case 2:
            indexPageSelected = indexPageSelectedForLogin
            changeButtonsTabBar(index: indexPageSelected)
            self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                        direction: .forward,
                                                        animated: false,
                                                        completion: nil)
            break
        case 3:
            indexPageSelected = indexPageSelectedForLogin
            changeButtonsTabBar(index: indexPageSelected)
            self.pageViewController?.setViewControllers([viewControllers[indexPageSelected]],
                                                        direction: .reverse,
                                                        animated: false,
                                                        completion: nil)
            break
        default:
            break
        }
    }
}

extension MainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        cropController.customAspectRatio = CGSize(width: 250, height: 250) // tamanho da área da foto.
        cropController.aspectRatioPreset = .presetCustom;
        cropController.aspectRatioLockEnabled = true
        
        cropController.resetAspectRatioEnabled = false
        cropController.aspectRatioPickerButtonHidden = true
        
        cropController.rotateButtonsHidden = true
        cropController.rotateClockwiseButtonHidden = true
        
        cropController.doneButtonTitle = "Selecionar"
        cropController.cancelButtonTitle = "Cancelar"
        
        picker.dismiss(animated: true, completion: {
            self.appDelegate.navController!.present(cropController, animated: true, completion: nil)
        })
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        let data = image.jpegData(compressionQuality: 1.0) ?? image.pngData()
        let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL
        do {
            let filename: String = "\((self.appDelegate.login?.user!.id)!).png"
            try data!.write(to: directory!.appendingPathComponent(filename)!)
//            imageViewLogged.image = image
//            self.changeImageViewPhoto()
        } catch {
            print(error.localizedDescription)
        }
        
        // converter a foto em base64
//        var imageBase64: String = self.convertImageToBase64(image: image)

        cropViewController.dismiss(animated: true, completion: nil)
    }
}
