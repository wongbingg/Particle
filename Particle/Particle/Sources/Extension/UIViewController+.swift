//
//  UIViewController+.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/11.
//

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
extension UIViewController {
    
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> some UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType,
                                    context: Context) { }
        
    }
    
    func showPreview(_ deviceType: DeviceType = .iPhone12ProMax) -> some View {
        Preview(viewController: self)
            .previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}

extension UIView {
    
    private struct Preview<Content: UIView>: UIViewRepresentable {
        typealias UIViewType = Content
        let view: Content
        
        func makeUIView(context: Context) -> Content {
            return view
        }
        
        func updateUIView(_ uiView: Content, context: Context) { }
    }
    
    func showPreview(_ deviceType: DeviceType = .iPhone12ProMax) -> some View {
        Preview(view: self)
            .previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif


enum DeviceType {
    case iPhoneSE2
    case iPhone8
    case iPhone12Pro
    case iPhone12ProMax

    func name() -> String {
        switch self {
        case .iPhoneSE2:
            return "iPhone SE"
        case .iPhone8:
            return "iPhone 8"
        case .iPhone12Pro:
            return "iPhone 12 Pro"
        case .iPhone12ProMax:
            return "iPhone 12 Pro Max"
        }
    }
}
