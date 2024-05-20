//
//  ParticleAlertPresentationController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/17.
//

import SnapKit
import UIKit

final class ParticleAlertPresentationController: UIPresentationController {
    
    enum Metric {
        static let sheetHeight: CGFloat = DeviceSize.height/3
    }
    
    private let dimmingView: UIView = {
        let dimmingView = UIView()
        dimmingView.backgroundColor = .particleColor.black.withAlphaComponent(0.9)
        return dimmingView
    }()
    
//    override var frameOfPresentedViewInContainerView: CGRect {
//
//        let width = DeviceSize.width - 52 - 52
//        let height = DeviceSize.height
//
//        let origin = CGPoint(x: DeviceSize.width/2 - width/2, y: 0)
//
//        let size = CGSize(width: width, height: height)
//
//        return CGRect(origin: origin, size: size)
//    }
    
    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)

        presentedView?.autoresizingMask = [
            .flexibleTopMargin,
            .flexibleBottomMargin,
            .flexibleLeftMargin,
            .flexibleRightMargin
        ]

        presentedView?.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let superview = presentingViewController.view else { return }
        superview.addSubview(dimmingView)
        setupDimmingViewLayout(in: superview)
        dimmingView.alpha = 0
        
        presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
            self.dimmingView.alpha = 0.5
        })
        
//        presentedView?.translatesAutoresizingMaskIntoConstraints = false
//        presentedView?.snp.makeConstraints {
//            $0.center.equalTo(superview)
//            $0.leading.trailing.equalTo(superview).inset(52)
//        }
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
    }
    
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
            self.dimmingView.alpha = 0
        }, completion: { _ in
            self.dimmingView.removeFromSuperview()
        })
    }
    
    private func setupDimmingViewLayout(in view: UIView) {
        
        dimmingView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
