//
//  QRCodeTearderViewController.swift
//  miniProject
//
//  Created by 楷岷 張 on 2017/6/20.
//  Copyright © 2017年 楷岷 張. All rights reserved.
//

import UIKit
import AVFoundation
import SVProgressHUD

class QRCodeTearderViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBAction func goBackButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let albumCollectionViewController = storyboard.instantiateViewController(withIdentifier: "TabBarController")
        navigationController?.pushViewController(albumCollectionViewController, animated: true)
    }
    @IBOutlet weak var topbar: UIView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrcodeFrameView:UIView?
    
    let supportedCodeType = [AVMetadataObjectTypeQRCode]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topbar.backgroundColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 0.8)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeType
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            captureSession?.startRunning()
            view.bringSubview(toFront: topbar)
            //          偵測到QRcode的時候顯示綠色方框
            qrcodeFrameView = UIView()
            if let qrCodeFrameView = qrcodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor(red: 216.0/255.0, green: 74.0/255.0, blue: 32.0/255.0, alpha: 1.0).cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            return
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrcodeFrameView?.frame = CGRect.zero
            return
        }
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        if supportedCodeType.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrcodeFrameView?.frame = barCodeObject!.bounds
            if metadataObj.stringValue != nil {
                captureSession?.stopRunning()
                if metadataObj.stringValue.characters.count == 20 {
                    if let newAlbumID = metadataObj.stringValue {
                        print(newAlbumID)
                        SVProgressHUD.show(withStatus: "搜尋中...")
                        FirebaseServer.firebase().checkJoinNewAlbumID(str: newAlbumID, completion: { (check) in
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
                } else {
                    self.present(Library.alertSet(title: "錯誤", message:"請掃描正確的QRcode", controllerType: .alert, checkButton1: "OK", checkButton1Type: .default, handler: { (_) in
                        self.captureSession?.startRunning()
                    }), animated: true, completion: nil)
                }
            }
        }
    }
    
    
}
