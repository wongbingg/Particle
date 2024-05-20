//
//  Console.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/20.
//

struct Console {
    static func log(_ message: String) {
        print("[LOG] \(message)")
    }
    
    static func debug(_ message: String) {
        print("[DEBUG] \(message)")
    }
    
    static func error(_ message: String) {
        print("[ERROR] \(message)")
    }
}
