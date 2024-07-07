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
    
    enum Strings {
        static let alarmAt8Key = "출근할 때 한 번 더 보기"
        static let alarmAt12Key = "점심시간에 한 번 더 보기"
        static let alarmAt19Key = "퇴근할 때 한 번 더 보기"
        static let alarmAt22Key = "자기전에 한 번 더 보기"
    }
    
    enum Metric {
        
        static let horizontalInset: CGFloat = 20
        static let bottomInset: CGFloat = 10
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
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(
            top: Metric.sectionTitleTopInset,
            left: Metric.horizontalInset,
            bottom: Metric.bottomInset,
            right: Metric.horizontalInset
        )
        stackView.spacing = 20
        return stackView
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
        let title = Strings.alarmAt8Key
        
        let row = AlarmToggleRow(
            title: title,
            description: "8시에 알림을 드릴게요"
        )
        return row
    }()
    
    private let row2: AlarmToggleRow = {
        let title = Strings.alarmAt12Key
        
        let row = AlarmToggleRow(
            title: title,
            description: "12시에 알림을 드릴게요"
        )
        return row
    }()
    
    private let row3: AlarmToggleRow = {
        let title = Strings.alarmAt19Key
        
        let row = AlarmToggleRow(
            title: title,
            description: "저녁 7시에 알림을 드릴게요"
        )
        return row
    }()
    
    private let row4: AlarmToggleRow = {
        let title = Strings.alarmAt22Key
        
        let row = AlarmToggleRow(
            title: title,
            description: "저녁 10시에 알림을 드릴게요"
        )
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
    
    // MARK: - SetAlarmPresentable
    
    func updatePendingInfo(list: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.row1.toggleButton.isOn = list.contains(Strings.alarmAt8Key)
            self?.row2.toggleButton.isOn = list.contains(Strings.alarmAt12Key)
            self?.row3.toggleButton.isOn = list.contains(Strings.alarmAt19Key)
            self?.row4.toggleButton.isOn = list.contains(Strings.alarmAt22Key)
            
            self?.bind()
        }
    }
    
    // MARK: - Methods
    
    private func bind() {
        row1.toggleButton.rx.isOn
            .skip(1)
            .bind { state in
                if state {
                    LocalAlarmManager.scheduleDailyLocalNotification(
                        identifier: Strings.alarmAt8Key,
                        title: "제목",
                        body: "8출근할 때 한 번 더 보기",
                        hour: 8,
                        minute: 0)
                } else {
                    LocalAlarmManager.cancelLocalNotification(identifier: Strings.alarmAt8Key)
                }
            }
            .disposed(by: disposeBag)
        
        row2.toggleButton.rx.isOn
            .skip(1)
            .bind { state in
                if state {
                    LocalAlarmManager.scheduleDailyLocalNotification(
                        identifier: Strings.alarmAt12Key,
                        title: "제목",
                        body: "12점심시간에 한 번 더 보기",
                        hour: 12,
                        minute: 0)
                } else {
                    LocalAlarmManager.cancelLocalNotification(identifier: Strings.alarmAt12Key)
                }
            }
            .disposed(by: disposeBag)
        
        row3.toggleButton.rx.isOn
            .skip(1)
            .bind { state in
                if state {
                    LocalAlarmManager.scheduleDailyLocalNotification(
                        identifier: Strings.alarmAt19Key,
                        title: "제목",
                        body: "19퇴근할 때 한 번 더 보기",
                        hour: 19,
                        minute: 0)
                } else {
                    LocalAlarmManager.cancelLocalNotification(identifier: Strings.alarmAt19Key)
                }
            }
            .disposed(by: disposeBag)
        
        row4.toggleButton.rx.isOn
            .skip(1)
            .bind { state in
                if state {
                    LocalAlarmManager.scheduleDailyLocalNotification(
                        identifier: Strings.alarmAt22Key,
                        title: "제목",
                        body: "22자기전에 한 번 더 보기",
                        hour: 22,
                        minute: 0)
                } else {
                    LocalAlarmManager.cancelLocalNotification(identifier: Strings.alarmAt22Key)
                }
            }
            .disposed(by: disposeBag)
    }
    
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
            mainScrollView
        ]
            .forEach {
                view.addSubview($0)
            }
        
        mainScrollView.addSubview(mainStackView)
        
        [
            sectionTitle,
            rowStack,
            directlySettingButton
        ]
            .forEach {
                mainStackView.addArrangedSubview($0)
            }
        
        [
            row1,
            row2,
            row3,
            row4
        ]
            .forEach {
                rowStack.addArrangedSubview($0)
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
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        mainStackView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
            $0.width.equalTo(mainScrollView.frameLayoutGuide)
        }
        
        directlySettingButton.snp.makeConstraints {
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
