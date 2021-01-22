//
//  CompressionService.swift
//  qcpr
//
//  Created by Richard Stewart on 03/06/2020.
//  Copyright © 2020 Helix Labs Ltd. All rights reserved.
//

import UIKit

enum QCPRService: String, CaseIterable, BLEService {
    
    //EACH SERVICE CAN BE A COMPRESSION< SESSION< OR AUTHENTICATION
    case compression = "00000026-D746-4092-84E7-DAD34863FE4A"
    case session = "00000126-D746-4092-84E7-DAD34863FE4A"
    case authentication = "000001B0-D746-4092-84E7-DAD34863FE4A"
    
    func uuid() -> String {
        return rawValue
    }
    
    //Depending on case, return the charecteristics of that service
    func characteristics() -> [BLECharacteristic] {
        switch self {
        case .compression:
            return CompressionCharacteristics.allCases
        case .session:
            return SessionCharacteristics.allCases
        case .authentication:
            return AuthenticationCharacteristics.allCases
        }
    }
    
    func name() -> String {
        switch self {
        case .compression:
            return "Compression Service"
        case .session:
            return "Session Service"
        case .authentication:
            return "Authentication Service"
        }
    }
}

                            //enum type, .allCases protocol, BLE protocol
enum CompressionCharacteristics: String, CaseIterable, BLECharacteristic {
    case wave = "00000027-D746-4092-84E7-DAD34863FE4A"
    case completeEvent = "00000028-D746-4092-84E7-DAD34863FE4A"
    case rateGuideline = "00000235-D746-4092-84E7-DAD34863FE4A"
    case inactivityTime = "00000030-D746-4092-84E7-DAD34863FE4A"
    case inactivityStartEvent = "00000031-D746-4092-84E7-DAD34863FE4A"
    
    //get uuid
    func uuid() -> String {
        return rawValue
    }
    
    //get name
    func name() -> String {
        switch self {
        case .wave:
            return "Compression Wave"
        case .completeEvent:
            return "Compression Complete Event"
        case .inactivityTime:
            return "Compression Inactivity Time"
        case .inactivityStartEvent:
            return "Compression Inactivity Start Event"
        case .rateGuideline:
            return "Rate Guideline"
        }
    }
}

enum SessionCharacteristics: String, CaseIterable, BLECharacteristic {
    case sessionControl = "00000127-D746-4092-84E7-DAD34863FE4A"
    case episodeDuration = "0000012A-D746-4092-84E7-DAD34863FE4A"
    case cprProtocol = "0000012B-D746-4092-84E7-DAD34863FE4A"
    case cprInactivityConfiguration = "0000012C-D746-4092-84E7-DAD34863FE4A"
    case cprInactivityControl = "0000012D-D746-4092-84E7-DAD34863FE4A"
    case localCPRFeedbackControl = "0000012E-D746-4092-84E7-DAD34863FE4A"
    case scoringMode = "0000012F-D746-4092-84E7-DAD34863FE4A"
    case movingAverageScoringMode = "00000130-D746-4092-84E7-DAD34863FE4A"
    
    func uuid() -> String {
        return rawValue
    }
    
    func name() -> String {
        switch self {
        case .sessionControl:
            return "Session Control"
        case .episodeDuration:
            return "Episode Duration"
        case .cprProtocol:
            return "CPR Protocol"
        case .cprInactivityConfiguration:
            return "CPR Inactivity Configuration"
        case .cprInactivityControl:
            return "CPR Inactivity Control"
        case .localCPRFeedbackControl:
            return "Local CPR Feedback Control"
        case .scoringMode:
            return "Scoring Mode"
        case .movingAverageScoringMode:
            return "Moving Average Scoring Mode"
        }
    }
}

enum AuthenticationCharacteristics: String, CaseIterable, BLECharacteristic {
    case authentication = "000001B1-D746-4092-84E7-DAD34863FE4A"
    case authenticationStatus = "000001B2-D746-4092-84E7-DAD34863FE4A"
    
    func uuid() -> String {
        return rawValue
    }
    
    func name() -> String {
        switch self {
        case .authentication:
            return "Authentication"
        case .authenticationStatus:
            return "Authentication Status"
        }
    }
}
