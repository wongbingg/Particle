//
//  EditSentenceTransitioningDelegate.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/20.
//

import UIKit

final class EditSentenceTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return EditSentencePresentationController(
            presentedViewController: presented,
            presenting: presenting
        )
    }
}
