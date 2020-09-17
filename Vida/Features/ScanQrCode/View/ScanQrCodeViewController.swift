//
//  ScanQrCodeViewController.swift
//  Vida
//
//  Created by Vida
//  Copyright © 2019 Vida. All rights reserved.
//

import UIKit
import AVFoundation

class ScanQrCodeViewController: BaseViewController {

    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var imageViewScanQrCode: UIImageView!
    @IBOutlet weak var viewPreviewCamera: UIView!
    @IBOutlet weak var viewBackgroundTop: UIView!
    @IBOutlet weak var viewBackgroundLeft: UIView!
    @IBOutlet weak var viewBackgroundRight: UIView!
    @IBOutlet weak var viewBackgroundBottom: UIView!
    @IBOutlet weak var imageViewScanQrCodeTop: NSLayoutConstraint!
    @IBOutlet weak var imageViewScanQrCodeBottom: NSLayoutConstraint!
    @IBOutlet weak var buttonDiscount: UIButton!
    @IBOutlet weak var constraintLeftButtonDiscount: NSLayoutConstraint!
    @IBOutlet weak var constraintRightButtonDiscount: NSLayoutConstraint!
    
    var presenter: ScanQrCodePresenter!
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    fileprivate var showScanQrCodeVerified: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = ScanQrCodePresenter(view: self)

        labelTitle.textColor = .white
        buttonBack.tintColor = .white
        
        if Device.isIPhone5() {
            imageViewScanQrCodeTop.constant = 50.0
            imageViewScanQrCodeBottom.constant = 50.0
            constraintLeftButtonDiscount.constant = 25.0
            constraintRightButtonDiscount.constant = 25.0
        }
        
        let frameButtonDiscount: CGSize = buttonDiscount.frame.size
        buttonDiscount.layer.cornerRadius = frameButtonDiscount.height / 2
        buttonDiscount.layer.borderWidth = 2
        buttonDiscount.layer.borderColor = UIColor.white.cgColor
        
        self.startReading()
    }
    
    @IBAction func pressButtonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.showScanQrCodeVerified = false
    }
    
    @IBAction func pressButtonDiscount(_ sender: Any) {
        EstablishmentsRouter().show(at: self)
    }
}

extension ScanQrCodeViewController {
    
    fileprivate func startReading() {
        do {
            let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
            let input = try AVCaptureDeviceInput(device: captureDevice!)

            captureSession.addInput(input)

            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)

            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]


            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            viewPreviewCamera.layer.addSublayer(videoPreviewLayer!)
            captureSession.startRunning()
            
            self.view.addSubview(labelDescription)
        } catch {
            print(error)
            return
        }
    }
}

extension ScanQrCodeViewController: ScanQrCodeViewProtocol {
    
    func returnSuccessScanQrCode(establishment: Establishments) {
        self.hideLoading()
        ScanQrCodeRoute().showVerified(at: self, establishments: establishment)
    }
    
    func returnErrorScanQrCode(message: String) {
        self.showAlert(message: message)
        self.showScanQrCodeVerified = false
    }
}

extension ScanQrCodeViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        if metadataObjects.count == 0 {
            // QrCode não foi detectado.
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if metadataObj.type == AVMetadataObject.ObjectType.qr &&
            metadataObj.stringValue != nil &&
            !showScanQrCodeVerified {
            
            self.showScanQrCodeVerified = true
            self.showLoadingWithViewController(textProgress: "Validando...")
            self.presenter.getEstablishmentsByQrCode(qrCode: metadataObj.stringValue!)
        }
    }
}
