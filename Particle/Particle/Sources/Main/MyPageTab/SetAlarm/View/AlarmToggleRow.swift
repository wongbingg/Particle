//
//  AlarmToggleRow.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import UIKit
import SnapKit
import RxSwift

final class AlarmToggleRow: UIView {
    
    private var disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body01, color: .particleColor.white, text: "출근할 때 한번 더 보기(stub)")
        return label
    }()
    
    private let toggleButton: UISwitch = {
        let button = UISwitch()
        button.onTintColor = .particleColor.main100
        return button
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray02
        view.snp.makeConstraints {
            $0.height.equalTo(1)
        }
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_subhead, color: .particleColor.gray04, text: "8시에 알림을 드릴게요(stub)")
        return label
    }()
    
    // MARK: - Initializers
    
    init(title: String, description: String, handler: @escaping (Bool) -> Void) {
        super.init(frame: .zero)
        addSubviews()
        setConstraints()
        setupInitialView()
        setupInitialData(title: title, description: description)
        
        bind(handler)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        backgroundColor = .particleColor.gray01
        layer.cornerRadius = 16
    }
    
    private func setupInitialData(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
        toggleButton.isOn =  UserDefaults.standard.bool(forKey: title)
    }
    
    private func bind(_ handler: @escaping (Bool) -> Void) {
        toggleButton.rx.isOn.bind { state in
            handler(state)
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Layout Settting

private extension AlarmToggleRow {
    
    func addSubviews() {
        
        [
            titleLabel,
            toggleButton,
            divider,
            descriptionLabel
        ]
            .forEach {
                addSubview($0)
            }
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(103)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(14)
            $0.leading.equalToSuperview().inset(16)
        }
        
        toggleButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        divider.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(divider.snp.bottom).offset(16)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import SnapKit

@available(iOS 13.0, *)
struct AlarmToggleRow_Preview: PreviewProvider {
    
    static let alarmToggleRow: AlarmToggleRow = {
        let row = AlarmToggleRow(title: "출근할 때 한번 더 보기", description: "8시에 알림을 드릴게요") { state in
            Console.debug("state is \(state)")
        }
        return row
    }()
    
    static var previews: some View {
        alarmToggleRow
            .showPreview()
    }
}
#endif
