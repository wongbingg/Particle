//
//  RecordCell.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

struct RecordCellModel {
    let id: String
    let createdAt: String
    let items: [(content: String, isMain: Bool)] // 3개만 받도록?
    let title: String
    let url: String
    let color: String
    let style: String
    
    static func stub() -> Self {
        .init(
            id: "1",
            createdAt: "2023-09-30T01:59:05",
            items: [
                ("첫 번째는 조직 구조를 제품에 그대로 반영\n\n\n\n한 것이었어요. 팀이 맡은 모든 사업과 서비스를 한 곳에 모아 넣고 그대로 하나의 제품으로 묶어버렸죠.",false),
                ("모든 운영 리소스를 한 번에 끊어내는 것이 장기적으로는 더 빠른 속도와 큰 효율을 가져올 것이라고 생각했어요. ", true),
                ("저는 사용자가 바로 제목만 보고 이해할 수 있으면서도 너무 어렵게 느끼지 않았으면 했어요.", false),
                ("디자인이 잘 안 풀릴 때가 있나요? 그렇다면 분명 그 답은 화면에 있지 않을 거에요.", false)
            ],
            title: "미니멀리스트의 삶",
            url: "www.naver.com",
            color: "BLUE",
            style: "TEXT"
        )
    }
}

final class RecordCell: UICollectionViewCell {
    
    enum Metric {
        
        enum SentenceBoxChild {
            static let height: CGFloat = 112
            static let horizontalMargin: CGFloat = 20
        }
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - UIComponents
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_headline,
            color: .particleColor.gray04,
            text: "6.23 화"
        )
        return label
    }()
    
    private let cardStyleBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.gray01
        view.layer.cornerRadius = 16
        return view
    }()
    
    private let cardStyleLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = -16
        return stackView
    }()
    
    private let textStyleBackgroundView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 16
        view.image = .particleImage.background_main100
        view.contentMode = .scaleToFill
        return view
    }()
    
    private let textStyleLabelStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 15
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_footnote,
            color: .particleColor.gray04,
            text: "미니멀리스트 들여다보기"
        )
        return label
    }()
    
    private let urlLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .p_footnote,
            color: .particleColor.gray03,
            text: "www.testurl.com"
        )
        return label
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cardStyleBackgroundView.removeFromSuperview()
        cardStyleLabelStack.removeFromSuperview()
        cardStyleLabelStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        textStyleBackgroundView.removeFromSuperview()
        textStyleLabelStack.removeFromSuperview()
        textStyleLabelStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    // MARK: - Methods
    
    func setupData(data: RecordCellModel) {
        
        if data.style == "TEXT" {
            addSubviews_textStyle()
            setConstraints_textStyle()
            addSentenceRows_textStyle(with: data)
        } else { // CARD
            addSubviews_cardStyle()
            setConstraints_cardStyle()
            addSentenceRows_cardStyle(with: data)
        }
        
        dateLabel.text = DateManager.shared.convert(
            previousDate: data.createdAt,
            to: "M.dd (E)")
        titleLabel.text = data.title
        urlLabel.text = data.url
    }
}

// MARK: - Private Methods

private extension RecordCell {
    
    func addSentenceRows_textStyle(with data: RecordCellModel) {
        
        for (i, item) in data.items.enumerated() {
            guard i < 4 else { break }
            
            let label = makeSentenceRows_textStyle(text: item.content)
            
            if item.isMain {
                label.setParticleFont(
                    .p_body01_bold,
                    color: .particleColor.black,
                    text: item.content
                )
            }
            
            textStyleLabelStack.addArrangedSubview(label)
        }
        textStyleBackgroundView.image = data.color == "YELLOW" ?
            .particleImage.background_yellow : .particleImage.background_main100
    }
    
    func makeSentenceRows_textStyle(text: String) -> UILabel {
        
        let label = UILabel()
        label.setParticleFont(
            .p_body01,
            color: .particleColor.black,
            text: text)
        label.numberOfLines = 0
        return label
    }
    
    func addSentenceRows_cardStyle(with data: RecordCellModel) {
        
        for (i, item) in data.items.enumerated() {
            guard i < 3 else { break }
            
            let label = makeSentenceRows_cardStyle(
                index: i,
                text: item.content,
                isMain: item.isMain,
                color: data.color)
            cardStyleLabelStack.addArrangedSubview(label)
        }
    }
    
    func makeSentenceRows_cardStyle(
        index: Int,
        text: String,
        isMain: Bool,
        color: String
    ) -> UIView {
        
        let view = UIView()
        view.backgroundColor = .particleColor.gray03
        view.layer.cornerRadius = 8
        // 회색일 때
        view.layer.borderColor = .particleColor.gray01.cgColor
        view.layer.borderWidth = 1
        
        if index == 1 {
            view.transform = CGAffineTransform(rotationAngle: .pi*(0.5/180))
        } else {
            view.transform = CGAffineTransform(rotationAngle: -.pi*(2.62/180))
        }
        
        view.snp.makeConstraints {
            $0.height.equalTo(Metric.SentenceBoxChild.height)
        }
        
        let label = UILabel()
        label.setParticleFont(
            .p_body02,
            color: .white,
            text: text
        )
        label.numberOfLines = 0
        
        view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(12)
            $0.top.bottom.equalToSuperview().inset(14)
        }
        
        if isMain {
            view.backgroundColor = color == "YELLOW" ?
                .particleColor.yellow : .particleColor.main100
            view.layer.borderWidth = 0
            label.textColor = .particleColor.gray01
        }
        
        return view
    }
}

// MARK: - Layout Settting

private extension RecordCell {
    
    // MARK: Card Style
    func addSubviews_cardStyle() {
        [dateLabel, cardStyleBackgroundView, bottomStack].forEach {
            contentView.addSubview($0)
        }
        cardStyleBackgroundView.addSubview(cardStyleLabelStack)
        
        [titleLabel, urlLabel].forEach {
            bottomStack.addArrangedSubview($0)
        }
    }
    
    func setConstraints_cardStyle() {
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        cardStyleBackgroundView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(335)
        }
        
        cardStyleLabelStack.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        bottomStack.snp.makeConstraints {
            $0.top.equalTo(cardStyleBackgroundView.snp.bottom).offset(12)
        }
    }
    
    // MARK: Text Style
    func addSubviews_textStyle() {
        [dateLabel, textStyleBackgroundView, bottomStack].forEach {
            contentView.addSubview($0)
        }

        textStyleBackgroundView.addSubview(textStyleLabelStack)
        
        [titleLabel, urlLabel].forEach {
            bottomStack.addArrangedSubview($0)
        }
    }
    
    func setConstraints_textStyle() {
        
        dateLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
        }
        
        textStyleBackgroundView.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(335)
        }
        
        textStyleLabelStack.snp.makeConstraints {
            $0.top.equalToSuperview().inset(27)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.lessThanOrEqualToSuperview().inset(27)
        }
        
        bottomStack.snp.makeConstraints {
            $0.top.equalTo(textStyleBackgroundView.snp.bottom).offset(12)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct RecordCell_Preview: PreviewProvider {
    
    static let cell: RecordCell = {
        let cell = RecordCell(frame: .init(origin: .zero, size: .init(width: DeviceSize.width, height: DeviceSize.width * 1.4)))
        cell.setupData(data: .stub())
        return cell
    }()

    static var previews: some View {
        cell.showPreview()
    }
}
#endif
