//
//  SearchListCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/10/02.
//

import UIKit

protocol SearchListCellListener: AnyObject {
    func deleteButtonTapped(_ text: String?)
}

final class SearchListCell: UITableViewCell {
    weak var listener: SearchListCellListener?
    
    private enum Metric {
        static let verticalMargin = 12
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_body02, color: .particleColor.gray05)
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout()
        
        
        removeButton.addAction(UIAction(handler: { [weak self] _ in
            self?.listener?.deleteButtonTapped(self?.titleLabel.text)
        }), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func bind(_ model: String) {
        titleLabel.text = model
    }
    
    // MARK: - Layout
    private func layout() {
        [titleLabel, removeButton]
            .forEach {
                contentView.addSubview($0)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(Metric.verticalMargin)
            make.left.equalToSuperview()
        }
        
        removeButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview()
        }
    }
}

