//
//  UIColor+ParticleColor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/26.
//

import UIKit

extension UIColor {
    static let particleColor = ParticleColor()
}

extension CGColor {
    static let particleColor = ParticleColor()
}

struct ParticleColor {
    let main100 = UIColor(hex: 0xA9ACFF)
    let main30 = UIColor(hex: 0x33344C)
    let mainW = UIColor(hex: 0x6A6AD8)
    
    let black = UIColor(hex: 0x1F1F1F)
    let black50 = UIColor(hex: 0x1F1F1F).withAlphaComponent(0.5)
    
    let gray01 = UIColor(hex: 0x2E2E2E)
    let gray02 = UIColor(hex: 0x323232)
    let gray03 = UIColor(hex: 0x696969)
    let gray04 = UIColor(hex: 0xC5C5C5)
    let gray05 = UIColor(hex: 0xF3F3F3)
    
    let bk01 = UIColor(hex: 0x000000)
    let bk02 = UIColor(hex: 0x161616)
    let bk03 = UIColor(hex: 0x1A1A1A)
    
    let white = UIColor(hex: 0xF6F6F6)
    let white10 = UIColor(hex: 0xF6F6F6).withAlphaComponent(0.06)
    
    let warning = UIColor(hex: 0xE57085)
    let yellow = UIColor(hex: 0xFFF9BE)
}
