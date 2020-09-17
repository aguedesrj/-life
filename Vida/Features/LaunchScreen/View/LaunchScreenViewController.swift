//
//  LaunchScreenViewController.swift
//  Vida
//
//  Created by Vida on 08/04/2019.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class LaunchScreenViewController: BaseViewController {

    fileprivate var presenter: LaunchScreenPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = LaunchScreenPresenter(view: self)
        
        autoLogin()
        
        var splashScreenFile: String = "splash_screen_X"
        if (Device.isIPhone4() || Device.isIPhone5() || Device.isIPhone6() || Device.isIPhonePlus()) {
            splashScreenFile = "splash_screen"
        }
        
        let urlMovie = Bundle.main.path(forResource: splashScreenFile, ofType: "mov")
        
        let url = URL(fileURLWithPath: urlMovie!)
        let videoPlayer = AVPlayer(url: url as URL)
        NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                               object: videoPlayer.currentItem)
        
        let playerLayer = AVPlayerLayer(player: videoPlayer)
        let screenBounds = UIScreen.main.bounds
        var framePlayerLayer = playerLayer.frame.size
        
        print(self.view.frame)
        
        framePlayerLayer.width = screenBounds.width
        framePlayerLayer.height = screenBounds.height
        
        playerLayer.frame.size = framePlayerLayer
        
        self.view.layer.addSublayer(playerLayer)
        videoPlayer.play()
    }
}

extension LaunchScreenViewController {
    
    func autoLogin() {
        let login: String? = UserDefaults.standard.string(forKey: Constrants.kLogin)
        let password: String? = UserDefaults.standard.string(forKey: Constrants.kPassword)
        
        if (login != nil && password != nil) {
            // auto login
            presenter.login(login: login!, password: password!)
        }
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {        
        performSegue(withIdentifier: "screenWhiteView", sender: self)
    }
}

extension LaunchScreenViewController: LaunchScreenProtocol {
    
    func returnSuccessLogin(login: Login) {
        self.appDelegate.login = login
    }
}
