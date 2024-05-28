//
//  AppDelegate.swift
//  Particle
//
//  Created by 이원빈 on 2023/06/19.
//

import UIKit
import Photos
import KakaoSDKCommon
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        setupKakaoSDK()
        setupSwipeGuide()
        setupFirebase(to: application)

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration",
                                    sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }
    
    // MARK: - Methods
    
    private func setupKakaoSDK() {
        KakaoSDK.initSDK(appKey: "082e213b8e9609caba039a0e66b54690")
    }
    
    private func setupSwipeGuide() {
        UserDefaults.standard.set(false, forKey: "ShowSwipeGuide")
    }
    
    private func setupFirebase(to application: UIApplication) {
        FirebaseApp.configure()
        
        // MARK: - FCM 등록
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { bool, error in
            if let error = error {
                Console.error(error.localizedDescription)
            }
            Console.debug("Authorization result == \(bool)")
        }
        
        application.registerForRemoteNotifications()
    }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        Console.log("파이어베이스 토큰: \(fcmToken ?? "nil")")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
            
        completionHandler([.list, .banner, .badge, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        
        completionHandler()
    }
}
