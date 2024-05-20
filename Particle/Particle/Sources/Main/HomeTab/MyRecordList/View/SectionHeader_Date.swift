//
//  SectionDate.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/01.
//

import UIKit
import RxSwift
import SnapKit

final class SectionHeader_Date: UICollectionReusableView {
    
    private var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_Medium, size: 16)
        label.textColor = .particleColor.gray05
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.snp.makeConstraints {
            $0.width.equalTo(DeviceSize.width)
            $0.height.equalTo(1)
        }
        view.backgroundColor = .particleColor.gray01
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        disposeBag = DisposeBag()
    }
    
    private func setupInitialView() {
        self.backgroundColor = .particleColor.bk02
    }
    
    func setupData(title: String) {
        titleLabel.text = title
    }
}

// MARK: - Layout Setting

private extension SectionHeader_Date {
    
    func addSubviews() {

        [titleLabel, divider].forEach {
            addSubview($0)
        }
    }
    
    func setConstraints() {
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(8)
        }
        
        divider.snp.makeConstraints {
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SectionDate_Preview: PreviewProvider {
    
    static var sectionDate: SectionHeader_Date = {
        let sectionTitle = SectionHeader_Date()
        sectionTitle.setupData(title: "2023년 6월")
        return sectionTitle
    }()
    
    static var previews: some View {
        sectionDate.showPreview()
    }
}
#endif
