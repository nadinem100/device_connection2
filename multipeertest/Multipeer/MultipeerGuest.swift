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
        advertiser.startAdvertisingPeer()
    }
    
    // Method for testing connection by sending a string "Signal"
    func signal() {
        
        let data = "Signal".data(using: .utf8)
        
        do{
            
            if host != nil {
                try session.send(data!, toPeers: [host], with: .reliable)
            }
 
        }catch let error {
            
            print("%@", "Error for sending: \(error)")
            
        }
        
    }
    
    func send(data: Data) {
        
        do {
            if host != nil {
                try session.send(data, toPeers: [host], with: .reliable)
            }
        }catch let error {
            print("%@", "Error for sending: \(error)")
        }
        
    }
    
}


extension AdvertisingService: MCNearbyServiceAdvertiserDelegate {
    
    // calls this method when host calls .invitePeer
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    
        print("\(peerID) invitation recieved")
        invitationHandler(true, session)
        
    }
    
}

extension AdvertisingService: MCSessionDelegate {
    
    // Connection with host
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
    
    // method for security that requires a certificate to connect.
    // This is currently unused and the guest will always connect to a host if it can
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {

        

        print("Recieved Data")

        if data[0] == 1 {

            print("recieved command to disconnect")

            session.disconnect()

        }

        

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

