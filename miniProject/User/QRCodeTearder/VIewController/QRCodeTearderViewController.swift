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
  private let supportedCodeType: [AVMetadataObject.ObjectType] = [.upce, .code39, .code39Mod43, .code93, .code128, .ean8, .ean13, .aztec, .pdf417, .itf14, .dataMatrix, .interleaved2of5, .qr]
  private var presenter: QRCodeTearderPresenter?

  lazy private var qrcodeFrameView: UIView = {
    let view = UIView()
    view.layer.borderColor = UIColor.pinkPeacock.cgColor
    view.layer.borderWidth = 2
    return view
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    presenter = QRCodeTearderPresenter(delegate: self)
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

    view.addSubview(qrcodeFrameView)
    view.bringSubviewToFront(qrcodeFrameView)
  }
}

  // MARK: - AVCaptureMetadataOutputObjectsDelegate

extension QRCodeTearderViewController: AVCaptureMetadataOutputObjectsDelegate {
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    guard metadataObjects.count != 0, let metadataObj = metadataObjects[0] as? AVMetadataMachineReadableCodeObject, let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj) else {
      qrcodeFrameView.frame = .zero
      return
    }

    qrcodeFrameView.frame = barCodeObject.bounds

    guard let value = metadataObj.stringValue, value.isAlbumIDFormat() else { return }
    captureSession.stopRunning()

    presenter?.checkAlbumStatus(withID: value)
  }
}

  // MARK: - QRCodeTearderPresenterDelegate

extension QRCodeTearderViewController: QRCodeTearderPresenterDelegate {
  func captureSessionStartRunning() {
    captureSession.startRunning()
  }

  func dismissVC() {
    dismiss(animated: true)
  }

  func presentAlert(with title: String, message: String?, checkAction: ((UIAlertAction) -> Void)?, cancelTitle: String?, cancelAction: ((UIAlertAction) -> Void)?) {
    showAlert(title: title, message: message, rightAction: checkAction, leftTitle: cancelTitle, leftAction: cancelAction)
  }
}
