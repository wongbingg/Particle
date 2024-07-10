//
//  NSMutableAttributedString+.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/13.
//

import UIKit

extension NSMutableAttributedString {
    
    func attributeString(string: String, font: UIFont?, textColor: UIColor, lineHeightMultiple: CGFloat? = nil, isCenter: Bool = false) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .font: font ?? UIFont.boldSystemFont(ofSize: 16),
            .foregroundColor: textColor
        ]
        
        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeightMultiple = lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }
        
        if isCenter {
            paragraphStyle.alignment = .center
        }

        attributes[.paragraphStyle] = paragraphStyle

        self.append(NSAttributedString(string: string, attributes: attributes))
        
        return self
    }
}
