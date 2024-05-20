//
//  RecordDetailViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/02.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

protocol RecordDetailPresentableListener: AnyObject {
    func recordDetailCloseButtonTapped()
    func recordDetailDeleteButtonTapped(with id: String)
    func recordDetailReportButtonTapped(with id: String)
    func recordDetailSaveButtonTapped(with id: String)
    func recordDetailEditButtonTapped(with id: String)
}

final class RecordDetailViewController: UIViewController,
                                        RecordDetailPresentable,
                                        RecordDetailViewControllable {
    
    weak var listener: RecordDetailPresentableListener?
    private var disposeBag = DisposeBag()
    private let data: BehaviorRelay<RecordReadDTO> = .init(value: .stub())
    private let isMyRecord: Bool
    private let editable: Bool
    private var errorDescription = ""
    
    enum Metric {
        static let horizontalInset = 20
        
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
            static let buttonSize = 20
            static let buttonTapSize = 44
        }
        
        enum RecordTitle {
            static let topOffset: CGFloat = 12
        }
        
        enum SentenceStack {
            static let topOffset: CGFloat = 33
            static let spacing: CGFloat = 16
        }
        
        enum RecommendTagCollectionView {
            static let topOffset: CGFloat = 24
        }
        
        enum UrlLabel {
            static let topOffset: CGFloat = 24
        }
        
        enum DateLabel {
            static let topOffset: CGFloat = 16
            static let lineHeight: CGFloat = 21
        }
        
        enum DirectorLabel {
            static let topOffset: CGFloat = 4
            static let lineHeight: CGFloat = 21
        }
        
        enum HeartButton {
            static let topOffset: CGFloat = 27
            static let size: CGFloat = 20
        }
        
        enum ParticleAlert {
            static let buttonHeight: CGFloat = 44
        }
    }
    
    // MARK: - UI Components
    
    private let navigationBar: UIView = {
        let view = UIView()
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.equalTo(Metric.NavigationBar.buttonSize)
            $0.height.equalTo(Metric.NavigationBar.buttonSize)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(Metric.NavigationBar.buttonTapSize)
        }
        return button
    }()
    
    private let ellipsisButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.ellipsis, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.equalTo(Metric.NavigationBar.buttonSize)
            $0.height.equalTo(Metric.NavigationBar.buttonSize)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(Metric.NavigationBar.buttonTapSize)
        }
        return button
    }()
    
    private var mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let recordTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .y_title01,
            color: .white,
            text: "효과적인 포스트모텔 회의를 진행하는 방법"
        )
        label.numberOfLines = 0
        return label
    }()
    
    private let sentenceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.SentenceStack.spacing
        return stackView
    }()
    
    private let recommendTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 0
        
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(LeftAlignedCollectionViewCell2.self)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.text = "www.mockUrl.com"
        label.numberOfLines = 0
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 11)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "2023.05.23"
        label.numberOfLines = 0
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints{
            $0.height.equalTo(Metric.DateLabel.lineHeight)
        }
        return label
    }()
    
    private let directorLabel: UILabel = {
        let label = UILabel()
        label.text = "particle by _ 꾸꾸"
        label.numberOfLines = 0
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints{
            $0.height.equalTo(Metric.DirectorLabel.lineHeight)
        }
        return label
    }()
    
    private let heartButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.heart, for: .normal)
        button.snp.makeConstraints {
            $0.width.height.equalTo(Metric.HeartButton.size)
        }
        return button
    }()
    
    private lazy var warningAlertController: ParticleAlertController = {
        let alert = ParticleAlertController(
            title: "파티클 삭제",
            body: "내 파티클을 삭제하시면 복구할 수 없어요.\n내 파티클을 정말 삭제하시겠어요?",
            buttons: [deleteButton, cancelButton],
            buttonsAxis: .vertical
        )
        return alert
    }()
    
    private let deleteButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSMutableAttributedString()
                .attributeString(
                    string: "삭제",
                    font: .particleFont.generate(style: .pretendard_SemiBold, size: 17),
                    textColor: .init(hex: 0xFF453A)),
            for: .normal
        )
        button.snp.makeConstraints {
            $0.height.equalTo(Metric.ParticleAlert.buttonHeight)
        }
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(
            NSMutableAttributedString()
                .attributeString(
                    string: "취소",
                    font: .particleFont.generate(style: .pretendard_Regular, size: 17),
                    textColor: .init(hex: 0xC5C5C5)),
            for: .normal
        )
        button.snp.makeConstraints {
            $0.height.equalTo(Metric.ParticleAlert.buttonHeight)
        }
        return button
    }()
    
    private lazy var deleteSuccessResultAlertController: ParticleAlertController = {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.listener?.recordDetailCloseButtonTapped()
            self?.dismiss(animated: true)
            ///  recordDetailCloseButtonTapped 가 완료되기 전에 객체가 해제되는 것인가..?
            ///  위 두 메서드 실행순서를 바꿔주니 memory leak 사라짐..
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: "파티클 삭제에 성공했습니다.\n 홈화면으로 돌아갑니다.",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        return alert
    }()
    
    private lazy var deleteFailureResultAlertController: ParticleAlertController = {
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

    init(data: RecordReadDTO, editable: Bool = true) {
		self.data.accept(data)
        self.isMyRecord = data.createdBy == UserDefaults.standard.string(forKey: "USER_NAME")
        self.editable = editable
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .particleColor.black
        self.modalPresentationStyle = .fullScreen
        self.modalTransitionStyle = .coverVertical
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        setupInitialSetting()
        setSentences()
        configureButton()
        bind()
    }
    
    // MARK: - Methods
    
    private func setSentences() {
        
        data.bind { [weak self] record in
            guard let self = self else { return }
            setRecordTitle(record.title)
            urlLabel.text = record.url
            dateLabel.text = DateManager.shared.convert(previousDate: record.createdAt, to: "yyyy.MM.dd E요일")
            directorLabel.text = "particle by _ \(record.createdBy)"
            
            sentenceStack.removeAllArrangedSubviews()
            record.items
                .enumerated()
                .forEach { (i, text) in
                    let label = UILabel()
                    label.setParticleFont(
                        text.isMain ? .y_headline : .p_body02,
                        color: text.isMain ? .particleColor.gray05 : .particleColor.gray04,
                        text: text.content
                    )
                    label.numberOfLines = 0
                    self.sentenceStack.addArrangedSubview(label)
                }
        }
        .disposed(by: disposeBag)
    }
    
    private func setRecordTitle(_ text: String) {
        recordTitle.setParticleFont(.y_title01, color: .white, text: text)
    }
    
    private func bind() {
        Observable.of(data.value.tags)
            .bind(to: recommendTagCollectionView.rx.items(
                cellIdentifier: LeftAlignedCollectionViewCell2.defaultReuseIdentifier,
                cellType: LeftAlignedCollectionViewCell2.self)
            ) { index, item, cell in
                cell.titleLabel.text = item
            }
            .disposed(by: disposeBag)
    }
    
    private func configureButton() {
        closeButton.rx.tap
            .bind { [weak self] _ in
                self?.listener?.recordDetailCloseButtonTapped()
            }
            .disposed(by: disposeBag)
        
        ellipsisButton.rx.tap
            .bind { [weak self] _ in
                
                DispatchQueue.main.async { [weak self] in
                    self?.showActionSheetInMyRecord()
                }
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
                
                if let isMyRecord = self?.isMyRecord, isMyRecord == true {
                    self?.listener?.recordDetailDeleteButtonTapped(with: self?.data.value.id ?? "")
                } else {
                    self?.listener?.recordDetailReportButtonTapped(with: self?.data.value.id ?? "")
                }
            }
            .disposed(by: self.disposeBag)
        
        cancelButton.rx.tap
            .bind { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .disposed(by: self.disposeBag)
    }
    
    private func setupInitialSetting() {
        ellipsisButton.isHidden = !editable
    }
    
    private func showActionSheetInMyRecord() {
        let shareAction = UIAlertAction(title: "공유하기", style: .default) { [weak self] action in
            self?.shareParticle()
        }
        
        let modifyAction = UIAlertAction(
            title: isMyRecord ? "수정하기" : "저장하기",
            style: .default
        ) { [weak self] action in
            
            guard let self = self else { return }
            if isMyRecord {
                // 수정하기
                self.listener?.recordDetailEditButtonTapped(with: data.value.id)
            } else {
                self.listener?.recordDetailSaveButtonTapped(with: data.value.id)
            }
        }
        
        let deleteAction = UIAlertAction(
            title: isMyRecord ? "삭제하기" : "신고하기",
            style: .destructive
        ) { [weak self] action in
            self?.present(self?.warningAlertController ?? UIViewController(), animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        actionSheet.addAction(shareAction)
        actionSheet.addAction(modifyAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    private func shareParticle() {
        DynamicLinkMaker.execute(particleId: data.value.id)
            .subscribe { [weak self] url in
                let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
                activityController.completionWithItemsHandler = { (activity, success, items, error) in
                    if success {
                        
                    } else {
                        
                    }
                }
                self?.present(activityController, animated: true, completion: nil)
            } onError: { error in
                Console.error(error.localizedDescription)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - RecordDetailPresentable
    
    private func generateAlertButton(title: String, _ buttonAction: @escaping () -> Void) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        button.rx.tap.bind { _ in
            buttonAction()
        }
        .disposed(by: disposeBag)
        
        return button
    }
    
    func showErrorAlert(description: String) {
        errorDescription = description
        present(deleteFailureResultAlertController, animated: true)
    }
    
    func showSuccessAlert() {
        present(deleteSuccessResultAlertController, animated: true)
    }
    
    // MARK: - RecordDetailViewControllable
    
    func update(data: RecordReadDTO) {
        self.data.accept(data)
    }
}

// MARK: - Layout Settting

private extension RecordDetailViewController {
    func addSubviews() {
        [closeButton, ellipsisButton]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [
            recordTitle,
            sentenceStack,
            recommendTagCollectionView,
            urlLabel,
            dateLabel,
            directorLabel,
            heartButton
        ]
            .forEach {
                mainScrollView.addSubview($0)
            }
        
        [
            navigationBar,
            mainScrollView
        ]
            .forEach {
                self.view.addSubview($0)
            }
    }
    
    func setConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.NavigationBar.height)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        ellipsisButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        recordTitle.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(Metric.horizontalInset)
            $0.top.equalTo(mainScrollView.snp.top).offset(Metric.RecordTitle.topOffset)
        }
        
        sentenceStack.snp.makeConstraints {
            $0.top.equalTo(recordTitle.snp.bottom).offset(Metric.SentenceStack.topOffset)
            $0.leading.trailing.equalTo(mainScrollView.frameLayoutGuide).inset(Metric.horizontalInset)
        }
        
        recommendTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(sentenceStack.snp.bottom).offset(Metric.RecommendTagCollectionView.topOffset)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.horizontalInset)
        }
        
        urlLabel.snp.makeConstraints {
            $0.top.equalTo(recommendTagCollectionView.snp.bottom).offset(Metric.UrlLabel.topOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.horizontalInset)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(urlLabel.snp.bottom).offset(Metric.DateLabel.topOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.horizontalInset)
        }
        
        directorLabel.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(Metric.DirectorLabel.topOffset)
            $0.leading.trailing.equalToSuperview().inset(Metric.horizontalInset)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.equalTo(directorLabel.snp.bottom).offset(Metric.HeartButton.topOffset)
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct RecordDetailViewController_Preview: PreviewProvider {
    static let data = RecordReadDTO(
        id: "",
        title: "제목 테스트",
        url: "www.testulr.com",
        items: [
            .init(content: "그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.", isMain: false),
            .init(content: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다.", isMain: true),
            .init(content: "그러나 처음부터 글을 습관처럼 매일 쓸 수 있었던 건 아니다.", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false),
            .init(content: "하지만 당시에는 작가가 되고 싶다는 열망 하나를 갖고 있었고, 그 젊은 열망에 따라 어떻게", isMain: false)
        ],
        tags: ["#UXUI", "#브랜딩", "#브랜akzpzld딩", "#브랜딩", "#브랜딩"],
        attribute: .init(color: "YELLOW", style: "TEXT"),
        createdAt: "2023-09-18T11:49:52",
        createdBy: "노란 동그라미"
    )
    
    static var previews: some View {
        RecordDetailViewController(data: data).showPreview()
    }
}
#endif
