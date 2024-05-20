//
//  SetAdditionalInformationViewController.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import RxCocoa

protocol SetAdditionalInformationPresentableListener: AnyObject {
    func setAdditionalInfoBackButtonTapped()
    func setAdditionalInfoNextButtonTapped(title: String, url: String, tags: [String], style: String)
}

final class SetAdditionalInformationViewController: UIViewController,
                                                    SetAdditionalInformationPresentable,
                                                    SetAdditionalInformationViewControllable {
    
    weak var listener: SetAdditionalInformationPresentableListener?
    private var disposeBag = DisposeBag()
    private var tags: BehaviorRelay<[(title: String, isSelected: Bool)]> = .init(value: [])
    
    enum Constant {
        static let titleTextViewPlaceHolder = "제목을 입력해 주세요"
    }
    
    enum Metric {
        enum Title {
            static let topMargin = 12
            static let leftMargin = 20
        }
        
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 8
            static let nextButtonRightMargin = 8
        }
        
        enum URLTextField {
            static let topMargin = 32
            static let horizontalMargin = 20
            static let underLineTopMargin = 5
        }
        
        enum TitleTextField {
            static let topMargin: CGFloat = 80
            static let horizontalMargin: CGFloat = 20
            static let underLineTopMargin = 5
        }
        
        enum RecommendTagTitle {
            static let topMargin: CGFloat = 54
            static let leftMargin: CGFloat = 20
        }
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
        }
    }
    
    // MARK: - UI Components
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.text = "아티클의 링크와 제목을 입력하고\n태그로 정리해보세요"
        label.font = .particleFont.generate(style: .ydeStreetB, size: 19)
        label.numberOfLines = 0
        label.textColor = .particleColor.gray04
        return label
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
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.particleColor.gray03, for: .disabled)
        button.setTitleColor(.particleColor.main100, for: .normal)
        button.snp.makeConstraints {
            $0.width.equalTo(52)
            $0.height.equalTo(44)
        }
        return button
    }()
    
    private let urlTextFieldSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "url"
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let urlTextField: UITextField = {
        let textField = UITextField()
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "아티클의 url을 입력해 주세요",
                font: .particleFont.generate(style: .pretendard_Medium, size: 16),
                textColor: .particleColor.gray03
            )
        textField.font = .systemFont(ofSize: 14)
        textField.addLeftPadding(16)
        textField.textColor = .white
        textField.backgroundColor = .particleColor.gray01
        textField.layer.cornerRadius = 8
        textField.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(DeviceSize.width - 40)
        }
        return textField
    }()
    
    private let urlTextFieldClearButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        return button
    }()
    
    private let urlTextFieldWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "url을 입력해 주세요."
        label.textColor = .particleColor.warning
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 12)
        label.snp.makeConstraints {
            $0.height.equalTo(14.4)
        }
        return label
    }()
    
    private let titleTextFieldSectionTitle: UILabel = {
        let label = UILabel()
        label.text = "제목"
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14)
        textView.textColor = .particleColor.gray03
        textView.text = Constant.titleTextViewPlaceHolder
        textView.textContainerInset = .init(top: 12, left: 14, bottom: 10, right: 40)
        textView.isScrollEnabled = false
        textView.backgroundColor = .particleColor.gray01
        textView.layer.cornerRadius = 8
        textView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(44)
        }
        return textView
    }()
    
    private let titleTextFieldClearButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(32)
        }
        
        return button
    }()
    
    private let titleTextFieldWarningLabel: UILabel = {
        let label = UILabel()
        label.text = "제목을 입력해 주세요."
        label.textColor = .particleColor.warning
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 12)
        label.snp.makeConstraints {
            $0.height.equalTo(14.4)
        }
        return label
    }()
    
    private let recommendTagTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "추천 태그"
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let recommendTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = Metric.Tags.minimumLineSpacing
        layout.minimumInteritemSpacing = Metric.Tags.minimumInterItemSpacing
        
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(LeftAlignedCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let sentenceStyleTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "문장 스타일"
        label.textColor = .particleColor.gray03
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.snp.makeConstraints {
            $0.height.equalTo(21)
        }
        return label
    }()
    
    private let cardStyleRadioButton = RadioButton(title: "카드")
    private let textStyleRadioButton = RadioButton(title: "텍스트")
    
    // TODO: 컴포넌트화 예정
    private let accessoryView: UIView = {
        let uiview = UIView(
            frame: CGRect(
                x: 0.0,
                y: 0.0,
                width: UIScreen.main.bounds.width,
                height: 50
            )
        )
        uiview.layer.backgroundColor = UIColor.darkGray.cgColor
        return uiview
    }()
    
    private let keyboardDownButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(.particleImage.keyboardDownButton, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.modalPresentationStyle = .fullScreen
        self.view.backgroundColor = .particleColor.black
        addSubviews()
        layout()
        configureButton()
        setInitialState()
        bind()
        
        fetchInterestedTags()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextFieldWarningLabel.isHidden = true
        titleTextFieldWarningLabel.isHidden = true
        titleTextFieldClearButton.isHidden = true
    }
    
    // MARK: - Methods
    
    private func setInitialState() {
        cardStyleRadioButton.state.accept(true)
    }
    
    private func configureButton() {
        
        urlTextField.rightView = urlTextFieldClearButton
        urlTextField.rightViewMode = .whileEditing
        urlTextFieldClearButton.rx.tap.bind { [weak self] _ in
            self?.urlTextField.text = ""
            self?.urlTextField.rightViewMode = .never
        }
        .disposed(by: disposeBag)
        
        titleTextFieldClearButton.rx.tap.bind { [weak self] _ in
            self?.titleTextView.text = nil
            self?.titleTextFieldClearButton.isHidden = true
        }
        .disposed(by: disposeBag)
        
        keyboardDownButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchInterestedTags() {
        guard let userInterestedTags = UserDefaults.standard.object(forKey: "INTERESTED_TAGS") as? [String] else { return }
        let fetchedTags = userInterestedTags.map { ($0, false) }
        tags.accept(fetchedTags)
    }
    
    private func bind() {
        
        tags
            .bind(to: recommendTagCollectionView.rx.items(
                cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
                cellType: LeftAlignedCollectionViewCell.self)
            ) { index, item, cell in
                cell.titleLabel.text = item.title
                
                if item.isSelected {
                    cell.setSelected(true)
                } else {
                    cell.setSelected(false)
                }
            }
            .disposed(by: disposeBag)
        
        recommendTagCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let index = indexPath.element else { return }

            var oldValue = tags.value
            oldValue[index.row].isSelected.toggle()
            tags.accept(oldValue)
        }
        .disposed(by: disposeBag)
        
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.setAdditionalInfoBackButtonTapped()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                let isEmpty = self?.urlTextField.text?.isEmpty ?? true || self?.titleTextView.text?.isEmpty ?? true || self?.titleTextView.text == Constant.titleTextViewPlaceHolder
                if isEmpty {
                    if self?.urlTextField.text?.isEmpty ?? true {
                        self?.urlTextField.layer.borderWidth = 1
                        self?.urlTextField.layer.borderColor = .particleColor.warning.cgColor
                        self?.urlTextFieldWarningLabel.isHidden = false
                    }
                    
                    if self?.titleTextView.text?.isEmpty ?? true || self?.titleTextView.text == Constant.titleTextViewPlaceHolder {
                        self?.titleTextView.layer.borderWidth = 1
                        self?.titleTextView.layer.borderColor = .particleColor.warning.cgColor
                        self?.titleTextFieldWarningLabel.isHidden = false
                    }
                } else {
                    let selectedTags = self?.tags.value.filter { $0.isSelected == true }.map { Tag(rawValue: $0.title)?.value ?? "UXUI" } ?? []
                    
                    self?.listener?.setAdditionalInfoNextButtonTapped(
                        title: self?.titleTextView.text ?? "",
                        url: self?.urlTextField.text ?? "",
                        tags: selectedTags,
                        style: (self?.cardStyleRadioButton.state.value ?? true) ? "CARD" : "TEXT"
                    )
                }
            }
            .disposed(by: disposeBag)
        
        urlTextField.rx.text.subscribe { [weak self] inputText in
            if inputText.element != nil {
                self?.urlTextField.layer.borderWidth = 0
                self?.urlTextFieldWarningLabel.isHidden = true
            }
            self?.urlTextField.rightViewMode = .whileEditing
        }
        .disposed(by: disposeBag)
        
        titleTextView.rx.text.subscribe { [weak self] inputText in
            if inputText.element != nil,
               self?.titleTextView.text != Constant.titleTextViewPlaceHolder,
               self?.titleTextView.text != nil {
                self?.titleTextView.layer.borderWidth = 0
                self?.titleTextFieldWarningLabel.isHidden = true
                self?.titleTextFieldClearButton.isHidden = false
            }
        }
        .disposed(by: disposeBag)
        
        titleTextView.rx.didBeginEditing.bind { [weak self] _ in
            if self?.titleTextView.text == Constant.titleTextViewPlaceHolder {
                self?.titleTextView.text = nil
                self?.titleTextView.textColor = .white
            } else {
                self?.titleTextFieldClearButton.isHidden = false
            }
        }
        .disposed(by: disposeBag)
        
        titleTextView.rx.didEndEditing.bind { [weak self] _ in
            guard let self = self else { return }
            if self.titleTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.titleTextView.text = Constant.titleTextViewPlaceHolder
                self.titleTextView.textColor = .particleColor.gray03
            }
            self.titleTextFieldClearButton.isHidden = true
        }
        .disposed(by: disposeBag)
        
        cardStyleRadioButton.state.bind { [weak self] isTapped in
            guard isTapped else { return }
            self?.textStyleRadioButton.state.accept(false)
            
        }
        .disposed(by: disposeBag)
        
        textStyleRadioButton.state.bind { [weak self] isTapped in
            guard isTapped else { return }
            self?.cardStyleRadioButton.state.accept(false)
        }
        .disposed(by: disposeBag)
    }
    
    // MARK: - SetAdditionalInformationPresentable
    
    func setData(data: RecordReadDTO) {
        urlTextField.text = data.url
        titleTextView.text = data.title
        titleTextView.textColor = .white
        
        var indexList = [Int]()
        
        for tag1 in data.tags {
            let id = "#" + tag1
            for (i, tag2) in tags.value.enumerated() {
                if tag2.title == id {
                    indexList.append(i)
                    break
                }
            }
        }
        var oldValue = tags.value
        indexList.forEach { index in
            oldValue[index].isSelected = true
        }
        tags.accept(oldValue)
        
        if data.attribute.style == "TEXT" {
            textStyleRadioButton.state.accept(true)
        } else {
            cardStyleRadioButton.state.accept(true)
        }
    }
}

// MARK: - Layout Setting

private extension SetAdditionalInformationViewController {
    
    func addSubviews() {
        [backButton, nextButton]
            .forEach {
                navigationBar.addSubview($0)
            }
        
        [navigationBar, mainScrollView]
            .forEach {
                view.addSubview($0)
            }
        
        [
            titleLabel,
            urlTextFieldSectionTitle,
            urlTextField,
            urlTextFieldWarningLabel,
            titleTextFieldSectionTitle,
            titleTextView,
            titleTextFieldClearButton,
            titleTextFieldWarningLabel,
            recommendTagTitleLabel,
            recommendTagCollectionView,
            sentenceStyleTitleLabel,
            cardStyleRadioButton,
            textStyleRadioButton
        ]
            .forEach {
                mainScrollView.addSubview($0)
            }
        
        accessoryView.addSubview(keyboardDownButton)
    }
    
    func layout() {
        navigationBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        nextButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(DeviceSize.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.Title.topMargin)
            make.left.equalToSuperview().inset(Metric.Title.leftMargin)
        }
        
        urlTextFieldSectionTitle.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(20)
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(urlTextFieldSectionTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(Metric.URLTextField.horizontalMargin)
        }
        
        urlTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        titleTextFieldSectionTitle.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(40)
            $0.leading.equalToSuperview().offset(20)
        }
        
        titleTextView.snp.makeConstraints { make in
            make.top.equalTo(titleTextFieldSectionTitle.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(Metric.URLTextField.horizontalMargin)
        }
        
        titleTextFieldClearButton.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.top).offset(6)
            $0.trailing.equalTo(titleTextView.snp.trailing)
        }
        
        titleTextFieldWarningLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextView.snp.bottom).offset(10)
            $0.leading.equalToSuperview().inset(20)
        }
        
        recommendTagTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextView.snp.bottom).offset(Metric.RecommendTagTitle.topMargin)
            make.left.equalToSuperview().inset(Metric.RecommendTagTitle.leftMargin)
        }
        
        recommendTagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendTagTitleLabel.snp.bottom).offset(Metric.Tags.topMagin)
            make.left.right.equalToSuperview().inset(Metric.Tags.horizontalMargin)
        }
        
        sentenceStyleTitleLabel.snp.makeConstraints {
            $0.top.equalTo(recommendTagCollectionView.snp.bottom).offset(40)
            $0.leading.equalToSuperview().inset(20)
        }
        
        cardStyleRadioButton.snp.makeConstraints {
            $0.top.equalTo(sentenceStyleTitleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((DeviceSize.width-48)/2)
            $0.height.greaterThanOrEqualTo(44)
        }
        
        textStyleRadioButton.snp.makeConstraints {
            $0.top.equalTo(sentenceStyleTitleLabel.snp.bottom).offset(12)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo((DeviceSize.width-48)/2)
            $0.height.equalTo(44)
        }
        
        keyboardDownButton.snp.makeConstraints {
            $0.centerY.equalTo(accessoryView.snp.centerY)
            $0.trailing.equalTo(accessoryView).offset(-10)
        }
        
        urlTextField.inputAccessoryView = accessoryView
        titleTextView.inputAccessoryView = accessoryView
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SetAdditionalInformationViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        SetAdditionalInformationViewController().showPreview()
    }
}
#endif
