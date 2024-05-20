//
//  SectionFooter_Divider.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/01.
//

import UIKit
import RxSwift
import SnapKit

final class SectionFooter_Divider: UICollectionReusableView {
    
    private var disposeBag = DisposeBag()
    
    enum Metric {
        static let dividerHeight: CGFloat = 8
    }
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0x1f1f1f)
        return view
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialView()
        addSubviews()
        setConstraints()
    }
    
    init() {
        super.init(frame: .zero)
        setupInitialView()
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        self.backgroundColor = .clear
    }
}

// MARK: - Layout Setting

private extension SectionFooter_Divider {
    
    func addSubviews() {
        addSubview(divider)
    }
    
    func setConstraints() {
        
        divider.snp.makeConstraints {
            $0.width.equalTo(DeviceSize.width)
            $0.height.equalTo(Metric.dividerHeight)
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SectionFooter_Divider_Preview: PreviewProvider {
    
    static var sectionFooter_Divider: SectionFooter_Divider = {
        let sectionTitle = SectionFooter_Divider()
        return sectionTitle
    }()
    
    static var previews: some View {
        sectionFooter_Divider.showPreview()
    }
}
#endif
