//
//  ExploreViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import RxRelay
import UIKit

protocol ExplorePresentableListener: AnyObject {
    
}

final class ExploreViewController: UIViewController, ExplorePresentable, ExploreViewControllable {
    
    weak var listener: ExplorePresentableListener?
    private var disposeBag = DisposeBag()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title01, color: .particleColor.white, text: "다른 아티클")
        return label
    }()
    
    private let interestedTagCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.minimumInteritemSpacing = 8
        layout.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .horizontal
        
        let collectionView = DynamicHeightCollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(LeftAlignedCollectionViewCell.self)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    private let recordCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = .init(width: DeviceSize.width - 40, height: 400)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecordCell.self)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var recordList: BehaviorRelay<[RecordReadDTO]> = .init(
        value: [.stub(id: "1"), .stub(id: "2"), .stub(id: "3")])
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "탐색"
        tabBarItem.image = .particleImage.exploreTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        addSubviews()
        setConstraints()
        bind()
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
    }
    
    private func bind() {
        
        Observable.of(["#UXUI","#서버", "#iOS", "#머신러닝", "#데이터 분석"]) // TODO: 관심태그 리스트 데이터 주입
            .bind(to: interestedTagCollectionView.rx.items(
                cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
                cellType: LeftAlignedCollectionViewCell.self)
            ) { index, item, cell in
                cell.titleLabel.text = item
            }
            .disposed(by: disposeBag)
        
        interestedTagCollectionView.rx.itemSelected.subscribe { [weak self] indexPath in
            guard let self = self else { return }
            guard let index = indexPath.element else { return }
            guard let selectedCell = self.interestedTagCollectionView.cellForItem(at: index) as? LeftAlignedCollectionViewCell else {
                return
            }
//            selectedCell.setSelected(<#Bool#>)
//            self.tags[index.row].isSelected.toggle()
        }
        .disposed(by: disposeBag)
        
        recordList.bind(to: recordCollectionView.rx.items(
            cellIdentifier: RecordCell.defaultReuseIdentifier,
            cellType: RecordCell.self)
        ) { index, item, cell in
            cell.setupData(data: item.toDomain())
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Layout Settting

private extension ExploreViewController {
    
    func addSubviews() {
        [titleLabel, interestedTagCollectionView, recordCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().inset(20)
            $0.height.equalTo(56)
        }
        
        interestedTagCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.height.equalTo(64)
            $0.leading.trailing.equalToSuperview()
        }
        
        recordCollectionView.snp.makeConstraints {
            $0.top.equalTo(interestedTagCollectionView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct ExploreViewController_Preview: PreviewProvider {
    
    static var exploreVC: ExploreViewController = {
        let vc = ExploreViewController()
        
        return vc
    }()
    
    static var previews: some View {
        exploreVC.showPreview()
    }
}
#endif
