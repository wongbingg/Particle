//
//  Accordion.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/24.
//

import UIKit
import RxSwift
import RxRelay
import SnapKit

final class Accordion: UIView {
    
    enum Metric {
        
        enum MainStack {
            static let cornerRadius: CGFloat = 8
        }
        
        enum Row {
            static let height: CGFloat = 52
            static let leftMargin: CGFloat = 16
            static let rightMargin: CGFloat = 14
            static let horizontalInset: CGFloat = 20
        }
        
        enum Tags {
            static let topMagin: CGFloat = 12
            static let horizontalMargin: CGFloat = 20
            static let minimumLineSpacing: CGFloat = 10
            static let minimumInterItemSpacing: CGFloat = 10
        }
        
        enum CollectionView {
            static let horizontalMargin: CGFloat = 16
            static let verticalMargin: CGFloat = 12
        }
    }
    
    private var disposeBag = DisposeBag()
    private var interestedTags: [String] {
        if let interestedTags = UserDefaults.standard.object(forKey: "INTERESTED_TAGS") as? [String] {
            return interestedTags
        } else {
            return []
        }
    }
    private let tags: [String]
    private(set) var selectedTags: BehaviorRelay<[String]> = .init(value: [])
    private(set) var manager = UndoManager()
    
    // MARK: - UI Components
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layer.cornerRadius = Metric.MainStack.cornerRadius
        stack.backgroundColor = .particleColor.gray02
        return stack
    }()
    
    private let rowStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.backgroundColor = .particleColor.gray01
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(
            top: 0,
            left: Metric.Row.leftMargin,
            bottom: 0,
            right: Metric.Row.rightMargin
        )
        stack.layer.cornerRadius = 8
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 17)
        label.textColor = .particleColor.gray04
        label.highlightedTextColor = .particleColor.main100
        return label
    }()
    
    private let spacer: UIView = {
        let spacer = UIView()
        spacer.setContentHuggingPriority(.init(rawValue: 0), for: .horizontal)
        return spacer
    }()
    
    private let circleView: UIView = {
        let circle = UIView()
        circle.snp.makeConstraints {
            $0.width.height.equalTo(19)
        }
        circle.backgroundColor = .init(hex: 0xf6f6f6).withAlphaComponent(0.06)
        circle.layer.cornerRadius = 19/2
        return circle
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .particleFont.generate(style: .pretendard_Regular, size: 14)
        label.textColor = .particleColor.main100
        label.text = "1"
        return label
    }()
    
    private let arrowButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.arrowUp
        imageView.contentMode = .scaleAspectFit
        imageView.highlightedImage = .particleImage.arrowUp_main
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
        }
        return imageView
    }()
    
    private var angle: CGFloat = .pi
    
    private let recommendTagCollectionView: UICollectionView = {
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumLineSpacing = Metric.Tags.minimumLineSpacing
        layout.minimumInteritemSpacing = Metric.Tags.minimumInterItemSpacing
        layout.sectionInset = .init(
            top: Metric.CollectionView.verticalMargin,
            left: Metric.CollectionView.horizontalMargin,
            bottom: Metric.CollectionView.verticalMargin,
            right: Metric.CollectionView.horizontalMargin
        )
        
        let collectionView = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(LeftAlignedCollectionViewCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init(title: String, tags: [String]) {
        self.tags = tags
        super.init(frame: .zero)
        titleLabel.text = title
        setupInitialView()
        setupTapGesture()
        addSubviews()
        setConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        for interestedTag in interestedTags {
            if tags.contains(interestedTag) {
                rowTapped()
                return
            }
        }
    }
    
    // MARK: - Methods

    private func setupInitialView() {
        backgroundColor = .clear
        self.recommendTagCollectionView.isHidden = true
        self.numberLabel.isHidden = true
        self.circleView.isHidden = true
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(rowTapped)
        )
        rowStack.addGestureRecognizer(tap)
    }
    
    private func bind() {
        
        Observable.of(tags)
        .bind(to: recommendTagCollectionView.rx.items(
            cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
            cellType: LeftAlignedCollectionViewCell.self)) { [weak self] index, item, cell in
                guard let self = self else { return }
                cell.titleLabel.text = item
                if interestedTags.contains(item) {
                    cell.setSelected(true)
                    self.accept(tag: item)
                }
        }
        .disposed(by: disposeBag)
        
        recommendTagCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let index = indexPath.element else { return }
            guard let selectedCell = self.recommendTagCollectionView.cellForItem(at: index) as? LeftAlignedCollectionViewCell else {
                return
            }
            manager.registerUndo(withTarget: selectedCell) { cell in
                cell.setSelected(!selectedCell.isTapped)
                let item = self.tags[index.row]
                self.accept(tag: item)
            }
            selectedCell.setSelected(!selectedCell.isTapped)
            let item = self.tags[index.row]
            self.accept(tag: item)
        }
        .disposed(by: disposeBag)
        
        selectedTags.subscribe { [weak self] selectedTags in
            guard let self = self else { return }
            guard let selectedTags = selectedTags.element else { return }
            
            self.numberLabel.text = "\(selectedTags.count)"
            self.numberLabel.isHidden = selectedTags.isEmpty
            self.circleView.isHidden = selectedTags.isEmpty
            self.titleLabel.isHighlighted = selectedTags.isEmpty == false
            self.arrowButton.isHighlighted = selectedTags.isEmpty == false
        }
        .disposed(by: disposeBag)
    }
    
    private func accept(tag: String) {
        
        if self.selectedTags.value.contains(tag) {
            guard let firstIndex = self.selectedTags.value.firstIndex(of: tag) else { return }
            var list = selectedTags.value
            list.remove(at: firstIndex)
            selectedTags.accept(list)
        } else {
            var list = selectedTags.value
            list.append(tag)
            selectedTags.accept(list)
        }
    }
    
    @objc private func rowTapped() {
        
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.recommendTagCollectionView.isHidden.toggle()
            
            if self.recommendTagCollectionView.isHidden {
                self.angle = .pi
            } else {
                self.angle = 0
            }
            self.arrowButton.transform = CGAffineTransform.init(rotationAngle: self.angle)
        }
    }
    
    func openAccordion() {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.recommendTagCollectionView.isHidden = false
            self.angle = 0
            
            self.arrowButton.transform = CGAffineTransform.init(rotationAngle: self.angle)
        }
    }
    
    func closeAccordion() {
        UIView.animate(withDuration: 0.3, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.recommendTagCollectionView.isHidden = true
            self.angle = .pi
            self.arrowButton.transform = CGAffineTransform.init(rotationAngle: self.angle)
        }
    }
}

// MARK: - Layout Settting

private extension Accordion {
    
    func addSubviews() {
        [mainStack, circleView].forEach {
            addSubview($0)
        }
        
        [rowStack, recommendTagCollectionView].forEach {
            mainStack.addArrangedSubview($0)
        }
        
        [titleLabel, spacer, arrowButton].forEach {
            rowStack.addArrangedSubview($0)
        }
        
        [numberLabel].forEach {
            circleView.addSubview($0)
        }
    }
    
    func setConstraints() {
        self.snp.makeConstraints {
            $0.height.equalTo(mainStack)
            $0.width.equalTo(DeviceSize.width)
        }
        
        mainStack.snp.makeConstraints {
            $0.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        rowStack.snp.makeConstraints {
            $0.height.equalTo(Metric.Row.height)
        }
        
        circleView.snp.makeConstraints {
            $0.centerY.equalTo(rowStack.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(4)
        }
        
        numberLabel.snp.makeConstraints {
            $0.center.equalTo(circleView.snp.center)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import SnapKit

@available(iOS 13.0, *)
struct Accordion_Preview: PreviewProvider {
    
    static let accordion: Accordion = {
        let accordion = Accordion(title: "디자인", tags: ["#브랜딩", "#UIUX", "#그래픽 디자인", "#제품디자인"])
        return accordion
    }()

    static var previews: some View {
        accordion
            .showPreview()
    }
}
#endif
