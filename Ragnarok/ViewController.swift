//
//  ViewController.swift
//  Ragnarok
//
//  Created by Bezaleel Ashefor on 11/07/2020.
//  Copyright © 2020 Bezaleel Ashefor. All rights reserved.
//
import UIKit
import AVFoundation

class ViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var cameraView: UIView!
    
    var session: AVCaptureSession?
    var device: AVCaptureDevice?
    var input: AVCaptureDeviceInput?
    var output: AVCaptureMetadataOutput?
    var prevLayer: AVCaptureVideoPreviewLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchCamera()
        createSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prevLayer?.frame.size = cameraView.frame.size
    }
    
    
    func switchCamera(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(switchCameraSide))
        gestureRecognizer.numberOfTapsRequired = 1
        cameraView.addGestureRecognizer(gestureRecognizer)
        cameraView.isUserInteractionEnabled = true
    }
    
    var hideStatusBar: Bool = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
    
    func createSession() {
        session = AVCaptureSession()
        device = AVCaptureDevice.default(for: AVMediaType.video)
        
        do{
            input = try AVCaptureDeviceInput(device: device!)
        }
        catch{
            print(error)
        }
        
        if let input = input{
            session?.addInput(input)
        }
        
        prevLayer = AVCaptureVideoPreviewLayer(session: session!)
        prevLayer?.frame.size = cameraView.frame.size
        prevLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        prevLayer?.connection?.videoOrientation = transformOrientation(orientation: UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
        
        cameraView.layer.addSublayer(prevLayer!)
        
        session?.startRunning()
    }
    
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInTrueDepthCamera, .builtInWideAngleCamera, ], mediaType: .video, position: position)
        
        if let device = deviceDiscoverySession.devices.first {
            return device
        }
        return nil
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) -> Void in
            self.prevLayer?.connection?.videoOrientation = self.transformOrientation(orientation: UIInterfaceOrientation(rawValue: UIApplication.shared.statusBarOrientation.rawValue)!)
            self.prevLayer?.frame.size = self.cameraView.frame.size
        }, completion: { (context) -> Void in
            
        })
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func transformOrientation(orientation: UIInterfaceOrientation) -> AVCaptureVideoOrientation {
        switch orientation {
        case .landscapeLeft:
            return .landscapeLeft
        case .landscapeRight:
            return .landscapeRight
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
    }
    
    @objc func switchCameraSide() {
        if let sess = session {
            let currentCameraInput: AVCaptureInput = sess.inputs[0]
            sess.removeInput(currentCameraInput)
            var newCamera: AVCaptureDevice
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == .back {
                newCamera = self.cameraWithPosition(position: .front)!
            } else {
                newCamera = self.cameraWithPosition(position: .back)!
            }
            
            var newVideoInput: AVCaptureDeviceInput?
            do{
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
            }
            catch{
                print(error)
            }
            
            if let newVideoInput = newVideoInput{
                session?.addInput(newVideoInput)
            }
        }
    }
    
}
