//
//  QCPRInterface.swift
//  Bluetooth-3
//
//  Created by Nadine Meister on 1/21/21.
//

import Foundation
import UIKit

public protocol QCPRCompressionDelegate: class {
    func compressionUpdated(uuid: String?, comp_dep: Int, comp_rate: Int)
}

public protocol QCPRInterfaceDelegate: class {
    func qcprDeviceConnected(_ interface: QCPRInterface, connected: Bool)
}

public protocol QCPRCompressionWaveDelegate: class {
    func waveValueUpdated(_ interface: QCPRInterface, depth: Int)
}

public class QCPRInterface: NSObject {

//    var dataService: MultipeerDataService!
    
    let bleCore = BLEcore(services: [QCPRService.compression])
//                                             QCPRService.session,
//                                             QCPRService.authentication])
    
    public weak var compressionDelegate: QCPRCompressionDelegate?
    public weak var compressionWaveDelegate: QCPRCompressionWaveDelegate?
    public weak var delegate: QCPRInterfaceDelegate?
    
    private var deviceView: QCPRDeviceView?
    
    private var latestRate: Int?
    
    private var devicesListAutoShown = false
    
    public override init() { //will eventually take in data if stethoscope, mannequin, ... and filter UUID's based on that
        super.init()

    }
    
    func startBLE() {
        bleCore.start()
        
    }
    
    public func showDevicesList() {
//        if deviceView == nil {
            print("inside showing devices, will show deviceview next")
            deviceView = QCPRDeviceView.show()
            deviceView?.delegate = self
//        }
        refreshDevicesList()
        refreshDevicesListState()
    }

    public func refreshDevicesList() {
        print("refreshing devices now")
        deviceView?.update(devices: bleCore.discoveredDevices())
        deviceView?.updateConnectedDevice(device: bleCore.connectedDevice(), autoDismiss: false)
    }

    public func refreshDevicesListState() {
        deviceView?.update(searching: bleCore.isScanning(), bluetoothOn: bleCore.bluetoothOn())
    }
    
    public func receivedCompressionEvent(a:Int, b:Int){
        compressionDelegate?.compressionUpdated(uuid: "empty", comp_dep: a, comp_rate: b)
    }
}

extension QCPRInterface: BLECoreDelegate {
    func connectedDeviceUpdated(connectedDevice: BLEDevice?) {
        deviceView?.updateConnectedDevice(device: connectedDevice, autoDismiss: true)
        delegate?.qcprDeviceConnected(self, connected: connectedDevice != nil)
    }

    func connectionStateUpdated() {
        refreshDevicesListState()
    }

    func notifyError(error: Error) {
        print("BLECore Reported Error \(error.localizedDescription)")
    }

    func discoveredDevicesUpdated(discoveredDevices: [BLEDevice]) {
        if discoveredDevices.count > 0 && !devicesListAutoShown {
            devicesListAutoShown = true
            showDevicesList()
        }
        refreshDevicesList()
    }
}

extension QCPRInterface: QCPRDeviceViewDelegate {

    func requestConnect(device: BLEDevice) {
        bleCore.requestConnect(device: device)
    }

    func requestDisconnect(device: BLEDevice) {
        bleCore.requestDisconnect(device: device)
    }

    func didDismiss(_ view: QCPRDeviceView) {
        deviceView = nil
    }
}
