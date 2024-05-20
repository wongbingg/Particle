//
//  HomeViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import UIKit

import RIBs
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

protocol HomePresentableListener: AnyObject {
    func homeCellTapped(with model: RecordReadDTO)
    func homePlusButtonTapped()
    func homeSectionTitleTapped(tag: String)
    func homeViewDidLoad()
}

final class HomeViewController: UIViewController, HomePresentable, HomeViewControllable {
    
    weak var listener: HomePresentableListener?
    private var disposeBag = DisposeBag()
    private var recordList: BehaviorRelay<[SectionOfRecordTag]> = .init(value: [])
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfRecordTag>(
        configureCell: { (dataSource, collectionView, indexPath, item) in
            let cell: RecordCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setupData(data: item.toDomain())
            
            return cell
        },
        configureSupplementaryView: { [weak self](dataSource, collectionView, kind, indexPath) in
            let header: SectionHeader_Tag = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                for: indexPath)
            let headerTitle = dataSource.sectionModels[indexPath.section].header
            header.setupData(title: headerTitle)
            header.setButtonAction {
                self?.listener?.homeSectionTitleTapped(tag: headerTitle)
            }
            
            return header
        })
    
    private enum Metric {
        static let plusButtonCornerRadius: CGFloat = 30
        static let plusButtonBorderWidth: CGFloat = 1
        static let plusButtonSize: CGFloat = 60
        static let plusButtonScale: (min: CGFloat, max: CGFloat) = (0.85, 1.0)
        static let plusButtonTrailingInset: CGFloat = 16
        static let plusButtonBottomInset: CGFloat = 110
        
        static let emptyImage: (width: CGFloat, height: CGFloat) = (88, 60)
        static let emptyImageCenterYOffset = 14
        static let emptyLabelOffset = -35
        
        static let mainScrollViewBottomInset: CGFloat = 90
        static let toolTip: (width: CGFloat, height: CGFloat) = (226, 37)
        static let toolTipScale: (min: CGFloat, max: CGFloat) = (0.85, 1.0)
        static let toolTipTrailingInset: CGFloat = -12
    }
    
    // MARK: - UIComponents
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = .particleColor.main100
        
        return activityIndicator
    }()
    
    private let mainScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = configureCollectionViewLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecordCell.self)
        collectionView.register(
            SectionHeader_Tag.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .particleColor.black
        
        return collectionView
    }()
    
    private let plusButton: UIView = {
        let plusIcon: UIImageView = {
            let imageView = UIImageView()
            imageView.image = .particleImage.plusButton
            return imageView
        }()
        
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = Metric.plusButtonCornerRadius
        blurView.layer.borderColor = UIColor(hex: 0xFFFFFF, alpha: 0.1).cgColor
        blurView.layer.borderWidth = Metric.plusButtonBorderWidth
        blurView.clipsToBounds = true
        blurView.contentView.addSubview(plusIcon)
        plusIcon.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        return blurView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.setParticleFont(
            .y_body01,
            color: .particleColor.main100,
            text: "앗! 아직 저장한 아티클이 없어요"
        )
        return label
    }()
    
    private let emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.eyes
        return imageView
    }()
    
    private let toolTip: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .particleImage.tooltip1
        return imageView
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "홈"
        tabBarItem.image = .particleImage.homeTabIcon?.withTintColor(.particleColor.gray03)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        configurePlusButton()
        bind()
        listener?.homeViewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.1) { [self] in
            toolTip.transform = CGAffineTransform(
                scaleX: Metric.toolTipScale.min,
                y: Metric.toolTipScale.min
            )
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.3) { [self] in
                toolTip.transform = CGAffineTransform(
                    scaleX: Metric.toolTipScale.max,
                    y: Metric.toolTipScale.max
                )
            }
        }
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
        
        emptyLabel.isHidden = true
        emptyImage.isHidden = true
        mainScrollView.isHidden = true
        
        addSubviews()
        setConstraints()
    }
    
    private func bind() {
        
        recordList
            .bind(to: horizontalCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        recordList
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] element in
            if element.isEmpty {
                self?.emptyLabel.isHidden = false
                self?.emptyImage.isHidden = false
                self?.mainScrollView.isHidden = true
            } else {
                self?.emptyLabel.isHidden = true
                self?.emptyImage.isHidden = true
                self?.mainScrollView.isHidden = false
            }
        }
        .disposed(by: disposeBag)
        
        horizontalCollectionView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else { return }
                
                let tappedCell = self.recordList.value[indexPath.section].items[indexPath.row]
                self.listener?.homeCellTapped(with: tappedCell)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureCollectionViewLayout() -> UICollectionViewLayout {
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
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 0, leading: 0, bottom: 32, trailing: 0)

        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(50)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func configurePlusButton() {
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(plusButtonTapped)
        )
        plusButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func plusButtonTapped() {
        UIView.animate(withDuration: 0.1) { [self] in
            plusButton.transform = CGAffineTransform(
                scaleX: Metric.plusButtonScale.min,
                y: Metric.plusButtonScale.min
            )
        } completion: { [self] _ in
            UIView.animate(withDuration: 0.1) { [self] in
                plusButton.transform = CGAffineTransform(
                    scaleX: Metric.plusButtonScale.max,
                    y: Metric.plusButtonScale.max
                )
            }
            listener?.homePlusButtonTapped()
            toolTip.isHidden = true
        }
    }
    
    // MARK: - HomePresentable
    
    func setData(data: [SectionOfRecordTag]) {
        recordList.accept(data)
    }
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: - HomeViewControllable
    
    func present(viewController: RIBs.ViewControllable) {
        present(viewController.uiviewController, animated: true, completion: nil)
    }
    
    func dismiss(viewController: RIBs.ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
}

// MARK: - Layout Settings
private extension HomeViewController {
    
    func addSubviews() {
        [
            mainScrollView,
            plusButton,
            toolTip,
            emptyLabel,
            emptyImage,
            activityIndicator
        ]
            .forEach {
                view.addSubview($0)
            }
        
        [
            horizontalCollectionView,
        ]
            .forEach {
                mainScrollView.addSubview($0)
            }
    }
    
    func setConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        mainScrollView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview().inset(Metric.mainScrollViewBottomInset)
            $0.width.equalToSuperview()
        }
        
        horizontalCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalTo(mainScrollView.frameLayoutGuide)
            $0.height.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints {
            $0.width.height.equalTo(Metric.plusButtonSize)
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(Metric.plusButtonTrailingInset)
            $0.bottom.equalToSuperview().inset(Metric.plusButtonBottomInset)
        }
        
        emptyLabel.snp.makeConstraints {
            $0.bottom.equalTo(emptyImage.snp.top).offset(Metric.emptyLabelOffset)
            $0.centerX.equalToSuperview()
        }
        
        emptyImage.snp.makeConstraints {
            $0.width.equalTo(Metric.emptyImage.width)
            $0.height.equalTo(Metric.emptyImage.height)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(Metric.emptyImageCenterYOffset)
        }
        
        toolTip.snp.makeConstraints {
            $0.width.equalTo(Metric.toolTip.width)
            $0.height.equalTo(Metric.toolTip.height)
            $0.centerY.equalTo(plusButton.snp.centerY)
            $0.trailing.equalTo(plusButton.snp.leading).inset(Metric.toolTipTrailingInset)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct HomeViewController_Preview: PreviewProvider {
    
    static var homeVC: HomeViewController = {
        let vc = HomeViewController()
        vc.setData(data: [
            .init(header: "My", items: [.stub(attribute: .init(color: "BLUE", style: "CARD")), .stub()]),
            .init(header: "iOS", items: [.stub(), .stub(attribute: .init(color: "YELLOW", style: "CARD"))]),
            .init(header: "Android", items: [.stub(), .stub()]),
            .init(header: "서버", items: [.stub(attribute: .init(color: "BLUE", style: "TEXT")), .stub()]),
        ])
        return vc
    }()
    
    static var previews: some View {
        homeVC.showPreview()
    }
}
#endif
