//
//  SetAccountViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift
import UIKit

protocol SetAccountPresentableListener: AnyObject {
    func backButtonTapped()
    func deleteAccountButtonTapped()
    func logoutButtonTapped()
}

final class SetAccountViewController: UIViewController, SetAccountPresentable, SetAccountViewControllable {
    
    weak var listener: SetAccountPresentableListener?
    private var disposeBag = DisposeBag()
    private var errorDescription = ""
    
    enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
    }
    
    // MARK: - UI Components
    
    private let navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
    }()
    
    private let sectionTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_title01, color: .particleColor.white, text: "계정 설정")
        return label
    }()
    
    private let buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        return stack
    }()
    
    // MARK: - AlertController
    
    private lazy var logoutAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.listener?.logoutButtonTapped()
        }
        
        let cancelButton = generateAlertButton(title: "취소") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: "정말 로그아웃 할까요?",
            buttons: [cancelButton, okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    private lazy var deleteAccountAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.listener?.deleteAccountButtonTapped()
            self?.dismiss(animated: true)
            /// 이것때문에 누수오류가 있었어서 혹시몰라 순서 바꿈
        }
        
        let cancelButton = generateAlertButton(title: "취소") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: "정말 탈퇴 할까요?\n저장한 파티클이 삭제됩니다.",
            buttons: [cancelButton, okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    
    private lazy var deleteAccountSuccessResultAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.listener?.logoutButtonTapped()
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: "회원탈퇴에 성공했습니다.\n 초기화면으로 돌아갑니다.",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    private lazy var deleteAccountFailureResultAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: errorDescription,
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .particleColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            addRows(icon: .particleImage.arrowRight, title: "앱 버전", selector: nil, appVersion: "v "+appVersion)
        }
        addRows(icon: .particleImage.arrowRight, title: "로그아웃", selector: #selector(logoutButtonTapped))
//        addRows(icon: .particleImage.arrowRight, title: "탈퇴하기", selector: #selector(deleteAccountButtonTapped))
        bind()
    }
    
    private func bind() {
        backButton.rx.tap.bind { [weak self] _ in
            self?.listener?.backButtonTapped()
        }
        .disposed(by: disposeBag)
    }
    
    private func addRows(icon: UIImage?, title: String, selector: Selector?, appVersion: String? = nil) {
        let row = UIView()
        row.snp.makeConstraints {
            $0.width.equalTo(DeviceSize.width)
            $0.height.equalTo(54)
        }

        let iconImage = UIImageView()
        iconImage.image = icon

        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        label.textColor = .particleColor.white
        label.text = title

        [label, iconImage].forEach {
            row.addSubview($0)
        }

        iconImage.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(24)
        }

        label.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
        
        if let appVersion = appVersion {
            let subLabel = UILabel()
            subLabel.setParticleFont(.p_body01, color: .particleColor.white, text: appVersion)
            iconImage.removeFromSuperview()
            row.addSubview(subLabel)
            
            subLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.trailing.equalToSuperview().inset(30)
            }
        }

        buttonStack.addArrangedSubview(row)
        
        let tabAction = UITapGestureRecognizer(target: self, action: selector)
        row.addGestureRecognizer(tabAction)
    }
    
    @objc private func logoutButtonTapped() { 
        present(logoutAlertController, animated: true)
    }
    
    @objc private func deleteAccountButtonTapped() {
        present(deleteAccountAlertController, animated: true)
    }
    
    private func generateAlertButton(title: String, _ buttonAction: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        button.rx.tap.bind { [weak self] _ in
            buttonAction()
        }
        .disposed(by: disposeBag)
        
        return button
    }
    
    // MARK: - SetAccountPresentable
    
    func showErrorAlert(description: String) {
        errorDescription = description
        present(deleteAccountFailureResultAlertController, animated: true)
    }
    
    func showSuccessAlert() {
        present(deleteAccountSuccessResultAlertController, animated: true)
    }
}

// MARK: - Layout Settting

private extension SetAccountViewController {
    
    func addSubviews() {
        [backButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [
            navigationBar,
            sectionTitle,
            buttonStack
        ]
            .forEach {
                view.addSubview($0)
            }
    }
    
    func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.NavigationBar.height)
        }
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        sectionTitle.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.top.equalTo(navigationBar.snp.bottom).offset(12)
        }
        
        buttonStack.snp.makeConstraints {
            $0.top.equalTo(sectionTitle.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SetAccountViewController_Preview: PreviewProvider {
    static var previews: some View {
        SetAccountViewController().showPreview()
    }
}
#endif
