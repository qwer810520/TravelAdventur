//
//  QRCodeTearderViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/20.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import AVFoundation

class QRCodeTearderViewController: ParentViewController {
    
    @IBAction func goBackButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumCollectionViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        navigationController?.pushViewController(albumCollectionViewController, animated: true)
    }
    
    var captureSession = AVCaptureSession()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrcodeFrameView: UIView?
    
    private let supportedCodeType = [
        AVMetadataObject.ObjectType.upce,
        AVMetadataObject.ObjectType.code39,
        AVMetadataObject.ObjectType.code39Mod43,
        AVMetadataObject.ObjectType.code93,
        AVMetadataObject.ObjectType.code128,
        AVMetadataObject.ObjectType.ean8,
        AVMetadataObject.ObjectType.ean13,
        AVMetadataObject.ObjectType.aztec,
        AVMetadataObject.ObjectType.pdf417,
        AVMetadataObject.ObjectType.itf14,
        AVMetadataObject.ObjectType.dataMatrix,
        AVMetadataObject.ObjectType.interleaved2of5,
        AVMetadataObject.ObjectType.qr
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setVideoPreviewLayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUserInterface()
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        setNavigation(title: "Search Album", barButtonType: .Dismiss_)
    }
    
    private func setVideoPreviewLayer() {
        //  取得後鏡頭擷取影片
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back)
        
        guard let captureDevice = deviceDiscoverySession.devices.first else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeType
        } catch { }
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        captureSession.startRunning()
        
        //          偵測到QRcode的時候顯示綠色方框
        qrcodeFrameView = UIView()
        if let qrCodeFrameView = qrcodeFrameView {
            qrCodeFrameView.layer.borderColor = TAStyle.orange.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubview(toFront: qrCodeFrameView)
        }
    }
}

// MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRCodeTearderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        guard metadataObjects.count != 0 else {
            qrcodeFrameView?.frame = .zero
            return
        }
        
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
        qrcodeFrameView?.frame = barCodeObject!.bounds
        
        guard let value = metadataObj.stringValue, value.count == 20 else { return }
        captureSession.stopRunning()
        guard isNetworkConnected() else { return }
        startLoading()
        FirebaseManager.shared.checkAlbumStatus(id: value) { [weak self] (status, error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(type: .check, title: (error?.localizedDescription)!)
                return
            }
            switch status {
            case true:
                self?.showAlert(type: .check, title: "新增成功", checkAction: { (_) in
                    self?.dismiss(animated: true, completion: nil)
                })
            case false:
                self?.showAlert(type: .check, title: "錯誤", message: "請掃描正確的QRCode", checkAction: { (_) in
                    self?.captureSession.startRunning()
                })
            }
        }
        
        /*
         if metadataObj.stringValue != nil {
         captureSession.stopRunning()
         if metadataObj.stringValue?.count == 20 {
         /*
         if let newAlbumID = metadataObj.stringValue {
         print(newAlbumID)
         SVProgressHUD.show(withStatus: "搜尋中...")
         FirebaseManager.shared.checkJoinNewAlbumID(str: newAlbumID, completion: { (check) in
         if check == true {
         SVProgressHUD.dismiss()
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let albumCollectionViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
         self.navigationController?.pushViewController(albumCollectionViewController, animated: true)
         Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false, block: { (_) in
         NotificationCenter.default.post(name: Notification.Name("updata"), object: nil, userInfo: ["switch": "joinNewAlbum"])
         })
         
         } else {
         SVProgressHUD.dismiss()
         self.present(Library.alertSet(title: "錯誤", message:"請掃描正確的QRcode", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: { (_) in
         self.captureSession?.startRunning()
         }), animated: true, completion: nil)
         }
         })
         }
         */
         } else {
         /*
         self.present(Library.alertSet(title: "錯誤", message:"請掃描正確的QRcode", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: { (_) in
         self.captureSession?.startRunning()
         }), animated: true, completion: nil)
         */
         }
         
         }
         */
    }
}
