//
//  EditSentenceViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import UIKit

protocol EditSentencePresentableListener: AnyObject {
    func saveButtonTapped(with text: String)
    func editSentenceViewDidDisappear()
}

final class EditSentenceViewController: UIViewController,
                                        EditSentencePresentable,
                                        EditSentenceViewControllable {
    
    weak var listener: EditSentencePresentableListener?
    private let disposeBag = DisposeBag()
    private let customTransitioningDelegate = EditSentenceTransitioningDelegate()
    private var originalCenterY: CGFloat = 0.0
    private let originalText: String
    
    private enum Metric {
        static let titleLabelTopInset: CGFloat = 15
        static let dividerHeight: CGFloat = 1
        static let dividerTopInset: CGFloat = 13
        static let mainStackViewTopInset: CGFloat = 19
    }
    
    // MARK: - UIComponents
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "선택한 문장"
        label.textColor = .particleColor.gray05
        return label
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 37, right: 20)
        return stackView
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray01
        return view
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return stackView
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.text = "선택된 문장이 없습니다."
        textView.textColor = .particleColor.gray05
        textView.font = .systemFont(ofSize: 14)
        textView.backgroundColor = .particleColor.black
        return textView
    }()
    
    private let refreshButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.refreshButton, for: .normal)
        button.backgroundColor = .particleColor.gray01
        button.snp.makeConstraints {
            $0.width.height.equalTo(44)
        }
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("저장", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .particleColor.main100
        button.layer.cornerRadius = 8
        return button
    }()
    
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
    
    init(with text: String) {
        self.originalText = text
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
        textView.text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardNotification()
        setupInitialView()
        configureButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalCenterY = self.view.center.y
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.editSentenceViewDidDisappear()
    }
    
    // MARK: - Methods
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = customTransitioningDelegate
    }
    
    private func setupInitialView() {
        view.backgroundColor = .init(hex: 0x1F1F1F)
        view.addRoundedCorner(corners: [.topLeft, .topRight], radius: 24)
        addSubviews()
        setConstraints()
    }
    
    private func configureButton() {
        refreshButton.rx.tap
            .bind { [weak self] in
                self?.textView.text = self?.originalText
            }
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.listener?.saveButtonTapped(with: self.textView.text)
            }
            .disposed(by: disposeBag)
        
        keyboardDownButton.rx.tap
            .bind { [weak self] in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupKeyboardNotification() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillAppear(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillDisappear(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillAppear(_ sender: Notification) {
        guard let userInfo = sender.userInfo,
              let keyboarFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.center.y = self.originalCenterY - keyboarFrame.size.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillDisappear(_ sender: Notification) {
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            self.view.center.y = self.originalCenterY
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - Layout Settting

private extension EditSentenceViewController {
    
    func addSubviews() {
        [titleLabel, divider, mainStackView].forEach {
            view.addSubview($0)
        }
        
        [refreshButton, saveButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        [textView, buttonStackView].forEach {
            mainStackView.addArrangedSubview($0)
        }
        
        accessoryView.addSubview(keyboardDownButton)
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(Metric.titleLabelTopInset)
        }
        
        divider.snp.makeConstraints {
            $0.height.equalTo(Metric.dividerHeight)
            $0.width.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(Metric.dividerTopInset)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(Metric.mainStackViewTopInset)
            $0.bottom.leading.trailing.equalTo(view)
        }
        
        keyboardDownButton.snp.makeConstraints {
            $0.centerY.equalTo(accessoryView.snp.centerY)
            $0.trailing.equalTo(accessoryView).offset(-10)
        }
        
        textView.inputAccessoryView = accessoryView
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct EditSentenceViewController_Preview: PreviewProvider {
    static var previews: some View {
        EditSentenceViewController(
            with: "테스트 문구"
        )
        .showPreview()
    }
}
#endif

