//
//  LoggedOutViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import SnapKit
import KakaoSDKUser
import AuthenticationServices

import UIKit

protocol LoggedOutPresentableListener: AnyObject {
    func successLogin_Serverless()
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable{
    
    weak var listener: LoggedOutPresentableListener?
    private var disposeBag = DisposeBag()
    
    private enum Metric {
        static let backgroundImageTopInset: CGFloat = 136
        static let backgroundImageBottomInset: CGFloat = 186
        
        enum TitleStack {
            static let spacing: CGFloat = 14
            static let topInset: CGFloat = 56
            static let horizontalInset: CGFloat = 20
        }
        
        enum ButtonStack {
            static let spacing: CGFloat = 16
            static let horizontalInset: CGFloat = 20
            static let bottomInset: CGFloat = 10
        }
    }
    
    // MARK: - UIComponents
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.TitleStack.spacing
        return stackView
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "나만의 문장을\n잘라 모아 보아요!"
        label.numberOfLines = 0
        label.font = .particleFont.generate(style: .ydeStreetB, size: 25)
        label.textColor = .particleColor.white
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "바로 시작해 보세요"
        label.font = .particleFont.generate(style: .pretendard_Medium, size: 16)
        label.textColor = .particleColor.white
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.ButtonStack.spacing
        return stackView
    }()
    
    private let normalLoginButton = ParticleLoginButton(
        backgroundColor: .particleColor.main100,
        iconImage: UIImage(systemName: "power")?.withTintColor(.white, renderingMode: .alwaysOriginal),
        title: " 오프라인으로 이용하기",
        titleColor: .init(hex:0xFFFFFF)
    )
    
    private let kakaoLoginButton = ParticleLoginButton(
        backgroundColor: .init(hex: 0xFEE500),
        iconImage: .particleImage.kakaoLogo,
        title: "카카오 로그인",
        titleColor: .init(hex: 0x191919)
    )

    private let appleLoginButton = ParticleLoginButton(
        backgroundColor: .init(hex: 0x000000),
        iconImage: .particleImage.appleLogo,
        title: "Apple 로그인",
        titleColor: .init(hex:0xFFFFFF)
    )
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.loginBackground
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var notReadyAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: "알림",
            body: "기능이 준비중입니다. 조금만 기다려주세요 🥹",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewLifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
        configureButton()
    }
    
    func present(viewController: ViewControllable) {
        present(viewController, animated: true, completion: nil)
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
    }
    
    private func configureButton() {
        
        let normalLoginButtonTapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(normalLoginButtonTapped)
        )
        
        normalLoginButton.addGestureRecognizer(normalLoginButtonTapGesture)
    }
    
    @objc
    private func normalLoginButtonTapped() {
        // TODO: 로그인 했다고 치고 홈화면으로 이동
        listener?.successLogin_Serverless()
        
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
}

// MARK: - Layout Settting

private extension LoggedOutViewController {
    
    func addSubviews() {
        [backgroundImage, titleStackView, buttonStackView].forEach {
            view.addSubview($0)
        }
        
        [mainTitle, subTitle].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [normalLoginButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        backgroundImage.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.centerY.equalToSuperview()
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(Metric.TitleStack.topInset)
            $0.horizontalEdges.equalToSuperview().inset(Metric.TitleStack.horizontalInset)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(Metric.ButtonStack.horizontalInset)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Metric.ButtonStack.bottomInset)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import AuthenticationServices

@available(iOS 13.0, *)
struct LoggedOutViewController_Preview: PreviewProvider {
    static var previews: some View {
        LoggedOutViewController().showPreview(.iPhone8Plus)
    }
}
#endif
