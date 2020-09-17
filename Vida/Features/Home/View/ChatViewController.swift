//
//  ChatViewController.swift
//  Vida
//
//  Created by Vida.
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import WebKit

class ChatViewController: BaseViewController {

//    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var labelTitle: UILabel!
    
    var jivoSdk: JivoSdk!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTitle.text = "Chat"
        
        self.jivoSdk = JivoSdk.init(webView)
        self.jivoSdk.prepare()
        
        self.jivoSdk.start()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.jivoSdk.stop()
    }
    
    @IBAction func pressButtonMenu(_ sender: Any) {
        self.openMenuLeft()
    }
}

extension ChatViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Iniciando navagação...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finalizando navagação...")
    }
}
