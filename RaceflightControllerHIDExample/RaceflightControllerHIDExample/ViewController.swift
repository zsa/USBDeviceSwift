//
//  ViewController.swift
//  RaceflightControllerHIDExample
//
//  Created by Artem Hruzd on 6/14/17.
//  Copyright © 2017 Artem Hruzd. All rights reserved.
//

import Cocoa
import USBDeviceSwift

class ViewController: NSViewController, NSComboBoxDataSource {
    @IBOutlet weak var devicesComboBox: NSComboBox!
    @IBOutlet weak var connectButton: NSButton!
    @IBOutlet weak var connectedDeviceLabel: NSTextField!
    @IBOutlet weak var rfDeviceView: NSView!
    @IBOutlet weak var responseLabel: NSTextField!
    
    @IBAction func connectDevice(_ sender: Any) {
        DispatchQueue.main.async {
            if (self.devices.count > 0) {
                if (self.connectedDevice != nil) {
                    self.connectButton.title = "Connect"
                    self.devicesComboBox.isEnabled = true
                    self.connectedDevice = nil
                    self.rfDeviceView.isHidden = true
                } else {
                    self.connectButton.title = "Disconnect"
                    self.devicesComboBox.isEnabled = false
                    self.connectedDevice = self.devices[self.devicesComboBox.integerValue]
                    self.connectedDeviceLabel.stringValue = "Connected device: \(self.connectedDevice!.deviceInfo.name) (\(self.connectedDevice!.deviceInfo.vendorId), \(self.connectedDevice!.deviceInfo.productId))"
                    self.rfDeviceView.isHidden = false
                }
            }
        }
    }
    
    var connectedDevice:RFDevice?
    var devices:[RFDevice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.usbConnected), name: .HIDDeviceConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.usbDisconnected), name: .HIDDeviceDisconnected, object: nil)
        
        self.devicesComboBox.isEditable = false
        self.devicesComboBox.completes = false
        self.rfDeviceView.isHidden = true
        self.devicesComboBox.reloadData()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return self.devices.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return self.devices[index].deviceInfo.name
    }
    
    func usbConnected(notification: NSNotification) {
        guard let nobj = notification.object as? NSDictionary else {
            return
        }
        
        guard let deviceInfo:HIDDevice = nobj["device"] as? HIDDevice else {
            return
        }
        let device = RFDevice(deviceInfo)
        DispatchQueue.main.async {
            self.devices.append(device)
            self.devicesComboBox.reloadData()
        }
    }
    
    func usbDisconnected(notification: NSNotification) {
        guard let nobj = notification.object as? NSDictionary else {
            return
        }
        
        guard let id:String = nobj["id"] as? String else {
            return
        }
        DispatchQueue.main.async {
            if let index = self.devices.index(where: { $0.deviceInfo.id == id }) {
                self.devices.remove(at: index)
                if (id == self.connectedDevice?.deviceInfo.id) {
                    self.connectButton.title = "Connect"
                    self.devicesComboBox.isEnabled = true
                    self.connectedDevice = nil
                    self.rfDeviceView.isHidden = true
                }
            }
            self.devicesComboBox.reloadData()
        }
    }
    
}


