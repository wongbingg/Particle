//
//  SceneDelegate.swift
//  Particle
//
//  Created by 이원빈 on 2023/06/19.
//

import RIBs
import RxSwift
import KakaoSDKAuth
import FirebaseDynamicLinks

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var launchRouter: LaunchRouting?
    var window: UIWindow?
    weak var systemEventHandler: SystemEventHandler?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.overrideUserInterfaceStyle = .dark
        self.window = window
        
        let statusBarManager = window.windowScene?.statusBarManager
        
        let statusBarView = UIView(frame: statusBarManager?.statusBarFrame ?? .zero)
        statusBarView.backgroundColor = .particleColor.black
        window.addSubview(statusBarView)
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        self.scene(scene, openURLContexts: connectionOptions.urlContexts)
    }
    
    // 딥링크 받아지는 곳
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            } else if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
                DynamicLinkParser.shared.handleDynamicLink(dynamicLink)
            }
        }
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // fore진입 1
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // fore진입 2
        systemEventHandler?.sceneDidBecomeActive()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // back진입 1
        systemEventHandler?.sceneWillResignActive()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // back진입 2
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        
    }
}
