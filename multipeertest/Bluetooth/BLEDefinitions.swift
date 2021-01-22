//
//  BLEService.swift
//  qcpr
//
//  Created by Richard Stewart on 03/06/2020.
//  Copyright © 2020 Helix Labs Ltd. All rights reserved.
//

import UIKit
import CoreBluetooth

protocol BLECharacteristic {
    func uuid() -> String
    func name() -> String
}

extension BLECharacteristic {
    var cbUUID: CBUUID {
         return CBUUID(string: uuid())
    }
}

protocol BLEService {
    func uuid() -> String
    func characteristics() -> [BLECharacteristic]
    func name() -> String
}

extension BLEService {
    var cbUUID: CBUUID {
        return CBUUID(string: uuid())
    }
    
    func characteristicUUIDs() -> [CBUUID] {
        return characteristics().map { $0.cbUUID }
    }
}
