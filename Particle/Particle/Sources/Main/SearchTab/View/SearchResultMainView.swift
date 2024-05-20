//
//  SearchResultMainView.swift
//  Particle
//
//  Created by 홍석현 on 2023/11/05.
//

import UIKit
import SnapKit

final class SearchResultMainView: UIView {
    let searchResultTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchResultListCell.self)
        return tableView
    }()
    
    let emptyView: SearchResultEmptyView = {
        let view = SearchResultEmptyView()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    private func layout() {
        [
            searchResultTableView,
            emptyView
        ]
            .forEach {
                addSubview($0)
            }
        
        searchResultTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.layoutMarginsGuide)
        }
        
        emptyView.snp.makeConstraints { make in
            make.edges.equalTo(self.layoutMarginsGuide)
        }
    }
}
