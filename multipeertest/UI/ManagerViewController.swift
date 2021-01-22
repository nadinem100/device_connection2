//
//  ManagerViewController.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import UIKit
import MultipeerConnectivity


class ManagerViewController: UIViewController, UITableViewDelegate{
    
    let service = HostService()
    
    private var deviceView: QCPRDeviceView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manager"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("\(title!) loaded")
        
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        
        print("\(title!) deloaded")
        
    }
    
    @IBAction func didSelectButt_ViewAll(_ sender: Any) {
        showDevicesList() //could j pass in parameter:'vpm' to only show vpm's
//        let new_BLEDevices = conv_MCPeerIDList_to_BLEDeviceList(peeridLi: service.discoveredDevices)
        print("new BLEDevices about to show: ", service.discoveredDevices)//new_BLEDevices)
        deviceView?.update(devices: service.discoveredDevices)
    }
    
    @IBAction func didSelectButt_BVM(_ sender: Any) {
        print("service's connected devices:", service.connectedDevices)
        print("service's discovered devices:", service.discoveredDevices)
        showDevicesList() //could j pass in parameter:'vpm' to only show vpm's
        let new_BLEDevices = conv_MCPeerIDList_to_BLEDeviceList(peeridLi: service.connectedDevices, filter: "BVM")
        print("new BLEDevices about to show: ", new_BLEDevices)
        deviceView?.update(devices: new_BLEDevices)
//        refreshDevicesList()
//        refreshDevicesListState()

    }
    
    @IBAction func didSelectButt_Steth(_ sender: Any) {
        showDevicesList() //could j pass in parameter:'vpm' to only show vpm's
        let new_BLEDevices = conv_MCPeerIDList_to_BLEDeviceList(peeridLi: service.connectedDevices, filter: "Stethoscope")
        deviceView?.update(devices: new_BLEDevices)
    }
    
    @IBAction func didSelectButt_DF(_ sender: Any) {
        showDevicesList() //could j pass in parameter:'vpm' to only show vpm's
        let new_BLEDevices = conv_MCPeerIDList_to_BLEDeviceList(peeridLi: service.connectedDevices, filter: "Drugs and Fluids")
        deviceView?.update(devices: new_BLEDevices)
    }
    
    @IBAction func didSelectButt_MonitorBox(_ sender: Any) {
    }
    
    @IBAction func didSelectButt_BedsideDiagnostics(_ sender: Any) {
    }
    
    public func showDevicesList() {
//        if deviceView == nil {
        print("inside showing devices, will show deviceview next")
        deviceView = QCPRDeviceView.show()
        deviceView!.delegate = service
//            deviceView?.delegate = self
//        }
    }
    
    public func refreshDevicesList() {
        print("refreshing devices now")
        
//        deviceView?.updateConnectedDevice(device: bleCore.connectedDevice(), autoDismiss: false)
    }
    
    public func conv_MCPeerIDList_to_BLEDeviceList(peeridLi: [MCPeerID], filter: String) -> [BLEDevice] {
        var mcpeerid_to_bledevice: [BLEDevice] = []
        for ele in peeridLi{
            if (ele.displayName == filter){
                mcpeerid_to_bledevice.append(BLEDevice(uuid: "device's ID", deviceName: ele.displayName))
                print("1 ele", ele.displayName) //ele["DisplayName"]
            }
        }
        return mcpeerid_to_bledevice
    }

    public func conv_MCPeerIDList_to_BLEDeviceList(peeridLi: [MCPeerID]) -> [BLEDevice] {
        var mcpeerid_to_bledevice: [BLEDevice] = []
        for ele in peeridLi{
//            if (ele.displayName == filter){
            mcpeerid_to_bledevice.append(BLEDevice(uuid: "device's ID", deviceName: ele.displayName, peerID: ele))
                print("1 ele", ele) //ele["DisplayName"]
//            }
        }
        return mcpeerid_to_bledevice
    }
//    public func refreshDevicesListState() {
//        deviceView?.update(searching: bleCore.isScanning(), bluetoothOn: bleCore.bluetoothOn())
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
