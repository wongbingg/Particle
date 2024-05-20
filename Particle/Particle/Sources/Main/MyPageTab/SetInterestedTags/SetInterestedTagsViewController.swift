//
//  SelectInterestedTagsViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/10.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit

protocol SetInterestedTagsPresentableListener: AnyObject {
    func setInterestedTagsBackButtonTapped()
    func setInterestedTagsOKButtonTapped(with tags: [String])
    func setInterestedTagsOKButtonTapped_Serverless(with tags: [String])
}

final class SetInterestedTagsViewController: UIViewController,
                                             SetInterestedTagsPresentable,
                                             SetInterestedTagsViewControllable {
    
    weak var listener: SetInterestedTagsPresentableListener?
    private var disposeBag = DisposeBag()
    private var selectedTags: BehaviorRelay<[[String]]> = .init(value: Array(repeating: [], count: 5))
    private var errorDescription = ""
    
    enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let okButtonRightMargin = 8
        }
    }
    
    // MARK: - UI Components
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = .particleColor.main100
        
        return activityIndicator
    }()
    
    private let navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        
        button.setAttributedTitle(
            NSMutableAttributedString()
                .attributeString(
                    string: "확인",
                    font: .particleFont.generate(style: .pretendard_SemiBold, size: 16),
                    textColor: .particleColor.main100
                ),
            for: .normal
        )
        
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.white, text: "관심 태그 설정")
        return label
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let accordion1 = Accordion(
        title: "디자인",
        tags: ["#브랜딩", "#UXUI", "#그래픽 디자인", "#산업 디자인"]
    )
    
    private let accordion2 = Accordion(
        title: "마케팅",
        tags: ["#브랜드 마케팅", "#그로스 마케팅", "#콘텐츠 마케팅"]
    )
    
    private let accordion3 = Accordion(
        title: "기획",
        tags: ["#서비스 기획", "#전략 기획", "#시스템 기획", "#데이터 분석"]
    )
    
    private let accordion4 = Accordion(
        title: "개발",
        tags: ["#iOS", "#Android", "#Web", "#서버", "#AI"]
    )
    
    private let accordion5 = Accordion(
        title: "스타트업",
        tags: ["#조직 문화", "#트렌드", "#CX", "#리더쉽", "#인사이트"]
    )
    
    private lazy var restrictCountAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: "오류",
            body: "최대 5개까지 설정할 수 있어요",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    private lazy var successResultAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.dismiss(animated: true, completion: { [weak self] in
                self?.listener?.setInterestedTagsBackButtonTapped()
            })
        }
        
        let alert = ParticleAlertController(
            title: "알림",
            body: "관심 태그 설정이 완료되었습니다.",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    private lazy var failureResultAlertController: ParticleAlertController = {
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
        bindAccordion()
        configureButton()
    }
    
    // MARK: - Methods
    
    private func bindAccordion() {
        
        let accordions: [Accordion] = [
            accordion1,
            accordion2,
            accordion3,
            accordion4,
            accordion5
        ]
        
        accordions.enumerated().forEach { (i, accordion) in
            
            accordion.selectedTags.subscribe { [weak self] selectedTagsInAccordion in
                guard let self = self else { return }
                guard let selectedTagsInAccordion = selectedTagsInAccordion.element else { return }
                var list = self.selectedTags.value
                list[i] = selectedTagsInAccordion
                if list.flatMap({ $0 }).count > 5 {
                    self.showWarningAlert()
                    accordion.manager.undo()
                } else {
                    self.selectedTags.accept(list)
                    Console.log("\(self.selectedTags.value)")
                }
            }
            .disposed(by: disposeBag)
        }
        
        selectedTags.subscribe { [weak self] tags in
            let flattenList = tags.flatMap { $0 }
            if flattenList.isEmpty {
                self?.okButton.isEnabled = false
            } else {
                self?.okButton.isEnabled = true
            }
        }
        .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        backButton.rx.tap.bind { [weak self] _ in
            self?.listener?.setInterestedTagsBackButtonTapped()
        }
        .disposed(by: disposeBag)
        
        okButton.rx.tap.bind { [weak self] _ in
            self?.listener?.setInterestedTagsOKButtonTapped_Serverless(
                with: self?.selectedTags.value
                    .flatMap { $0 }
                    .map { Tag.init(rawValue: $0)?.value ?? "UXUI" } ?? []
            )
            self?.activityIndicator.startAnimating()
        }
        .disposed(by: disposeBag)
    }
    
    func showUploadSuccessAlert() {
        activityIndicator.stopAnimating()
        present(successResultAlertController, animated: true)
    }
    
    func showUploadFailAlert() {
        listener?.setInterestedTagsBackButtonTapped()
    }
    
    func showErrorAlert(description: String) {
        activityIndicator.stopAnimating()
        errorDescription = description
        present(failureResultAlertController, animated: true)
    }
    
    private func showWarningAlert() {
        present(restrictCountAlertController, animated: true)
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

// MARK: - Layout Setting

private extension SetInterestedTagsViewController {
    
    func addSubviews() {
        [backButton, navigationTitle, okButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [navigationBar, mainScrollView, activityIndicator].forEach {
            view.addSubview($0)
        }
        
        [mainStackView].forEach {
            mainScrollView.addSubview($0)
        }
        
        [accordion1, accordion2, accordion3, accordion4, accordion5].forEach {
            mainStackView.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        okButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(Metric.NavigationBar.okButtonRightMargin)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainStackView.snp.makeConstraints{
            $0.top.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(mainScrollView.frameLayoutGuide)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
}


// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SetInterestedTagsViewController_Preview: PreviewProvider {
    static var previews: some View {
        SetInterestedTagsViewController().showPreview()
    }
}
#endif
