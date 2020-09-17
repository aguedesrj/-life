//
//  InfoLifeDetailViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import Atributika
import SideMenu
import WebKit
import NVActivityIndicatorView

class InfoLifeDetailViewController: BaseViewController {

    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewLine: UIView!
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewLoading: UIView!
    
    var infoLife: InfoLife!
    
    fileprivate var activityIndicatorView: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
            buttonBack.imageView?.tintColor = Color.primary.value
        self.viewLine.layer.shadowColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.3).cgColor
        self.viewLine.layer.shadowOffset = CGSize.zero
        self.viewLine.layer.shadowOpacity = 2.5
        self.viewLine.layer.shadowRadius = 4.0
        self.viewLine.layer.masksToBounds = false
        
        labelDate.text = infoLife.publicationDateFormat
        labelTitle.text = infoLife.title
        
        let html: String = "<html><link href='https://fonts.googleapis.com/css?family=Open+Sans&display=swap' rel='stylesheet'><style type='text/css'>body p {font-family: Open Sans, serif;}body iframe {width: 100%; height='40%'}</style><body ><img src='\(infoLife.urlImageDetach)' height=auto width='100%'/><p style='font-size: 45px; font-family: Open Sans; color:#505050'>\(infoLife.text)</p></body></html>"
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.navigationDelegate = self
        webView.loadHTMLString(html, baseURL: nil)
        
        SideMenuManager.default.menuEnableSwipeGestures = false
        
        addSubviewLoading()
        
        showIndicator()
        
        InfoLifePresenter.init().registerAccessInfoVida()
        
        if Device.isIPhone5() {
            labelTitle.font = UIFont(name: "Montserrat-SemiBold", size: 20.0)
        }
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InfoLifeDetailViewController {
    
    fileprivate func addSubviewLoading() {
        let frame: CGRect = CGRect(x: 0, y: 0, width: viewLoading.frame.size.width,
                                   height: viewLoading.frame.size.height)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: NVActivityIndicatorType.circleStrokeSpin)
        
        viewLoading.addSubview(activityIndicatorView)
        activityIndicatorView.color = Color.primary.value
    }
    
    fileprivate func showIndicator() {
        webView.isHidden = true
        viewLoading.isHidden = false
        activityIndicatorView.startAnimating()
    }
    
    fileprivate func hideIndicator() {
        webView.isHidden = false
        viewLoading.isHidden = true
        activityIndicatorView.stopAnimating()
    }
}

extension InfoLifeDetailViewController: UIWebViewDelegate {
    func webView(_: UIWebView, shouldStartLoadWith: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if navigationType == UIWebView.NavigationType.linkClicked {
            UIApplication.shared.open(shouldStartLoadWith.url!, options: [:], completionHandler: nil)
            return false
        }
        return true
    }
}

extension InfoLifeDetailViewController: WKNavigationDelegate {
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        hideIndicator()
        
        self.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideIndicator()
        self.hideLoading()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        hideIndicator()
        
        print(error)
        self.hideLoading()
        self.showAlert(message: Constrants.messageSystemUnavailable)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideIndicator()
        
        self.hideLoading()
        self.showAlert(message: Constrants.messageSystemUnavailable)
    }
}
