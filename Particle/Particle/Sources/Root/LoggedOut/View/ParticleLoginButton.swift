//
//  ParticleLoginButton.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/15.
//

import UIKit
import SnapKit

final class ParticleLoginButton: UIView {

    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        return label
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        return stack
    }()
    
    init(backgroundColor: UIColor, iconImage: UIImage?, title: String, titleColor: UIColor) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = 8
        iconImageView.image = iconImage
        titleLabel.text = title
        titleLabel.textColor = titleColor
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Settings

private extension ParticleLoginButton {
    
    func addSubviews() {
        addSubview(mainStack)
        
        [iconImageView, titleLabel].forEach {
            mainStack.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        mainStack.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
