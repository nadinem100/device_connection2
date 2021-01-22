//
//  CompressionCompleteEvent.swift
//  qcpr
//
//  retrieves rate and maximum compression depth

import UIKit

protocol CompressionEventDelegate: class {
    func receivedCompressionEvent(_ event: CompressionCompleteEvent)
}

struct CompressionCompleteEvent {
    var rate: Int
    var maxCompressionDepth: Int
    
    init(data: Data) {
        maxCompressionDepth = Int(data[6])
        rate = Int(data[9])
    }
    
}
