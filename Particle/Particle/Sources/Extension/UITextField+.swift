//
//  UITextField+.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
