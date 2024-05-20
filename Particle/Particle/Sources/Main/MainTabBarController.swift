//
//  MainTabBarController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/10.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa
import SnapKit

protocol MainPresentableListener: AnyObject {

}

final class MainTabBarController: UITabBarController, MainPresentable, MainViewControllable {
    
    private enum Metric {
        static let tabBarHeight: CGFloat = 90
    }
    
    weak var listener: MainPresentableListener?
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = Metric.tabBarHeight
        tabFrame.origin.y = self.view.frame.size.height - Metric.tabBarHeight
        self.tabBar.frame = tabFrame
    }
    
    private func configureTabBar() {
        tabBar.backgroundColor = .particleColor.bk03
        tabBar.tintColor = .particleColor.main100
        
        if #available(iOS 13.0, *) {
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .particleColor.bk03
            UITabBar.appearance().standardAppearance = tabBarAppearance

            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            }
        }
    }
    
    // MARK: - MainViewControllable
    
    func present(viewController: RIBs.ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismiss(viewController: RIBs.ViewControllable) { /// RibsUtil에 이미 구현되어있는 것과 비교후 제거
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
      super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
    // MARK: - MainPresentable
    
    func alert(title: String, body: String) {
        let alert = UIAlertController(title: title, message: body, preferredStyle: .alert)
        let button = UIAlertAction(title: "확인", style: .default)
        alert.addAction(button)
        present(alert, animated: true)
    }
}
