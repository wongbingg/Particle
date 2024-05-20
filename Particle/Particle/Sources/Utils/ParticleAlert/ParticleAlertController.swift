//
//  ParticleAlertController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/17.
//

import UIKit
import RxSwift

final class ParticleAlertController: UIViewController {
    
    private var disposeBag = DisposeBag()
    private let customTransitioningDelegate = ParticleAlertTransitioningDelegate()
    
    // MARK: - UIComponents
    
    private let mainStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 0
        view.backgroundColor = .init(hex: 0x252525)
        view.layer.cornerRadius = 14
        return view
    }()
    
    private let labelStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 2
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 19, left: 20, bottom: 0, right: 20)
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 17)
        label.textColor = .particleColor.white
        label.text = "title"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let contents: UILabel = {
        let label = UILabel()
        label.textColor = .particleColor.white
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 13)
        label.text = "정말 로그아웃 할까요?"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let spacer: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.height.equalTo(15)
        }
        return view
    }()
    
    private let horizontalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0x545458)
            .withAlphaComponent(0.65)
        view.snp.makeConstraints {
            $0.height.equalTo(0.33)
        }
        return view
    }()
    
    private let verticalDivider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(hex: 0x545458)
            .withAlphaComponent(0.65)
        view.snp.makeConstraints {
            $0.width.equalTo(0.33)
        }
        return view
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        return stack
    }()
    
    
    // MARK: - Initializers
    
    init(
        title: String? = nil,
        body: String?,
        buttons: [UIButton],
        buttonsAxis: NSLayoutConstraint.Axis = .horizontal
    ) {
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
        addSubviews()
        setConstraints()
        setupInitialView()
        
        titleLabel.text = title
        contents.text = body
        buttonStack.axis = buttonsAxis
        for (i, button) in buttons.enumerated() {
            buttonStack.addArrangedSubview(button)
            if i < buttons.count-1 {
                buttonStack.addArrangedSubview(
                    buttonsAxis == .vertical ? generateDivider(axis: .horizontal) :
                        generateDivider(axis: .vertical)
                )
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialView() {
//        view.backgroundColor = .particleColor.black.withAlphaComponent(0.9)
        view.backgroundColor = .clear
        self.view.layer.cornerRadius = 14
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .crossDissolve
        transitioningDelegate = customTransitioningDelegate
    }
    
    private func generateDivider(axis: NSLayoutConstraint.Axis) -> UIView {
        
        let divider = UIView()
        divider.backgroundColor = UIColor.init(hex: 0x545458).withAlphaComponent(0.65)
        divider.snp.makeConstraints {
            if axis == .horizontal {
                $0.height.equalTo(0.33)
            } else {
                $0.width.equalTo(0.33)
            }
        }
        return divider
        
    }
}

// MARK: - Layout Setting

private extension ParticleAlertController {
    
    func addSubviews() {
        [mainStack].forEach {
            view.addSubview($0)
        }
        
        [
            labelStack,
            generateDivider(axis: .horizontal),
            buttonStack
        ]
            .forEach {
                mainStack.addArrangedSubview($0)
            }
        
        if titleLabel.text == nil {
            [
                contents,
                spacer
            ]
                .forEach {
                    labelStack.addArrangedSubview($0)
                }
        } else {
            [
                titleLabel,
                contents,
                spacer
            ]
                .forEach {
                    labelStack.addArrangedSubview($0)
                }
        }
    }
    
    func setConstraints() {
        
        mainStack.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(52)
            $0.centerY.equalToSuperview()
        }
        labelStack.snp.makeConstraints {
            $0.top.equalToSuperview()
//                .inset(19)
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ParticleAlertController_Preview: PreviewProvider {
    static let button: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        return button
    }()
    static let button2: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        return button
    }()
    static var previews: some View {
        ParticleAlertController(
            title: nil,
            body: "정말 로그아웃 할까?\n저장한 파티클이 삭제됩니다.",
            buttons: [button2, button],
            buttonsAxis: .horizontal
        )
        .showPreview()
    }
}
#endif
