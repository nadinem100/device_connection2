//
//  BLECore.swift
//  BLE_Personal
//
//  Created by Joshua Qiu on 1/14/21.
//

import Foundation
import CoreBluetooth

//struct BLEDevice: Equatable {
//    var uuid: String
//    var deviceName: String
//
//    static func ==(lhs: BLEDevice, rhs: BLEDevice) -> Bool {
//        return lhs.uuid == rhs.uuid
//    }
//}
//
protocol BLECoreDelegate: class {
    func discoveredDevicesUpdated(discoveredDevices: [BLEDevice])
    func connectedDeviceUpdated(connectedDevice: BLEDevice?)
    func connectionStateUpdated()
    func notifyError(error: Error)
}

enum BLEConnectionStatus {
    case disconnected
    case connected
}

class BLEcore: NSObject{
    
    private var centralManager: CBCentralManager!
    private var services: [BLEService] = []
    private var device: CBPeripheral!
    private var auth: CBCharacteristic?
    var compressionDelegate: QCPRCompressionDelegate?
    
//    var dataService: MultipeerDataService!
    
    private var discoveredPeripherals: [String: CBPeripheral] = [:]
    weak var delegate: BLECoreDelegate?
    private var connectedPeripheral: CBPeripheral? {
        didSet {
            delegate?.connectedDeviceUpdated(connectedDevice: connectedDevice())
        }
    }
    var connectedPeripheralStatus: BLEConnectionStatus = .disconnected

    private (set) var enabled: Bool = false {
        didSet {
            if enabled {
                print("called from enabled place, meaning enabled is true...", enabled)
                scanForPeripherals()
            } else {
                stopScanning()
                disconnect(connectedPeripheral)
            }
        }
    }
    
    private override init(){}
    
    //Bluetooth initialized with desired service UUIDs
    convenience init(services: [BLEService]){//, dataService: MultipeerDataService){
        self.init()
        self.services = services
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: false])
//        self.dataService = dataService
//        compressionDelegate = QCPRCompressionDelegate()
    }
    
    func start() {
        enabled = true
//         dataService = dataService
    }
    
    func discoveredDevices() -> [BLEDevice] {
        var devices: [BLEDevice] = []
        for (_ , peripheral) in discoveredPeripherals {
            devices.append(peripheral.toDevice())
        }
        return devices
    }
    
    private func resolvePeripheral(device: BLEDevice) -> CBPeripheral? {
        return discoveredPeripherals[device.uuid!]
    }
    
    func requestConnect(device: BLEDevice) {
        if let peripheral = resolvePeripheral(device: device) {
            connect(peripheral)
        }
    }
    
    func requestDisconnect(device: BLEDevice) {
        if let peripheral = resolvePeripheral(device: device) {
            disconnect(peripheral)
        }
    }
    
    private func connect(_ peripheral: CBPeripheral) {
        stopScanning()
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    private func disconnect(_ peripheral: CBPeripheral?) {
        guard let peripheral = peripheral else { return }
        centralManager.cancelPeripheralConnection(peripheral)
        clearConnectedDevices()
        
        delegate?.connectionStateUpdated()
    }
    
    private func stopScanning() {
        centralManager.stopScan()
        delegate?.connectionStateUpdated()
    }
    
    private func clearConnectedDevices() {
        connectedPeripheral = nil
        connectedPeripheralStatus = .disconnected
        delegate?.connectedDeviceUpdated(connectedDevice: nil)
        discoveredPeripherals.removeAll()
        notifyDiscoveredDevicesChanged()
    }
    
    func isScanning() -> Bool {
        return centralManager.isScanning
    }
    func connectedDevice() -> BLEDevice? {
        return connectedPeripheral?.toDevice()
    }
    func bluetoothOn() -> Bool {
        return centralManager.state == .poweredOn
    }
    
    private func scanForPeripherals() {
        if !enabled { return }
        if centralManager.isScanning { return }
        guard centralManager.state == .poweredOn else { return }
        print("Central scanning for Peripherals")
        discoveredPeripherals.removeAll()
        notifyDiscoveredDevicesChanged()
        centralManager.scanForPeripherals(withServices: nil,
                                          options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        
        delegate?.connectionStateUpdated()
    }
}

//Periphal connection functions
extension BLEcore: CBCentralManagerDelegate{
    
    //Startup
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            if connectedPeripheral != nil {
                connect(connectedPeripheral!)
            } else {
                scanForPeripherals()
            }
        } else {
            // Any previous BLE results are now invalid and must be rediscovered!
            discoveredPeripherals.removeAll()
            connectedPeripheral = nil
        }
        delegate?.connectionStateUpdated()
    }
    
    //Discover peripheral, could also go in CBPeripheralDelegate extension, don't really know why
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //checking for laerdal equipment
        guard let manufacturerData = advertisementData[CBAdvertisementDataManufacturerDataKey] as? Data else {
            return
        }

        //Laerdal Medical company ID is 0x01CA
        guard manufacturerData[0] == NSInteger(0xca) &&
                manufacturerData[1] == NSInteger(0x01) else {
            return
        }

        device = peripheral
        
        // print("Discovered: " + device.identifier.uuidString)
        discoveredPeripherals[peripheral.identifier.uuidString] = peripheral
        notifyDiscoveredDevicesChanged()

        //for now, connect automatically
        if peripheral == connectedPeripheral && connectedPeripheralStatus != .connected {
            print("Reconnecting to peripheral")
            connect(peripheral)
        }
    }
    
    //Connected to peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected")
        self.connectedPeripheral = peripheral
        peripheral.discoverServices(nil)
        connectedPeripheralStatus = .connected
    }
    
    private func notifyDiscoveredDevicesChanged() {
        delegate?.discoveredDevicesUpdated(discoveredDevices: discoveredDevices())
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        clearConnectedDevices()
        scanForPeripherals()
    }
    
}

//Peripheral service functions
extension BLEcore: CBPeripheralDelegate{
    
    //Services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        guard let peripheralServices = peripheral.services else {return}
        
        for service in peripheralServices{
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
    }
    
    //Characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        guard let characteristics = service.characteristics else {return}
        
        for characteristic in characteristics {
            
            //Session
            if characteristic.uuid == SessionCharacteristics.sessionControl.cbUUID {
                
                //send authenticaion after 1 second delay (must first get auth characteristic)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    //send authentication
                    guard let auth = self.auth else { return }
                    
                    let authBytes:[UInt8] = [0x5c,0x0e,0xb9,0xbe,0x03,0xd2,0x60,0x09,0x6d,0x3e,0x1f,0x0c,0x80,0x26,0xc8,0x10,0x73,0xcd,0x2e,0xa2]
                    let authData = Data(bytes: authBytes, count: authBytes.count)
                    
                    peripheral.writeValue(authData, for: auth, type: .withResponse)
                    print("Sent Auth Data")
                    
                    //set session
                    var parameter = NSInteger(0x03)
                    let data = Data(bytes: &parameter, count: 1)
                    peripheral.writeValue(data, for: characteristic, type: .withResponse)
                    
                    peripheral.readValue(for: characteristic)
                    print("Set Session")
                }
            
            } else if characteristic.uuid == SessionCharacteristics.cprProtocol.cbUUID {
                
                print("cprProtocol found")
                //sending in cpr protocol
                var parameter = NSInteger(0x03)
                let data = Data(bytes: &parameter, count: 1)
                peripheral.writeValue(data, for: characteristic, type: .withResponse)

                peripheral.readValue(for: characteristic)
                
            //Get authentification characteristic to write to (should run before first if)
            } else if characteristic.uuid == AuthenticationCharacteristics.authentication.cbUUID {
                
                print(AuthenticationCharacteristics.authentication.cbUUID)
                self.auth = characteristic
                print("Auth found")
            } else if characteristic.uuid == CompressionCharacteristics.completeEvent.cbUUID {
                
                print("Complete Event found")
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
                
            } else if characteristic.uuid == CompressionCharacteristics.wave.cbUUID {
                
                print("Wave found")
                peripheral.readValue(for: characteristic)
                peripheral.setNotifyValue(true, for: characteristic)
                
            }
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.uuid == CompressionCharacteristics.completeEvent.cbUUID{
            print("Compression updated for ", peripheral.identifier.uuidString)
            processUpdate_compev(uuid: characteristic.uuid.uuidString, data: characteristic.value)
        }else if characteristic.uuid == CompressionCharacteristics.wave.cbUUID{
//            print("Wave updated")
        } else{
//            print(characteristic.uuid.uuidString, " updated")
        }
    }

    //was in CompressionEventProcessor
    func processUpdate_compev(uuid: String, data: Data?) {
        let maxCompressionDepth = Int(data?[6] ?? 0)
        let rate = Int(data?[9] ?? 0)
        print("compression depth:", maxCompressionDepth)
        print("compression rate:", rate)
        compressionDelegate?.compressionUpdated(uuid: connectedDevice()?.uuid, comp_dep: maxCompressionDepth, comp_rate: rate)
    }
}

extension CBPeripheral {
    func toDevice() -> BLEDevice {
        return BLEDevice(uuid: identifier.uuidString, deviceName: name ?? "Unknown Device")
    }
}
