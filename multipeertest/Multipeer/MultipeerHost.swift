//
//  MultipeerService.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import Foundation
import MultipeerConnectivity
import UIKit

public protocol HostDelegate: class {
    func signalUpdated(peerID: MCPeerID?, data: String?)
}

class HostService: NSObject {
    
    // Instance variables. ! means they do not need to be defined at constructor
    
    // Both host and guest need a mcsession to manage sending and recieving data
    var session: MCSession!
    
    // browser to look for guest devices
    var browser: MCNearbyServiceBrowser!
    
    var discoveredDevices: [BLEDevice] = []
    var connectedDevices: [MCPeerID] = []
    
    // different array to differentiate between our own simulated devices and trumonitor tablets
    var truMonitorDevices: [MCPeerID] = []
    
    var myPeerID = MCPeerID(displayName: "host")
    
    // this is the service name that is needed to establish connected to trumonitor. Note that in info.plst file we added a permissions request to use this domain name. (under bonjour services)
    var service = "trumonitor-ctrl"
    
    //dictionary of mcpeerid --> phone id's?
    public weak var hostDelegate: HostDelegate?

    override init() {
        
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .optional)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: service)
        
        // MCSession and MCServiceBrowser have delegates that contain methods that
        // are called automatically to handle events. This class extends these
        // delegate classes, so we set the delegate to self
        session.delegate = self
        browser.delegate = self
        
        print("Host instantiated")
        browser.startBrowsingForPeers()
        
    }
    
    func sendDataToTruMonitor(request: ControlRequest, peers: [MCPeerID]) {

         

         guard let data = controlRequestData(request: request) else { return }
        
         if peers.count == 0 { return }
         do {
            print("About to send", data)
             try session.send(data, toPeers: peers, with: .reliable)
         } catch let error {
             print("%@", "Error for sending: \(error)")
         }
     }

     
     private func controlRequestData(request: ControlRequest) -> Data? {

         let jsonEncoder = JSONEncoder()
         var jsonData: Data?

         do {
            jsonData = try jsonEncoder.encode(request)
            let jsonString = String(data: jsonData!, encoding: .utf8)
            print("JSON String : " + jsonString!)
        }
        catch {
            print(error.localizedDescription)
        }

        guard let data = jsonData else {
            print("Attempted to send empty data set")
            return nil
        }

         return data
     }
    
}

// Event handlers for MCNearbyServiceBrowser
extension HostService: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        print("\(peerID) device found")
        
        guard let device_name = info!["device_name"], let device_id = info!["device_id"] else {
            discoveredDevices.append(BLEDevice(uuid: "N/A", deviceName: "Trumonitor Tablet", peerID: peerID))
            return
        }
        discoveredDevices.append(BLEDevice(uuid: "\(device_name) : \(device_id) ", deviceName: peerID.displayName, peerID: peerID))
        
        // Invite guest to our session, this calls didChange in MCSession delegate
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("\(peerID) device lost")
        print("discovered devices", discoveredDevices)
        
        guard let index = discoveredDevices.firstIndex(where: { $0.peerID == peerID })  else { return }
        print("before\(discoveredDevices.count)")
        discoveredDevices.remove(at: index)
        print("after\(discoveredDevices.count)")
//        guard let index2 = discoveredDevices.firstIndex(where: { $0.peerID == peerID })  else { return }

        guard let index2 = connectedDevices.firstIndex(of: peerID) else { return }
        
        connectedDevices.remove(at: index2)
        
        guard let index3 = truMonitorDevices.firstIndex(of: peerID) else { return }

        truMonitorDevices.remove(at: index3)
    }
    
}


extension HostService: MCSessionDelegate {
    
    // Called upon making connection
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        switch state {
        case .notConnected:
            print("-- \(peerID) Not connected -- ")
            break
        case .connecting:
            print("-- \(peerID) Connecting -- ")
            break
        case .connected:
            print("-- \(peerID) Connected -- ")
            connectedDevices.append(peerID)
            
            // sorting into proper device
            if (peerID.displayName != "Stethoscope" && peerID.displayName != "BVM" && peerID.displayName != "Drugs" && peerID.displayName != "Bedside Monitor" && peerID.displayName != "Monitor Box" &&
                peerID.displayName != "Fluids"){
                
                print("trumonitor device found")
                truMonitorDevices.append(peerID)
            }
        @unknown default:
            break
        }
        
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("Recieved from \(peerID)")
        
        print(String(decoding: data, as: UTF8.self))
        hostDelegate?.signalUpdated(peerID: peerID, data: String(decoding: data, as: UTF8.self))
        
    }
    
    
    // Other event handling methods that needed to be implemented
    // but are not used
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
        print("Recieving stream")
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
        print("Recieving resource")
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
        print("Finished recieving resource")
        
    }
    
    
}

// Delegate used for bringing variables to certain scopes. This is for UI
extension HostService: QCPRDeviceViewDelegate {

    func requestConnect(device: BLEDevice) {

        //bleCore.requestConnect(device: device)

        print("inviting: ", device.peerID)

        browser.invitePeer(device.peerID!, to: session, withContext: nil, timeout: 30)

        

        print("Checking for previous stethscope")

        guard let index = connectedDevices.firstIndex(where: { (peerID) -> Bool in

            return device.peerID?.displayName == peerID.displayName

        }) else { return }

        

        print("Existing stethoscope found")

        

        do {

            try  session.send(Data(bytes: [1], count: 1), toPeers: [connectedDevices[index]], with: .reliable)

        }catch let error {
            print("%@", "Error for sending: \(error)")
        }

        connectedDevices.remove(at: index)

    }
}
