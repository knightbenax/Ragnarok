//
//  ViewController.swift
//  RagnarokMacOS
//
//  Created by Bezaleel Ashefor on 12/08/2020.
//  Copyright © 2020 Bezaleel Ashefor. All rights reserved.
//

import Cocoa
import CoreMediaIO
import AVFoundation

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDevices()
        // Do any additional setup after loading the view.
    }
    
    func fetchDevices(){
        var prop = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))
        
        var allow: UInt32 = 1;
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &prop,
                                  0, nil,
                                  UInt32(MemoryLayout.size(ofValue: allow)), &allow)
        //let devices = AVCaptureDevice.devices(for: .muxed)
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: .muxed, position: .unspecified)
        print(devices.devices)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

