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
    
    fileprivate var captureSession = AVCaptureSession()
    fileprivate var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    fileprivate var qrcodeFrameView: UIView?
    
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
        setNavigation(title: "Search Album", barButtonType: .dismiss_)
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
        if let videoLayer = videoPreviewLayer {
            view.layer.addSublayer(videoLayer)
        }
        captureSession.startRunning()
        
        //          偵測到QRcode的時候顯示綠色方框
        qrcodeFrameView = UIView()
        if let qrCodeFrameView = qrcodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.pinkPeacock.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
    }
}

    // MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRCodeTearderViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        guard metadataObjects.count != 0, let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) else {
            qrcodeFrameView?.frame = .zero
            return
        }

        qrcodeFrameView?.frame = barCodeObject.bounds
        
        guard let value = metadataObj.stringValue, value.count == 20 else { return }
        captureSession.stopRunning()
        startLoading()
        FirebaseManager2.shared.checkAlbumStatus(id: value) { [weak self] (status, error) in
            self?.stopLoading()
            guard error == nil else {
                self?.showAlert(title: error?.localizedDescription ?? "")
                return
            }
            switch status {
            case true:
                self?.showAlert(title: "新增成功", rightAction: { _ in
                    self?.dismiss(animated: true, completion: nil)
                })
            case false:
                self?.showAlert(title: "錯誤", message: "請掃描正確的QRCode", rightAction: { _ in
                    self?.captureSession.startRunning()
                })
            }
        }
    }
}
