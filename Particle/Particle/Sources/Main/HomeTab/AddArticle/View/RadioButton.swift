//
//  RadioButton.swift
//  Particle
//
//  Created by 이원빈 on 2023/11/20.
//

import UIKit
import RxSwift
import RxRelay

final class RadioButton: UIView {
    
    enum Metric {
        static let width: CGFloat = (DeviceSize.width-48)/2
        static let height: CGFloat = 44
        static let iconSize: CGFloat = 20
        static let horizontalMargin: CGFloat = 16
    }
    
    private(set) var state: BehaviorRelay<Bool> = .init(value: false)
    private let disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    
    private let button: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray01
        view.layer.cornerRadius = 8
        view.layer.borderColor = .particleColor.main100.cgColor
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let checkIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = .particleImage.check
        return icon
    }()
    
    // MARK: - Initializers
    
    init(title: String) {
        super.init(frame: .zero)
        setTitle(text: title)
        setTapGesture()
        bind()
//        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Override
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addSubviews()
        setConstraints()
    }
    
    // MARK: - Methods
    
    private func setTitle(text: String) {
        titleLabel.setParticleFont(
            .p_body01,
            color: .particleColor.gray03,
            text: text)
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(cardStyleButtonTapped))
        button.addGestureRecognizer(tapGesture)
    }
    
    private func bind() {
        state.bind { [weak self] isTapped in
            self?.button.layer.borderWidth = isTapped ? 1 : 0
            self?.checkIcon.isHidden = isTapped == false
            self?.titleLabel.textColor = isTapped ?
                .particleColor.white : .particleColor.gray03
        }
        .disposed(by: disposeBag)
    }
    
    @objc private func cardStyleButtonTapped(){
        let tap = state.value
        state.accept(!tap)
    }
}

// MARK: - Layout Settings

private extension RadioButton {
    
    func addSubviews() {
        addSubview(button)
        
        [titleLabel, checkIcon]
            .forEach { button.addSubview($0) }
    }
    
    func setConstraints() {
        
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(Metric.width)
            $0.height.equalTo(Metric.height)
        }
        
        checkIcon.snp.makeConstraints {
            $0.width.height.equalTo(Metric.iconSize)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Metric.horizontalMargin)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.horizontalMargin)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import SnapKit

@available(iOS 13.0, *)
struct RadioButton_Preview: PreviewProvider {
    
    static let radioButton: RadioButton = {
        let button = RadioButton(title: "텍스트")
        return button
    }()

    static var previews: some View {
        radioButton
            .showPreview()
    }
}
#endif
