//
//  EditSentencePresentationController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/20.
//

import SnapKit
import UIKit

final class EditSentencePresentationController: UIPresentationController {
    
    enum Metric {
        static let sheetHeight: CGFloat = DeviceSize.height/3
    }
    
    private let dimmingView: UIView = {
        let dimmingView = UIVisualEffectView(
            effect: UIBlurEffect(style: .systemMaterialDark)
        )
        return dimmingView
    }()
    
    override var frameOfPresentedViewInContainerView: CGRect {
        let size = CGSize(width: DeviceSize.width,
                          height: Metric.sheetHeight)
        let origin = CGPoint(x: 0, y: (DeviceSize.height - Metric.sheetHeight))
        return CGRect(origin: origin, size: size)
    }
    
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
        adoptTapGestureRecognizer()
        dimmingView.alpha = 0
        
        presentingViewController.transitionCoordinator?.animate(
            alongsideTransition: { _ in
            self.dimmingView.alpha = 0.5
        })
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

    private func adoptTapGestureRecognizer() {
        guard let adoptedView = containerView else { return }
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(backgroundTapped(_:))
        )
        adoptedView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func setupDimmingViewLayout(in view: UIView) {
        
        dimmingView.snp.makeConstraints {
            $0.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    @objc private func backgroundTapped(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: containerView)
        if location.y < (DeviceSize.height*2)/3 {
            presentedViewController.dismiss(animated: true)
        }
    }
}
