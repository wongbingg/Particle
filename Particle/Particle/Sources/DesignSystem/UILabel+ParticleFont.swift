//
//  UILabel+ParticleFont.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import UIKit

enum Particle_Font {
    // MARK: - Pretendart
    case p_title01
    case p_title02
    case p_title03
    case p_body01
    case p_body01_bold
    case p_body02
    case p_headline
    case p_callout
    case p_subhead
    case p_footnote
    case p_caption
    case p_txtbutton
    // MARK: - YDE
    case y_title01
    case y_title02
    case y_body01
    case y_headline
    
    var fontStyle: UIFont? {
        switch self {
        case .p_title01:
            return .particleFont.generate(style: .pretendard_SemiBold, size: 25)
        case .p_title02:
            return .particleFont.generate(style: .pretendard_Regular, size: 19)
        case .p_title03:
            return .particleFont.generate(style: .pretendard_Regular, size: 17)
        case .p_body01:
            return .particleFont.generate(style: .pretendard_Regular, size: 16)
        case .p_body01_bold:
            return .particleFont.generate(style: .pretendard_Bold, size: 16)
        case .p_body02:
            return .particleFont.generate(style: .pretendard_Regular, size: 14)
        case .p_headline:
            return .particleFont.generate(style: .pretendard_SemiBold, size: 14)
        case .p_callout:
            return .particleFont.generate(style: .pretendard_Regular, size: 13)
        case .p_subhead:
            return .particleFont.generate(style: .pretendard_Regular, size: 12)
        case .p_footnote:
            return .particleFont.generate(style: .pretendard_Regular, size: 12)
        case .p_caption:
            return .particleFont.generate(style: .pretendard_Regular, size: 11)
        case .p_txtbutton:
            return .particleFont.generate(style: .pretendard_Regular, size: 11)
        case .y_title01:
            return .particleFont.generate(style: .ydeStreetB, size: 25)
        case .y_title02:
            return .particleFont.generate(style: .ydeStreetB, size: 19)
        case .y_body01:
            return .particleFont.generate(style: .ydeStreetB, size: 16)
        case .y_headline:
            return .particleFont.generate(style: .ydeStreetB, size: 14)
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .p_title01:
            return 30
        case .p_title02:
            return 22.8
        case .p_title03:
            return 20.4
        case .p_body01:
            return 24
        case .p_body01_bold:
            return 24
        case .p_body02:
            return 21
        case .p_headline:
            return 21
        case .p_callout:
            return 15.6
        case .p_subhead:
            return 14.4
        case .p_footnote:
            return 14.4
        case .p_caption:
            return 13.2
        case .p_txtbutton:
            return 13.2
        case .y_title01:
            return 32.5
        case .y_title02:
            return 28.5
        case .y_body01:
            return 24
        case .y_headline:
            return 21
        }
    }
    
}

extension UILabel {
    
    func setParticleFont(_ font: Particle_Font, color: UIColor, text: String? = nil) {
        self.font = font.fontStyle
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = font.lineHeight
        style.maximumLineHeight = font.lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .paragraphStyle: style,
            .baselineOffset: (font.lineHeight - self.font.lineHeight) / 4
        ]
        let attrString = NSAttributedString(string: text ?? "", attributes: attributes)
        self.attributedText = attrString
    }
}
