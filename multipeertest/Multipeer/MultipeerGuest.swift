//
//  MultipeerGuest.swift
//  multipeertest
//
//  Created by Joshua Qiu on 1/21/21.
//

import Foundation
import MultipeerConnectivity
import UIKit



class AdvertisingService: NSObject {

    var session: MCSession!
    var advertiser: MCNearbyServiceAdvertiser!
    var host: MCPeerID!
    var myPeerID: MCPeerID!
    var service = "trumonitor-ctrl"
    
    
    init(type: String) {
        
        myPeerID = MCPeerID(displayName: type)
        
        super.init()
        session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .optional)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: ["device_name":UIDevice.current.name, "device_id":UIDevice.current.identifierForVendor!.uuidString], serviceType: service)
        
        session.delegate = self
        advertiser.delegate = self
        
        print("\(type) instantiated")
        start()
    }
    
    func start() {
        
        advertiser.startAdvertisingPeer()
        
    }
    
    func signal() {
        
        let data = Data(bytes: [0], count: 1)
        
        do{
            
            if host != nil {
                try session.send(data, toPeers: [host], with: .reliable)
            }
 
        }catch let error {
            
            print("%@", "Error for sending: \(error)")
            
        }
        
        
    }
}


extension AdvertisingService: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    
        print("\(peerID) invitation recieved")
        invitationHandler(true, session)
        
    }
    
}

extension AdvertisingService: MCSessionDelegate {
    
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
            if host == nil{
                host = peerID
            }
        @unknown default:
            break
        }
        
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        print("Recieved Data")
        
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

