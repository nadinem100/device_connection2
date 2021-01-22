//
//  MultipeerService.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import Foundation
import MultipeerConnectivity
import UIKit

class HostService: NSObject {
    
    var session: MCSession!
    var browser: MCNearbyServiceBrowser!
    var discoveredDevices: [BLEDevice] = []
    var connectedDevices: [MCPeerID] = []
    var myPeerID = MCPeerID(displayName: "host")
    var service = "trumonitor-ctrl"
    //dictionary of mcpeerid --> phone id's?
    
    override init() {
        
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .optional)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: service)
        
        session.delegate = self
        browser.delegate = self
        
        print("Host instantiated")
        start()
        
    }
    
    func start() {
        
        browser.startBrowsingForPeers()
        
    }
    
    
    func sendDataToTruMonitor(request: ControlRequest, peers: [MCPeerID]) {

         

         guard let data = controlRequestData(request: request) else { return }
        
         if peers.count == 0 { return }
         do {
            print("About to send")
             try self.session.send(data, toPeers: peers, with: .reliable)
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


extension HostService: MCNearbyServiceBrowserDelegate {
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        
        print("\(peerID) device found")
        print("info: ", info)
        discoveredDevices.append(BLEDevice(uuid: info!["device_id"], deviceName: info!["device_name"], peerID: peerID))
//        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 30) //can we just add to discovered/connected devices, and then invite once they select it?
        
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
        print("\(peerID) device lost")
        print("discovered devices", discoveredDevices)
        
        guard let index = discoveredDevices.firstIndex(where: { $0.peerID == peerID })  else { return }
        
        discoveredDevices.remove(at: index)
        
//        guard let index2 = discoveredDevices.firstIndex(where: { $0.peerID == peerID })  else { return }

        guard let index2 = connectedDevices.firstIndex(of: peerID) else { return }
        
        
        connectedDevices.remove(at: index2)
    }
    
}


extension HostService: MCSessionDelegate {
    
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
        @unknown default:
            break
        }
        
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("Recieved signal from \(peerID)")
        
    }
    
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
extension HostService: QCPRDeviceViewDelegate {

    func requestConnect(device: BLEDevice) {
        //bleCore.requestConnect(device: device)
        print("inviting: ", device.peerID)
        browser.invitePeer(device.peerID!, to: session, withContext: nil, timeout: 30)
    }
}
