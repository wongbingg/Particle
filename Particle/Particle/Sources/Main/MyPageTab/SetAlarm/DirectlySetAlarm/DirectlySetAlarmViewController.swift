//
//  DirectlySetAlarmViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift
import UIKit

protocol DirectlySetAlarmPresentableListener: AnyObject {
    func directlySetAlarmCloseButtonTapped()
}

final class DirectlySetAlarmViewController: UIViewController,
                                            DirectlySetAlarmPresentable,
                                            DirectlySetAlarmViewControllable {

    weak var listener: DirectlySetAlarmPresentableListener?
    private var disposeBag = DisposeBag()
    
    enum Strings {
        static let alarmKey = "직접알림"
        
        static let alarmTitleMessage = "Particle"
        static let alarmMessage = "기록하지 않는 건 기억되지 않아요. 캡처해둔 중요한 글이 있다면 Particle에서 정리해보아요 ☺️"
    }
    
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
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .particleColor.white, text: "알림설정")
        return label
    }()
    
    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .time
        view.preferredDatePickerStyle = .wheels
        view.locale = Locale(identifier: "ko")
        view.textColor = .particleColor.white
        return view
    }()
    
    private let alarmNameSectionTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body02, color: .particleColor.gray03, text: "알림 이름")
        return label
    }()
    
    private let alarmNameTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 8
        textField.backgroundColor = .particleColor.gray01
        textField.addLeftPadding(16)
        textField.attributedPlaceholder = NSMutableAttributedString()
            .attributeString(
                string: "알림 이름 입력",
                font: .particleFont.generate(style: .pretendard_Regular, size: 16),
                textColor: .particleColor.gray03
            )
        textField.font = .particleFont.generate(style: .pretendard_Regular, size: 16)
        textField.textColor = .particleColor.white
        return textField
    }()
    
    private let alarmActivateSectionTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body02, color: .particleColor.gray03, text: "알림 활성화")
        return label
    }()
    
    private let alarmActivateButton = RadioButton(title: "활성화")

    private let registeredAlarmTimeLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var datePickerTime: (hour: Int, minute: Int) {
        fetchDatePickerTime()
    }
    
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
        setInitialData()
    }
    
    // MARK: - DirectlySetAlarmPresentable
    func updatePendingInfo(list: [String]) {
        DispatchQueue.main.async { [weak self] in
            self?.alarmActivateButton.state.accept(list.contains(Strings.alarmKey))
            self?.registeredAlarmTimeLabel.isHidden = !list.contains(Strings.alarmKey)
            self?.bind()
        }
    }
    
    // MARK: - Methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }
    
    func showRegisterSuccessAlert() {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: "\(datePickerTime.hour)시 \(datePickerTime.minute)분 알람 적용이 완료되었어요!",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        present(alert, animated: true) { [weak self] in
            guard let self = self else { return }
            registeredAlarmTimeLabel.isHidden = false
            registeredAlarmTimeLabel.setParticleFont(
                .p_body01_bold,
                color: .white,
                text: "\(datePickerTime.hour) : \(datePickerTime.minute)")
        }
    }
    
    func showUnregisterSuccessAlert() {
        let okButton = generateAlertButton(title: "확인") { [weak self] in
            self?.dismiss(animated: true)
        }
        
        let alert = ParticleAlertController(
            title: nil,
            body: "알람 적용이 정상적으로 해제되었어요!",
            buttons: [okButton],
            buttonsAxis: .horizontal
        )
        
        present(alert, animated: true) { [weak self] in
            guard let self = self else { return }
            registeredAlarmTimeLabel.isHidden = true
        }
    }
    
    private func setInitialData() {
        let registeredAlarmTime = UserDefaults.standard.string(forKey: Strings.alarmKey)
        registeredAlarmTimeLabel.setParticleFont(
            .p_body01_bold,
            color: .white,
            text: registeredAlarmTime)
    }
    
    private func configureButton() {
        closeButton.rx.tap.bind { [weak self] _ in
            self?.listener?.directlySetAlarmCloseButtonTapped()
        }
        .disposed(by: disposeBag)
    }
    
    private func bind() {
        alarmActivateButton.state
            .skip(1)
            .bind { [weak self] isTapped in
                guard let self = self else { return }
                if isTapped {
                    let hhmm: (Int, Int) = fetchDatePickerTime()
                    UserDefaults.standard.setValue("\(hhmm.0):\(hhmm.1)", forKey: Strings.alarmKey)
                    LocalAlarmManager.scheduleDailyLocalNotification(
                        identifier: Strings.alarmKey,
                        title: Strings.alarmTitleMessage,
                        body: Strings.alarmMessage,
                        hour: hhmm.0,
                        minute: hhmm.1)
                    showRegisterSuccessAlert()
                } else {
                    UserDefaults.standard.removeObject(forKey: Strings.alarmKey)
                    LocalAlarmManager.cancelLocalNotification(identifier: Strings.alarmKey)
                    showUnregisterSuccessAlert()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func fetchDatePickerTime() -> (Int, Int) {
        // 선택한 날짜와 시간 가져오기
        let selectedDate = datePicker.date

        // Calendar를 사용하여 시와 분 추출
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: selectedDate)
        if let hour = components.hour, let minute = components.minute {
            print("선택한 시간: \(hour)시 \(minute)분")
            return (hour, minute)
        }
        return (0, 0)
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

private extension DirectlySetAlarmViewController {
    func addSubviews() {
        [closeButton, navigationTitle].forEach {
            navigationBar.addSubview($0)
        }
        
        [
            navigationBar,
            datePicker,
            alarmActivateSectionTitle,
            alarmActivateButton,
            registeredAlarmTimeLabel
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
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        datePicker.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }
        alarmActivateSectionTitle.snp.makeConstraints {
            $0.top.equalTo(datePicker.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        alarmActivateButton.snp.makeConstraints {
            $0.top.equalTo(alarmActivateSectionTitle.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(20)
            $0.width.equalTo((DeviceSize.width-48)/2)
            $0.height.equalTo(44)
        }
        registeredAlarmTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(alarmActivateButton)
            $0.leading.equalTo(alarmActivateButton.snp.trailing).offset(20)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct DirectlySetAlarmViewController_Preview: PreviewProvider {
    static var previews: some View {
        DirectlySetAlarmViewController().showPreview()
    }
}
#endif
extension UIDatePicker {
    
    var textColor: UIColor? {
        set {
            setValue(newValue, forKeyPath: "textColor")
        }
        get {
            return value(forKeyPath: "textColor") as? UIColor
        }
    }
}
