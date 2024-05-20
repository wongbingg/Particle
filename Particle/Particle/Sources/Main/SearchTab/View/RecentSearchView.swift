//
//  RecentSearchView.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import UIKit

final class RecentSearchView: UIView {
    private enum Metric {
        enum ListTitle {
            static let leftMargin = 20
        }
        
        enum RemoveButton {
            static let rightMargin = 8
        }
        
        enum List {
            static let horizontalMargin = 20
            static let topMargin = 12
        }
        
        enum TagTitle {
            static let topMargin = 65
            static let leftMargin = 20
        }
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
        }
    }
    
    private let recentSearchListTitleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .y_headline,
            color: .particleColor.gray04,
            text: "최근 검색어"
        )
        return label
    }()
    
    let recentSearchListRemoveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .init(top: 10, leading: 12, bottom: 10, trailing: 12)
        configuration.attributedTitle = AttributedString("모두 지우기", attributes: AttributeContainer.init([
            .font: UIFont.particleFont.generate(style: .pretendard_Regular, size: 12) ?? UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.particleColor.gray03
        ]))
        
        button.configuration = configuration
        return button
    }()
    
    let recentSearchList: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchListCell.self)
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private let tagTitleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .y_headline,
            color: .particleColor.gray04,
            text: "관심 태그로 검색"
        )
        return label
    }()
    
    let tagCollectionView: UICollectionView = {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Add Subviews
    private func addSubviews() {
        [
            recentSearchListTitleLabel,
            recentSearchListRemoveButton,
            recentSearchList
        ]
            .forEach {
                self.addSubview($0)
            }
        
        [tagTitleLabel, tagCollectionView]
            .forEach {
                self.addSubview($0)
            }
    }
    
    // MARK: - Layout
    private func layout() {
        recentSearchListTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().inset(Metric.ListTitle.leftMargin)
        }
        
        recentSearchListRemoveButton.snp.makeConstraints { make in
            make.centerY.equalTo(recentSearchListTitleLabel)
            make.right.equalToSuperview().inset(Metric.RemoveButton.rightMargin)
        }
        
        recentSearchList.snp.makeConstraints { make in
            make.top.equalTo(recentSearchListTitleLabel.snp.bottom).offset(Metric.List.topMargin)
            make.left.right.equalToSuperview().inset(Metric.List.horizontalMargin)
            make.height.equalTo(45 * 5)
        }
        
        tagTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(recentSearchList.snp.bottom).offset(Metric.TagTitle.topMargin)
            make.left.equalToSuperview().inset(Metric.TagTitle.leftMargin)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(tagTitleLabel.snp.bottom).offset(Metric.Tags.topMagin)
            make.left.right.equalToSuperview().inset(Metric.Tags.horizontalMargin)
            make.bottom.lessThanOrEqualToSuperview().offset(14)
        }
    }
}
