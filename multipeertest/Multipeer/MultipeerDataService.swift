//
//  MultipeerDataService.swift
//  TruMonitor
//
//  Created by Richard Stewart on 20/07/2017.
//  Copyright © 2017 TruCorp Ltd. All rights reserved.
//

import UIKit
import Foundation
import MultipeerConnectivity

struct ControlRequest: Codable {
    var route: String?
    var rootPayload: String? = nil
    var payload: [String: String] = [:] // Legacy format - not used
}

struct Device: Codable, Equatable, Hashable {

    var uuid: String
    var name: String
    var color: String
    var buildNumber: Int
    
    private enum CodingKeys : String, CodingKey {
        case uuid
        case name
        case color
        case buildNumber
    }
    
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.uuid == rhs.uuid
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}


class MultipeerDataService: NSObject, MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    private static let kPeerIDKey = "peer_id"
    private static let kDeviceNameKey = "device_name"
    private static let kDeviceDataPayload = "device_data"
    
    private let myPeerId = MCPeerID(displayName: "Multipeer Device")
    private let serviceAdvertiser : MCNearbyServiceAdvertiser
    private let serviceBrowser : MCNearbyServiceBrowser
    
    private var discoveredPeers: [MCPeerID: Device] = [:]
    private var connectedPeers: [MCPeerID] = []
    
    lazy var session : MCSession = {
        let session = MCSession(peer: self.myPeerId, securityIdentity: nil, encryptionPreference: .optional)
        session.delegate = self
        return session
    }()
    
    override init() {
        
        let dataServiceType = "trumonitor-ctrl"

        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId,
                                                           discoveryInfo: [:],
                                                           serviceType: dataServiceType)
        
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId,
                                                     serviceType: dataServiceType)
    
        super.init()
    }
    
    func allDevices() -> [Device] {
        return Array(discoveredPeers.values)
    }
    
    func setup(isMaster: Bool) {
        
        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self
        
        if isMaster {
            self.serviceBrowser.startBrowsingForPeers()
        } else {
            self.serviceAdvertiser.startAdvertisingPeer()
        }
    }
    
    func start(isMaster: Bool) {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
        self.serviceAdvertiser.delegate = nil
        self.serviceBrowser.delegate = nil
        setup(isMaster: isMaster)
    }
    
    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
    }

    func send(request: ControlRequest, devices: [Device]) -> Bool {
        let peersVal = peers(devices: devices)
        
        return send(request: request, peers: peersVal)
    }
    
    func sendToAll(request: ControlRequest) {
        _ = send(request: request, peers: connectedPeers)
    }
    
    private func send(request: ControlRequest, peers: [MCPeerID]) -> Bool {
        guard let data = controlRequestData(request: request) else { return false }
        if peers.count == 0 { return false }
        do {
            try self.session.send(data, toPeers: peers, with: .reliable)
        } catch let error {
            print("%@", "Error for sending: \(error)")
            
            return false
        }
        return true
    }

    
    private func peers(devices: [Device]) -> [MCPeerID] {
        var peersToSend: [MCPeerID] = []
        for (discoveredPeer, device) in discoveredPeers {
            if devices.contains(device) {
                peersToSend.append(discoveredPeer)
            }
        }
        return peersToSend
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
    
    func sendMedia(peer: MCPeerID, imageName: String, localFileURL: URL, completionHandler: ((Error?) -> Swift.Void)? = nil) throws {
        
        session.sendResource(at: localFileURL, withName: imageName, toPeer: peer, withCompletionHandler: { (error) -> Void in
            if error != nil{
                print("Error in sending resource send resource: \(error!.localizedDescription)")
            } else {
                print("Successfully sent resource")
            }
            completionHandler?(error)
        })
    }
    
    private func connect(peerID: MCPeerID) {
        NSLog("%@", "invitePeer: \(peerID)")
        serviceBrowser.invitePeer(peerID, to: session, withContext: nil, timeout: 30)
    }
    
    func disconnect() {
        session.disconnect()
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func resetDevices() {
        discoveredPeers.removeAll()
    }
    
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("%@", "didNotStartAdvertisingPeer: \(error)")
    }
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        NSLog("%@", "didReceiveInvitationFromPeer \(peerID)")
        invitationHandler(true, self.session)
    }
    
    
    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("%@", "didNotStartBrowsingForPeers: \(error)")
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        NSLog("%@", "foundPeer: \(peerID)")
        
        connect(peerID: peerID)
    }

    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        NSLog("%@", "lostPeer: \(peerID)")
        
        discoveredPeers.removeValue(forKey: peerID)
    }
    
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("%@", "peer \(peerID) didChangeState: \(state)")
        
        switch state {
        case .notConnected:
            print("-- Multipleer Device State Not connected -- ")
            break
        case .connecting:
            print("-- Multipleer Device State Connecting -- ")
            break
        case .connected:
            print("-- Multipleer Device State Connected -- ")
            connectedPeers.append(peerID)
        @unknown default:
            break
        }
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    
        let decoder = JSONDecoder()
        do {
            let controlRequest = try decoder.decode(ControlRequest.self, from: data)
        } catch let error {
            print("%@", "Error receiving: \(error)")
        }
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        NSLog("%@", "didReceiveStream")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        NSLog("%@", "didStartReceivingResourceWithName")
    }
    
    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL?,
                 withError error: Error?) {
        
        print("didFinishReceivingResourceWithName")
    }
    
}
