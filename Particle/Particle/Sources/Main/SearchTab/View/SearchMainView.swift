//
//  SearchMainView.swift
//  Particle
//
//  Created by 홍석현 on 2023/10/29.
//

import UIKit
import SnapKit

class SearchMainView: UIView {
    private enum Metric {
        enum SearchBar {
            static let topMargin = 24
            static let horizontalMargin = 20
            static let height = 48
        }
        
        enum SearchView {
            static let topMargin = 32
        }
    }
    
    public let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.placeholder = "검색어를 입력해 주세요."
        searchBar.searchTextField.font = .particleFont.generate(style: .pretendard_Regular, size: 16)
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = CGFloat(Metric.SearchBar.height / 2)
        return searchBar
    }()
    
    public let recentSearchView = RecentSearchView()
    public let searchResultView: SearchResultMainView = {
        let view = SearchResultMainView()
        view.isHidden = true
        return view
    }()
    public let searchResultEmptyView: SearchResultEmptyView = {
        let view = SearchResultEmptyView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Layout Setting

private extension SearchMainView {
    func addSubviews() {
        [
            searchBar,
            recentSearchView,
            searchResultView,
            searchResultEmptyView
        ]
            .forEach {
                self.addSubview($0)
            }
    }
        
    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(Metric.SearchBar.topMargin)
            make.left.right.equalToSuperview().inset(Metric.SearchBar.horizontalMargin)
            make.height.equalTo(Metric.SearchBar.height)
        }
        
        recentSearchView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Metric.SearchView.topMargin)
            make.left.right.bottom.equalToSuperview()
        }
        
        searchResultView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Metric.SearchView.topMargin)
            make.left.right.bottom.equalToSuperview()
        }
        
        searchResultEmptyView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(Metric.SearchView.topMargin)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
