//
//  ParticleAlertTransitioningDelegate.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/17.
//

import UIKit

final class ParticleAlertTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return ParticleAlertPresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
