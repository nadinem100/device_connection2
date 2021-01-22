//
//  QCPRDeviceView.swift
//  Bluetooth-3
//
//  Created by Nadine Meister on 1/15/21.
//

import UIKit
import MultipeerConnectivity


struct BLEDevice: Equatable {
    var uuid: String? //phone's id
    var deviceName: String? //peerID instead
    var peerID: MCPeerID?

//    func toMPID(bled: BLEDevice) -> MCPeerID{ //in the end, we gotta pick either mcpeerid or bledevice but we goin like dis fo now
//        //let mcpid = MCPeerID(displayName: bled.deviceName)
//        return MCPeerID(displayName: bled.deviceName) //mcpid
//    }
}

protocol QCPRDeviceViewDelegate: class {
    func requestConnect(device: BLEDevice)
//    func requestDisconnect(device: BLEDevice)
//    func didDismiss(_ view: QCPRDeviceView)
}

class QCPRDeviceView: UIViewController, UIAdaptivePresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bluetoothOffView: UIView!
    
    @IBOutlet weak var btnClose: UIButton!
    
    private static let identifier = "QCPRDeviceView"
    
    private var devices: [BLEDevice] = []
    private var connectedDevice: BLEDevice? = nil
    private var activityIndicator: UIActivityIndicatorView? = nil
    
    weak var delegate: QCPRDeviceViewDelegate?
    
    static let navBGDark = UIColor(red:0.18, green:0.18, blue:0.19, alpha:1.00)
    static let mainBGDark = UIColor(red:0.11, green:0.11, blue:0.12, alpha:1.00)
    
    class func show() -> QCPRDeviceView? {
        print("begin showing")
        
        guard let presenter = QCPRDeviceView.topViewController() else { return nil }
        
        let viewController = UIStoryboard(name: QCPRDeviceView.identifier, bundle: Bundle(for: QCPRDeviceView.self))
            .instantiateViewController(withIdentifier: QCPRDeviceView.identifier) as! QCPRDeviceView
         
        let navigationController = UINavigationController(rootViewController: viewController)
        
        navigationController.modalPresentationStyle = .formSheet
        navigationController.preferredContentSize = CGSize(width: min(420, presenter.view.frame.size.width),
                                                           height: min(420, presenter.view.frame.size.height))
        navigationController.navigationBar.barTintColor = navBGDark
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController.presentationController?.delegate = viewController
        
        viewController.view.backgroundColor = mainBGDark
        
        presenter.present(navigationController, animated: true, completion: nil)
        
        print("finished showing")
        return viewController
    }


    private class func topViewController() -> UIViewController? {
        guard var top = UIApplication.shared.keyWindow?.rootViewController else {
            return nil
        }
        while let next = top.presentedViewController {
            top = next
        }
        return top
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func update(devices: [BLEDevice]) {
        self.devices = devices
        tableView.reloadData()
    }
    
    func update(searching: Bool, bluetoothOn: Bool) {
        tableView.isHidden = !bluetoothOn
        bluetoothOffView.isHidden = bluetoothOn
        
        if searching {
            activityIndicator?.startAnimating()
        } else {
            activityIndicator?.stopAnimating()
        }
    }
    
    func updateConnectedDevice(device: BLEDevice?, autoDismiss: Bool) {
        self.connectedDevice = device
        tableView.reloadData()
        
        if device != nil && autoDismiss {
            scheduleDismiss()
        }
    }
    
    func scheduleDismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.dismiss(animated: true, completion: { [weak self] in
                if let self = self {
//                    self.delegate?.didDismiss(self)
                }
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("is this called: devices count:", devices.count)
        return devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            }
            return cell
        }()
        print("devices:", devices)
        let device = devices[indexPath.row]
        
        cell.textLabel!.text = device.deviceName
        cell.detailTextLabel!.text = device.uuid
        
        cell.textLabel!.textColor = .white
        cell.detailTextLabel!.textColor = .white
        
        cell.accessoryType = device == connectedDevice ? .checkmark : .none
        
        cell.backgroundColor = UIColor(red:0.18, green:0.18, blue:0.19, alpha:1.00)
        cell.selectionStyle = .blue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let device = devices[indexPath.row]
        if device == connectedDevice {
//            delegate?.requestDisconnect(device: device)
        } else {
            delegate?.requestConnect(device: device)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 48))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 48))
        
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .medium)
            
            activityIndicator!.startAnimating()
            activityIndicator!.center = CGPoint(x: view.frame.size.width - activityIndicator!.frame.size.width,
                                          y: view.frame.size.height - activityIndicator!.frame.size.height)
            
            activityIndicator!.hidesWhenStopped = true
        }
        
        view.addSubview(activityIndicator!)
                                                        
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "DISCOVERED DEVICES"
        label.textColor = .darkGray
        view.addSubview(label)

        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        delegate?.didDismiss(self)
    }
    
    @IBAction func didSelectDismiss() {
        dismiss(animated: true) {
//            self.delegate?.didDismiss(self)
        }
    }
    
}



