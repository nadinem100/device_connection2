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
    
    let dataService = MultipeerDataService()
    var qcprInterface = QCPRInterface()
    let qcprInterface_2 = QCPRInterface()
    var ble: BLEcore!
    

    @IBOutlet weak var lbl_device2: UILabel!
    @IBOutlet weak var lbl_device1: UILabel!
    
    func updatelbl_dev1(withString string: String?) {
        lbl_device1.text = string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Manager"
        qcprInterface.startBLE()
        qcprInterface_2.startBLE()
        qcprInterface.bleCore.compressionDelegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func didSelectViewDecies(_ sender: Any) {
        print("going to show devices!")
        qcprInterface.showDevicesList()
    }
    
    @IBAction func didSelectPickDevice2(_ sender: Any) {
        print("should show another copy of table of devices!!")
        qcprInterface_2.showDevicesList()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("\(title!) loaded")
        
        
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        
        print("\(title!) deloaded")
        
    }
    
    @IBAction func didSelectButt_ViewAll(_ sender: Any) {
        showDevicesList() //could j pass in parameter:'vpm' to only show vpm's
        deviceView?.update(devices: service.discoveredDevices)
    }
    
    @IBAction func didSelectButt_BVM(_ sender: Any) {
        showDevicesList()
        let filtered_devices = service.discoveredDevices.filter { $0.deviceName == "BVM" }
        deviceView?.update(devices: filtered_devices)
    }
    
    @IBAction func didSelectButt_Steth(_ sender: Any) {
        showDevicesList()
        let filtered_devices = service.discoveredDevices.filter { $0.deviceName == "Stethoscope" }
        deviceView?.update(devices: filtered_devices)
    }
    
    @IBAction func didSelectButt_DF(_ sender: Any) {
        showDevicesList()
        let filtered_devices = service.discoveredDevices.filter { $0.deviceName == "Drugs and Fluids" }
        deviceView?.update(devices: filtered_devices)
    }
    
    @IBAction func didSelectButt_MonitorBox(_ sender: Any) {
        showDevicesList()
        let filtered_devices = service.discoveredDevices.filter { $0.deviceName == "Monitor Box" }
        deviceView?.update(devices: filtered_devices)
    }
    
    @IBAction func didSelectButt_BedsideDiagnostics(_ sender: Any) {
        showDevicesList()
        let filtered_devices = service.discoveredDevices.filter { $0.deviceName == "Bedside Monitor" }
        deviceView?.update(devices: filtered_devices)
    }
    
    public func showDevicesList() {
//        if deviceView == nil {
        print("inside showing devices, will show deviceview next")
        deviceView = QCPRDeviceView.show()
        deviceView!.delegate = service
//        }
    }
    
}

extension ManagerViewController: QCPRCompressionDelegate {
    
    func compressionUpdated(comp_dep: Int, comp_rate: Int) {
    
        lbl_device1.text = String(comp_rate)
        print("Compression Delegate Fire with comp_rate", comp_rate)
        print(service.truMonitorDevices)
        let jsonPayload = "{​​​​​​​​\"parameters\":[{​​​​​​​​\"type\":\"heartRate\",\"value\":" + String(comp_rate) + ",\"changeTime\":0}​​​​​​​​],\"waveforms\":[],\"customParameters\":[],\"visibilities\":[]}​​​​​​​​"

        let controlRequest = ControlRequest(route: "vitals", rootPayload: jsonPayload)

        service.sendDataToTruMonitor(request: controlRequest, peers: service.truMonitorDevices)
        
    }


}
