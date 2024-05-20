//
//  SelectSentenceViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/13.
//

import RIBs
import RxSwift
import UIKit
import SnapKit
import VisionKit
import Vision
import Photos

protocol SelectSentencePresentableListener: AnyObject {
    
    func showEditSentenceModal(with text: String)
    func backButtonTapped()
    func nextButtonTapped()
}

final class SelectSentenceViewController: UIViewController,
                                          SelectSentencePresentable,
                                          SelectSentenceViewControllable {
    
    enum Metric {
        enum Title {
            static let topMargin = 12
            static let leftMargin = 20
        }
        
        enum NavigationBar {
            static let height: CGFloat = 44
            static let backButtonLeftMargin: CGFloat = 8
            static let nextButtonRightMargin: CGFloat = 8
            static let selectedCountRightMargin: CGFloat = 60
        }
        
        enum InfoBox {
            static let height: CGFloat = 53
            static let infoLabelLeftInset: CGFloat = 20
        }
        
        enum CollectionViewCell {
            static let width = DeviceSize.width
            static let height = DeviceSize.height - Metric.NavigationBar.height - InfoBox.height - 100
        }
    }
    
    weak var listener: SelectSentencePresentableListener?
    private var disposeBag: DisposeBag = .init()
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.backButton, for: .normal)
        return button
    }()
    
    private let selectedCountBox: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.main100
        view.snp.makeConstraints {
            $0.width.height.equalTo(20)
        }
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let selectedCount: UILabel = {
        let label = UILabel()
        label.setParticleFont(.p_callout, color: .particleColor.white, text: "0")
        return label
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.particleColor.main30, for: .disabled)
        button.setTitleColor(.particleColor.main100, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let navigationTitle: UILabel = {
        let label = UILabel()
        label.text = "문장 선택 1/7"
        label.font = .systemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    private let infoBox: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.bk02
        return view
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "사진 위 글자를 드래그 후 복사(Copy) 해주세요."
        label.textColor = .particleColor.gray03
        return label
    }()
    
    private let selectedPhotoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: Metric.CollectionViewCell.width,
            height: Metric.CollectionViewCell.height
        )
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SelectedPhotoCell.self)
        collectionView.backgroundColor = .init(hex: 0x1f1f1f)
        return collectionView
    }()
    
    private let selectedImages: [PHAsset]
    
    // MARK: - Initializers
    
    init(selectedImages: [PHAsset]) {
        self.selectedImages = selectedImages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let alreadyShow = UserDefaults.standard.object(forKey: "ShowSwipeGuide") as? Bool,
              alreadyShow == false else {
            return
        }
        showSwipeGuide()
    }
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        selectedCountBox.isHidden = true
        addSubviews()
        setConstraints()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
        
        backButton.rx.tap
            .bind { [weak self] in
                self?.listener?.backButtonTapped()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                self?.listener?.nextButtonTapped()
            }
            .disposed(by: disposeBag)
    }
    
    private func bind() {
        
        bindCollectionViewCell()
        bindPageIndex()
    }
    
    private func bindCollectionViewCell() {
        Observable.of(selectedImages)
            .bind(to: selectedPhotoCollectionView.rx.items(
                cellIdentifier: SelectedPhotoCell.defaultReuseIdentifier,
                cellType: SelectedPhotoCell.self)
            ) { [weak self] index, item, cell in
                cell.setImage(with: item)
                cell.listener = self
            }
            .disposed(by: disposeBag)
    }
    
    private func bindPageIndex() {
        selectedPhotoCollectionView
            .rx
            .contentOffset
            .subscribe { [weak self] offset in
                guard let self = self, let offsetX = offset.element?.x else { return }
                calculatePageIndex(with: offsetX)
            }
            .disposed(by: disposeBag)
    }
    
    private func calculatePageIndex(with offsetX: CGFloat) {
        let index = Int((offsetX + DeviceSize.width/2) / DeviceSize.width) + 1
        navigationTitle.text = "문장 선택 \(index)/\(selectedImages.count)"
    }
    
    private func showSwipeGuide() {
        
        UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseOut]) { [weak self] in
            self?.selectedPhotoCollectionView.contentOffset.x = 70
        } completion: { _ in
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut]) { [weak self] in
                self?.selectedPhotoCollectionView.contentOffset.x = 1
            }
        }
        UserDefaults.standard.set(true, forKey: "ShowSwipeGuide")
    }
    
    // MARK: - SelectSentenceViewControllable
    
    func present(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismiss(viewController: ViewControllable) {
        if presentedViewController === viewController.uiviewController {
            dismiss(animated: true)
        }
    }
    
    // MARK: - SelectSentencePresentable
    
    func updateSelectedCount(_ number: Int) {
        if selectedCountBox.isHidden {
            selectedCountBox.isHidden.toggle()
        }
        selectedCount.setParticleFont(.p_callout, color: .particleColor.white, text: "\(number)")
        if nextButton.isEnabled == false {
            nextButton.isEnabled = true
        }
    }
}

extension SelectSentenceViewController: SelectedPhotoCellListener {
    
    func copyButtonTapped(with text: String) {
        listener?.showEditSentenceModal(with: text)
    }
}

// MARK: - Layout Settting

private extension SelectSentenceViewController {
    
    func addSubviews() {
        selectedCountBox.addSubview(selectedCount)
        
        [backButton, navigationTitle, selectedCountBox, nextButton].forEach {
            navigationBar.addSubview($0)
        }
        
        [navigationBar, infoBox, selectedPhotoCollectionView].forEach {
            view.addSubview($0)
        }
        
        infoBox.addSubview(infoLabel)
    }
    
    func setConstraints() {
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        selectedCountBox.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.NavigationBar.selectedCountRightMargin)
        }
        
        selectedCount.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        infoBox.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.InfoBox.height)
        }
        
        infoLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Metric.InfoBox.infoLabelLeftInset)
        }
        
        selectedPhotoCollectionView.snp.makeConstraints {
            $0.top.equalTo(infoBox.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

// MARK: - Preview
#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct SelectSentenceViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        SelectSentenceViewController(selectedImages: []).showPreview()
    }
}
#endif
