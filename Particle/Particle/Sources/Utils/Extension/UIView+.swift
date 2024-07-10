//
//  UIView+.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/08.
//

import UIKit

extension UIView {
    
    func addRoundedCorner(corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        layer.mask = maskLayer
    }
}
