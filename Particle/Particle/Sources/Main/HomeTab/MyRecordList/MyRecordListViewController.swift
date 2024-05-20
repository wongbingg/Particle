//
//  MyRecordListViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/09/03.
//

import UIKit

import RIBs
import RxSwift
import RxRelay
import RxDataSources
import SnapKit

protocol MyRecordListPresentableListener: AnyObject {
    func myRecordListBackButtonTapped()
    func myRecordSorByRecentButtonTapped()
    func myRecordSorByOldButtonTapped()
    func myRecordListCellTapped(with: RecordReadDTO)
}

final class MyRecordListViewController: UIViewController,
                                        MyRecordListPresentable,
                                        MyRecordListViewControllable {
    
    weak var listener: MyRecordListPresentableListener?
    private var disposeBag = DisposeBag()
    private var recordList: BehaviorRelay<[SectionOfRecordDate]> = .init(value: [
        .init(header: "2023년 6월", items: [.stub(), .stub(), .stub()]),
        .init(header: "2023년 7월", items: [.stub(), .stub(), .stub()]),
        .init(header: "2023년 8월", items: [.stub(), .stub(), .stub()])
    ])
    
    private var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfRecordDate>(
        configureCell: { (dataSource, collectionView, indexPath, item) in
            let cell: RecordCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setupData(data: item.toDomain())
            
            return cell
        },
        configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header: SectionHeader_Date = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionHeader,
                    for: indexPath)
                header.setupData(title: dataSource.sectionModels[indexPath.section].header)
                return header
            case UICollectionView.elementKindSectionFooter:
                let footer: SectionFooter_Divider = collectionView.dequeueReusableSupplementaryView(
                    ofKind: UICollectionView.elementKindSectionFooter,
                    for: indexPath)
                return footer
            default:
                Console.error("dataSource - configureSupplementaryView Error")
                assert(false, "Unexpected element kind")
                return .init()
            }
        })
    
    enum Metric {
        enum NavigationBar {
            static let height = 45
            static let backButtonLeftMargin = 8
            static let backButtonIconSize = 20
            static let backButtonTapSize = 44
        }
    }
    
    // MARK: - UIComponents
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.setParticleFont(.y_title02, color: .white, text: "내가 저장한 아티클")
        label.numberOfLines = 0
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton2, for: .normal)
        button.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(Metric.NavigationBar.backButtonIconSize)
        }
        button.snp.makeConstraints {
            $0.width.height.equalTo(Metric.NavigationBar.backButtonTapSize)
        }
        return button
    }()
    
    private let recentlyOrderButtonLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_caption, color: .particleColor.gray04, text: "최신순")
        label.snp.makeConstraints {
            $0.width.equalTo((DeviceSize.width-40-14)/2)
            $0.height.equalTo(25)
        }
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let oldlyOrderButtonLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_caption, color: .particleColor.gray03, text: "오래된 순")
        label.snp.makeConstraints {
            $0.width.equalTo((DeviceSize.width-40-14)/2)
            $0.height.equalTo(25)
        }
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let segmentBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.bk02
        view.layer.cornerRadius = 12
        view.snp.makeConstraints {
            $0.width.equalTo((DeviceSize.width-40-14)/2)
            $0.height.equalTo(25)
        }
        return view
    }()
    
    private let segmentControl: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 17
        view.snp.makeConstraints {
            $0.height.equalTo(35)
        }
        return view
    }()
    
    private var segmentBarLeft: Constraint?
    private var segmentBarRight: Constraint?
    
    private lazy var dateCollectionView: UICollectionView = {
        let layout = configureCollectionViewLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecordCell.self)
        collectionView.register(
            SectionHeader_Date.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(
            SectionFooter_Divider.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .particleColor.bk02
        
        return collectionView
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .particleColor.bk02
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setConstraints()
        configureSegmentControl()
        bind()
    }
    
    // MARK: - Methods
    
    private func bind() {
        backButton.rx.tap
            .bind { [weak self]_ in
                self?.listener?.myRecordListBackButtonTapped()
            }
            .disposed(by: disposeBag)
        
        recordList
            .bind(to: dateCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        dateCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                
                let tappedCell = self.recordList.value[indexPath.section].items[indexPath.row]
                self.listener?.myRecordListCellTapped(with: tappedCell)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureSegmentControl() {
        let tabGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(sortByRecentButtonTapped)
        )
        recentlyOrderButtonLabel.addGestureRecognizer(tabGesture)
        
        let tabGesture2 = UITapGestureRecognizer(
            target: self,
            action: #selector(sortByOldButtonTapped)
        )
        oldlyOrderButtonLabel.addGestureRecognizer(tabGesture2)
    }
    
    @objc private func sortByRecentButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.recentlyOrderButtonLabel.textColor = .particleColor.gray04
            self.oldlyOrderButtonLabel.textColor = .particleColor.gray03
            self.segmentBarLeft?.update(offset: 0)
            self.view.layoutIfNeeded()
        }
        listener?.myRecordSorByRecentButtonTapped()
    }
    
    @objc private func sortByOldButtonTapped() {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut) { [weak self] in
            guard let self = self else { return }
            self.recentlyOrderButtonLabel.textColor = .particleColor.gray03
            self.oldlyOrderButtonLabel.textColor = .particleColor.gray04
            self.segmentBarLeft?.update(offset: ((DeviceSize.width-40-14) / 2) + 4)
            self.view.layoutIfNeeded()
        }
        listener?.myRecordSorByOldButtonTapped()
    }
    
    // MARK: - MyRecordListPresentable
    
    func setData(with data: [SectionOfRecordDate]) {
        recordList.accept(data)
    }
}

// MARK: - Layout Settting

private extension MyRecordListViewController {
    
    func addSubviews() {
        [navigationBar, segmentControl, dateCollectionView].forEach {
            view.addSubview($0)
        }
        
        [backButton, navigationTitle].forEach {
            navigationBar.addSubview($0)
        }
        
        [segmentBar, recentlyOrderButtonLabel, oldlyOrderButtonLabel].forEach {
            segmentControl.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.centerX.equalToSuperview()
        }
        
        segmentBar.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            segmentBarLeft = $0.leading.equalTo(recentlyOrderButtonLabel.snp.leading).constraint
        }
        
        recentlyOrderButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(5)
        }
        
        oldlyOrderButtonLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(5)
        }
        
        dateCollectionView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func configureCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(394)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 32

        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionFooter,
            alignment: .bottom
        )
        section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct MyRecordListViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        MyRecordListViewController().showPreview()
    }
}
#endif
