//
//  SelectTagViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit

protocol SelectTagPresentableListener: AnyObject {
    func backButtonTapped()
    func startButtonTapped(with selectedTags: [String])
    func startButtonTapped_Serverless(with selectedTags: [String])
}

final class SelectTagViewController: UIViewController,
                                     SelectTagPresentable,
                                     SelectTagViewControllable {
    
    enum Metric {
        
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
        
        enum MainScrollView {
            static let topMargin: CGFloat = 12
        }
        
        enum TitleStack {
            static let topMargin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
        }
        
        enum AccordionStack {
            static let topMargin: CGFloat = 18
            static let bottomMargin: CGFloat = 20
        }
        
        enum StartButton {
            static let height: CGFloat = 44
            static let horizontalMargin: CGFloat = 20
        }
    }

    weak var listener: SelectTagPresentableListener?
    private var disposeBag: DisposeBag = .init()
    private var errorDescription = ""
    
    private var selectedTags: BehaviorRelay<[[String]]> = .init(value: Array(repeating: [], count: 5))
    
    // MARK: - UIComponents
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let accordionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private let titleStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "관심 태그를 설정하고\n아티클을 저장해보세요" // TODO: lineHeight 지정
        label.numberOfLines = 2
        label.font = .particleFont.generate(style: .ydeStreetB, size: 19)
        label.textColor = .particleColor.gray04
        return label
    }()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.text = "최대 5개까지 설정할 수 있어요."
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 12)
        label.textColor = .particleColor.main100
        return label
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
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        button.setTitleColor(.particleColor.gray03, for: .disabled)
        button.setTitleColor(.particleColor.gray01, for: .normal)
        button.backgroundColor = .particleColor.main30
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
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
        modalPresentationStyle = .fullScreen
        modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
        setupNavigationBar()
        configureButton()
        bindAccordion()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.backButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {

        startButton.rx.tap
            .bind { [weak self] _ in
                guard let self = self else { return }
                let tags = self.selectedTags.value.flatMap { $0 }
                let mappedTags = tags.map { Tag(rawValue: $0)?.value ?? "UXUI" }
                self.listener?.startButtonTapped_Serverless(with: mappedTags)
            }
            .disposed(by: disposeBag)
    }
    
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
                guard let selectedTagsInAccordion = selectedTagsInAccordion.element else {
                    return
                }
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
        
        selectedTags
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] tags in
                let flattenList = tags.flatMap { $0 }

                if flattenList.isEmpty {
                    self?.startButton.isEnabled = false
                    self?.startButton.backgroundColor = .particleColor.main30
                } else {
                    self?.startButton.isEnabled = true
                    self?.startButton.backgroundColor = .particleColor.main100
                }
            }
            .disposed(by: disposeBag)
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
    
    func showErrorAlert(description: String) {
        errorDescription = description
        present(failureResultAlertController, animated: true)
    }
    
    private func showWarningAlert() {
        present(restrictCountAlertController, animated: true)
    }
}

// MARK: - Layout Settting

private extension SelectTagViewController {
    
    func addSubviews() {
        
        [backButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [navigationBar, mainScrollView, startButton].forEach {
            view.addSubview($0)
        }
        
        [titleStack, accordionStack].forEach {
            mainScrollView.addSubview($0)
        }
        
        [mainTitle, subTitle].forEach {
            titleStack.addArrangedSubview($0)
        }
        
        [accordion1, accordion2, accordion3, accordion4, accordion5].forEach {
            accordionStack.addArrangedSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(Metric.MainScrollView.topMargin)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(startButton.snp.top)
        }
        
        titleStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Metric.TitleStack.topMargin)
            $0.horizontalEdges.equalToSuperview().inset(Metric.TitleStack.horizontalMargin)
        }
        
        accordionStack.snp.makeConstraints {
            $0.top.equalTo(titleStack.snp.bottom).offset(Metric.AccordionStack.topMargin)
            $0.leading.trailing.equalTo(mainScrollView)
            $0.bottom.equalTo(mainScrollView).inset(Metric.AccordionStack.bottomMargin)
            $0.width.equalTo(mainScrollView.frameLayoutGuide)
        }
        
        startButton.snp.makeConstraints {
            $0.width.equalToSuperview().inset(Metric.StartButton.horizontalMargin)
            $0.height.equalTo(Metric.StartButton.height)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SelectTagViewController_Preview: PreviewProvider {
    static var previews: some View {
        SelectTagViewController().showPreview()
    }
}
#endif
