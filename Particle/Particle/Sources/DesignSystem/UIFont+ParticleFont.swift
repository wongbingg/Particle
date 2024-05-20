//
//  UIFont+ParticleFont.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

import UIKit

extension UIFont {
    static let particleFont = ParticleFont()
}

struct ParticleFont {
    
    func generate(style: FontStyle, size: CGFloat) -> UIFont? {
        return UIFont(name: style.rawValue, size: size)
    }
    
    // MARK: - Pretendard
    
    // MARK: - YDE
    
}

enum FontStyle: String {
    case pretendard_Black = "Pretendard-Black"
    case pretendard_Bold = "Pretendard-Bold"
    case pretendard_ExtraBold = "Pretendard-ExtraBold"
    case pretendard_ExtraLight = "Pretendard-ExtraLight"
    case pretendard_Light = "Pretendard-Light"
    case pretendard_Medium = "Pretendard-Medium"
    case pretendard_Regular = "Pretendard-Regular"
    case pretendard_SemiBold = "Pretendard-SemiBold"
    case pretendard_Thin = "Pretendard-Thin"
    case ydeStreetB = "YdestreetB"
    case ydeStreetL = "YdestreetL"
}
