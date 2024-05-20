//
//  SentenceTableViewCell.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/11.
//

import UIKit
import SnapKit

final class SentenceTableViewCell: UITableViewCell {
    
    private enum Metric {
        static let bottomMargin: CGFloat = 10
        static let labelVerticalInset: CGFloat = 16
        static let labelHorizontalInset: CGFloat = 14
        static let labelCornerRadius: CGFloat = 12
        
        enum SelectFlag {
            static let verticalInset: CGFloat = 6
            static let horizontalInset: CGFloat = 16
        }
    }
    
    private let sentenceLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.topInset = Metric.labelVerticalInset
        label.bottomInset = Metric.labelVerticalInset
        label.leftInset = Metric.labelHorizontalInset
        label.rightInset = Metric.labelHorizontalInset
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .white
        label.backgroundColor = .init(hex: 0xFFFFFF, alpha: 0.1)
        label.layer.cornerRadius = Metric.labelCornerRadius
        label.clipsToBounds = true
        return label
    }()
    
    private let selectFlag: PaddingLabel = {
        let label = PaddingLabel()
        label.topInset = Metric.SelectFlag.verticalInset
        label.bottomInset = Metric.SelectFlag.verticalInset
        label.leftInset = Metric.SelectFlag.horizontalInset
        label.rightInset = Metric.SelectFlag.horizontalInset
        label.font = .particleFont.generate(style: .pretendard_SemiBold, size: 11)
        label.textColor = .particleColor.main30
        label.backgroundColor = .particleColor.main100
        label.layer.cornerRadius = 12
        label.clipsToBounds = true
        label.text = "대표 문장"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        self.contentView.addSubview(sentenceLabel)
        sentenceLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(Metric.bottomMargin)
        }
        self.contentView.addSubview(selectFlag)
        selectFlag.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(12)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        self.contentView.layer.borderWidth = 0
        self.sentenceLabel.layer.borderColor = UIColor.clear.cgColor
        self.selectFlag.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sentenceLabel.preferredMaxLayoutWidth = sentenceLabel.frame.width
    }
    
    func setCellData(_ data: OrganizingSentenceViewModel) {
        sentenceLabel.text = data.sentence
        
        if data.isRepresent {
            self.sentenceLabel.layer.borderWidth = 1
            self.sentenceLabel.layer.borderColor = .particleColor.main100.cgColor
            self.selectFlag.isHidden = false
            // TODO: 대표문장 레이블
        } else {
            self.sentenceLabel.layer.borderWidth = 0
            self.sentenceLabel.layer.borderColor = UIColor.clear.cgColor
            self.selectFlag.isHidden = true
        }
        
        layoutSubviews()
    }
}
