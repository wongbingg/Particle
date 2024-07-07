//
//  SetAlarmInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/07.
//

import RIBs
import RxSwift

protocol SetAlarmRouting: ViewableRouting {
    func attachDirectlySetAlarm()
    func detachDirectlySetAlarm()
}

protocol SetAlarmPresentable: Presentable {
    var listener: SetAlarmPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func updatePendingInfo(list: [String])
}

protocol SetAlarmListener: AnyObject {
    func setAlarmBackButtonTapped()
}

final class SetAlarmInteractor: PresentableInteractor<SetAlarmPresentable>, SetAlarmInteractable, SetAlarmPresentableListener {
    
    weak var router: SetAlarmRouting?
    weak var listener: SetAlarmListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: SetAlarmPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        LocalAlarmManager.fetchPendingNotifications { [weak self] in
            self?.presenter.updatePendingInfo(list: $0)
        }
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - SetAlarmPresentableListener
    
    func setAlarmBackButtonTapped() {
        listener?.setAlarmBackButtonTapped()
    }
    
    func setAlarmDirectlySettingButtonTapped() {
        router?.attachDirectlySetAlarm()
    }
    
    func directlySetAlarmCloseButtonTapped() {
        router?.detachDirectlySetAlarm()
    }
    
    
    // MARK: - Methods
    
    private func addLocalNotification(identifier: String, title: String, body: String, timeHHmm: String) {
        let notificationCenter = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        
        let date = DateManager.shared.convertTimeToDate(previousHHmm: timeHHmm)
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.hour], from: date), // FIXME: 특정 시간으로 지정
            repeats: true)
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger)
        
        notificationCenter.add(request) { error in
            if let error = error {
                Console.error(error.localizedDescription)
            }
        }
    }
    
    private func removeAllLocalNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }
}

struct LocalAlarmManager {
    // 특정 시:분에 매일 로컬 푸시 알림 등록
    static func scheduleDailyLocalNotification(identifier: String, title: String, body: String, hour: Int, minute: Int) {
        // 알림 내용 구성
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default

        // 트리거 설정 (특정 시:분에 매일 반복)
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        // 알림 요청 생성
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // 알림 센터에 요청 추가
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled with identifier: \(identifier)")
            }
        }
    }

    // 로컬 푸시 알림 취소
    static func cancelLocalNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Notification cancelled with identifier: \(identifier)")
    }
    
    // 특정 identifier가 등록되어 있는지 확인
    static func isNotificationScheduled(identifier: String, completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let isScheduled = requests.contains { $0.identifier == identifier }
            completion(isScheduled)
        }
    }
    
    static func fetchPendingNotifications(_ completion: @escaping ([String]) -> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion(requests.map { $0.identifier })
        }
    }
}
