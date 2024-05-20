//
//  SetAlarmViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift
import UIKit
import UserNotifications

protocol SetAlarmPresentableListener: AnyObject {
    func setAlarmBackButtonTapped()
    func setAlarmDirectlySettingButtonTapped()
}

final class SetAlarmViewController: UIViewController, SetAlarmPresentable, SetAlarmViewControllable {

    weak var listener: SetAlarmPresentableListener?
    private var disposeBag = DisposeBag()
    
    enum Metric {
        
        static let horizontalInset: CGFloat = 20
        static let sectionTitleTopInset: CGFloat = 12
        static let rowStackTopInset: CGFloat = 24
        static let rowStackSpacing: CGFloat = 16
        static let buttonHeight: CGFloat = 44
        static let buttonCornerRadius: CGFloat = 8
        
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
        label.setParticleFont(.p_title01, color: .particleColor.white, text: "알림 설정")
        return label
    }()
    
    private let rowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Metric.rowStackSpacing
        return stack
    }()
    
    private let row1: AlarmToggleRow = {
        let title = "출근할 때 한 번 더 보기"
        
        let row = AlarmToggleRow(
            title: title,
            description: "8시에 알림을 드릴게요"
        ) { state in
            
            UserDefaults.standard.set(state, forKey: title)
        }
        return row
    }()
    
    private let row2: AlarmToggleRow = {
        let title = "점심시간에 한 번 더 보기"
        
        let row = AlarmToggleRow(
            title: title,
            description: "12시에 알림을 드릴게요"
        ) { state in
            
            UserDefaults.standard.set(state, forKey: title)
        }
        return row
    }()
    
    private let row3: AlarmToggleRow = {
        let title = "퇴근할 때 한 번 더 보기"
        
        let row = AlarmToggleRow(
            title: title,
            description: "7시에 알림을 드릴게요"
        ) { state in
            
            UserDefaults.standard.set(state, forKey: title)
        }
        return row
    }()
    
    private let row4: AlarmToggleRow = {
        let title = "자기전에 한 번 더 보기"
        
        let row = AlarmToggleRow(
            title: title,
            description: "10시에 알림을 드릴게요"
        ) { state in
            
            UserDefaults.standard.set(state, forKey: title)
        }
        return row
    }()
    
    private let directlySettingButton: UIView = {
        let view = UIView()
        view.layer.cornerRadius = Metric.buttonCornerRadius
        view.backgroundColor = .init(hex: 0xFFFFFF).withAlphaComponent(0.02)
        
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 16)
        label.textColor = .particleColor.gray04
        label.text = "직접 설정하기"
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalTo(view)
        }
        
        return view
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
        configureButton()
    }

    // MARK: - Methods
    
    private func configureButton() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(directlySettingButtonTapped)
        )
        directlySettingButton.addGestureRecognizer(tapGesture)
        
        backButton.rx.tap.bind { [weak self]_ in
            self?.listener?.setAlarmBackButtonTapped()
        }
        .disposed(by: disposeBag)
    }
    
    @objc private func directlySettingButtonTapped() {
        Console.debug("직접설정하기 탭ㅃ!")
        listener?.setAlarmDirectlySettingButtonTapped()
    }
}

// MARK: - Layout Settting

private extension SetAlarmViewController {
    
    func addSubviews() {
        [backButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [
            navigationBar,
            sectionTitle,
            rowStack,
            directlySettingButton
        ]
            .forEach {
                view.addSubview($0)
            }
        [row1, row2, row3, row4].forEach {
            rowStack.addArrangedSubview($0)
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
            $0.leading.equalToSuperview().inset(Metric.horizontalInset)
            $0.top.equalTo(navigationBar.snp.bottom).offset(Metric.sectionTitleTopInset)
        }
        
        rowStack.snp.makeConstraints {
            $0.top.equalTo(sectionTitle.snp.bottom).offset(Metric.rowStackTopInset)
            $0.leading.trailing.equalToSuperview().inset(Metric.horizontalInset)
        }
        
        directlySettingButton.snp.makeConstraints {
            $0.top.equalTo(rowStack.snp.bottom).offset(Metric.rowStackSpacing)
            $0.leading.trailing.equalToSuperview().inset(Metric.horizontalInset)
            $0.height.equalTo(Metric.buttonHeight)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SetAlarmViewController_Preview: PreviewProvider {
    static var previews: some View {
        SetAlarmViewController().showPreview()
    }
}
#endif
