//
//  SearchResultListCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/10/29.
//

import UIKit
import SnapKit

class SearchResultListCell: UITableViewCell {
    
    private enum Metric {
        static let verticalSpacing = 16.0
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .y_title02,
            color: .particleColor.gray05
        )
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()

    let tagCollectionList: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = Metric.Tags.minimumLineSpacing
        layout.minimumInteritemSpacing = Metric.Tags.minimumInterItemSpacing
        
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(LeftAlignedCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        
        return collectionView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12 
        return stackView
    }()
    
    private let baseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Metric.verticalSpacing
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(title: String, subTitles: [String], tags: [String]) {
        titleLabel.text = title
        let labels = subTitles.map(makeLabel)
        labels.forEach {
            labelStackView.addArrangedSubview($0)
        }
        
        layoutSubviews()
    }
}

extension SearchResultListCell {
    // MARK: - Layout
    private func layout() {
        let allViews = [titleLabel, labelStackView, tagCollectionList]
        
        allViews
            .forEach {
                baseStackView.addArrangedSubview($0)
                $0.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                }
            }
        
        self.addSubview(baseStackView)
        baseStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.setParticleFont(
            .p_body02,
            color: .particleColor.gray05,
            text: text
        )
        label.textAlignment = .left
        return label
    }
}
