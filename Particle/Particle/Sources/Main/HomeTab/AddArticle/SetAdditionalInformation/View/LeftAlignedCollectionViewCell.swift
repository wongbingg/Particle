//
//  LeftAlignedCollectionViewCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/13.
//

import UIKit
import SnapKit

class LeftAlignedCollectionViewCell: UICollectionViewCell {
    
    enum Metric {
        static let horizontalMargin = 24
        static let verticalMargin = 12
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 13)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .particleColor.gray04
        return label
    }()
    
    private(set) var isTapped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        attribute()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        attribute()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func attribute() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderWidth = 1
        self.layer.borderColor = isTapped ? .particleColor.main100.cgColor : .particleColor.gray03.cgColor
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metric.verticalMargin)
            make.left.right.equalToSuperview().inset(Metric.horizontalMargin)
        }
    }
    
    func setSelected(_ bool: Bool) {
        isTapped = bool
        
        if isTapped {
            self.titleLabel.textColor = .particleColor.main100
        } else {
            self.titleLabel.textColor = .particleColor.gray04
        }
    }
}

class LeftAlignedCollectionViewCell2: UICollectionViewCell {
    
    enum Metric {
        static let horizontalMargin = 16
        static let verticalMargin = 6
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 11)
        label.textAlignment = .center
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textColor = .particleColor.main100
        return label
    }()
    
    private var isTapped = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        attribute()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        attribute()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func attribute() {
        self.backgroundColor = .particleColor.gray01
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.height / 2
        
    }
    
    private func layout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metric.verticalMargin)
            make.left.right.equalToSuperview().inset(Metric.horizontalMargin)
        }
    }
//
//    func setSelected() {
//        isTapped.toggle()
//
//        if isTapped {
//            self.titleLabel.textColor = .particleColor.main100
//        } else {
//            self.titleLabel.textColor = .particleColor.gray04
//        }
//    }
}
