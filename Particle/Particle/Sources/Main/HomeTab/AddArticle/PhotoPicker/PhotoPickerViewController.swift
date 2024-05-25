//
//  PhotoPickerViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/19.
//

import RIBs
import RxSwift
import RxRelay
import Photos
import UIKit

protocol PhotoPickerPresentableListener: AnyObject {
    
    func cancelButtonTapped()
    func nextButtonTapped(with assets: [PHAsset])
    func switchCategory(to category: String)
}

final class PhotoPickerViewController: UIViewController,
                                       PhotoPickerPresentable,
                                       PhotoPickerViewControllable {
    
    private enum Metric {
        enum NavigationBar {
            static let height = 44
            static let backButtonLeftMargin = 20
            static let nextButtonRightMargin = 20
        }
        enum CollectionViewCell {
            static let width = (DeviceSize.width-4)/4
        }
    }
    
    weak var listener: PhotoPickerPresentableListener?
    private var disposeBag: DisposeBag = .init()
    private var selectedIndexPaths: BehaviorRelay<[Int]> = .init(value: [])
    private var dataSource: BehaviorRelay<[PHAsset]> = .init(value: [])
    private var page: Int = 1
    private var isPresentCategoryList = false
    private let cachingImageManager = PHCachingImageManager()
    
    // MARK: - UIComponents
    
    private let navigationBar: UIView = {
        let view = UIView()
        view.backgroundColor = .particleColor.black
        return view
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(.particleImage.xmarkButton, for: .normal)
        return button
    }()
    
    private let navigationTitle: UIButton = {
        let button = UIButton()
        button.setTitle("최근 항목 ⏷", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 19)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(.particleColor.main30, for: .disabled)
        button.setTitleColor(.particleColor.main100, for: .normal)
        button.isEnabled = false
        return button
    }()
    
    private let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: Metric.CollectionViewCell.width,
            height: Metric.CollectionViewCell.width
        )
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCell.self)
        collectionView.backgroundColor = .particleColor.black
        return collectionView
    }()
    
    private let photoCategoryListView: PhotoCategoryListView = {
        let listView = PhotoCategoryListView(frame: .zero, style: .plain)
        return listView
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
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
    
    // MARK: - PhotoPickerPresentable
    
    func setDataSource(data: [PHAsset]) {
        dataSource.accept(data)
    }
    
    func setAlbumCategories(categories: [String]) {
        photoCategoryListView.setData(categories)
    }
    
    // MARK: - Methods
    
    private func setupInitialView() {
        view.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
        addSubviews()
        setConstraints()
    }
    
    private func bind() {
        bindPhotoCategoryListView()
        bindCollectionViewCell()
        bindItemSelected()
        bindButtonAction()
    }
    
    private func bindPhotoCategoryListView() {
        photoCategoryListView.selected
            .skip(1)
            .bind { [weak self] selected in
                self?.togglePhotoCategoryListView()
                self?.navigationTitle.setTitle(selected + " ⏷", for: .normal)
                self?.listener?.switchCategory(to: selected)
                self?.selectedIndexPaths.accept([])
                self?.nextButton.isEnabled = false
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionViewCell() {

        dataSource
            .bind(to: photoCollectionView.rx.items(
                cellIdentifier: PhotoCell.defaultReuseIdentifier,
                cellType: PhotoCell.self)
            ) { [weak self] index, item, cell in
                
                guard let self = self else { return }
                cell.setImage(with: item, manager: cachingImageManager)

                if self.selectedIndexPaths.value.contains(index) {
                    let number = self.selectedIndexPaths.value.firstIndex(of: index) ?? 0
                    cell.check(number: number + 1)
                } else {
                    cell.uncheck()
                }
            }
            .disposed(by: disposeBag)
        
        selectedIndexPaths
            .bind { [weak self] indexs in
                for (i, index) in indexs.enumerated() {
                    guard let cell = self?.getCell(at: IndexPath(row: index, section: 0)) else {
                        return
                    }
                    cell.check(number: i + 1)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindItemSelected() {
        photoCollectionView
            .rx
            .itemSelected
            .subscribe { [weak self] indexPath in
                guard let self = self,
                      let indexPath = indexPath.element,
                      let cell = getCell(at: indexPath) else { return }
                
                var list = self.selectedIndexPaths.value
                if list.contains(indexPath.row) {
                    list.remove(
                        at: list.firstIndex(of: indexPath.row) ?? .zero
                    )
                    cell.uncheck()
                } else {
                    list.append(indexPath.row)
                    cell.check(number: list.count)
                }
                self.selectedIndexPaths.accept(list)
                Console.debug("selectedIndex: \(self.selectedIndexPaths.value)")
                nextButton.isEnabled = list.count > 0
            }
            .disposed(by: disposeBag)
    }
    
    private func bindButtonAction() {
        cancelButton.rx.tap
            .bind { [weak self] in
                self?.listener?.cancelButtonTapped()
                self?.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        navigationTitle.rx.tap
            .bind { [weak self] in
                print("최근항목 탭!")
                self?.togglePhotoCategoryListView()
            }
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                var data = [PHAsset]()
                for index in selectedIndexPaths.value {
                    data.append(dataSource.value[index])
                }
                self.listener?.nextButtonTapped(with: data)
            }
            .disposed(by: disposeBag)
    }
    
    private func togglePhotoCategoryListView() {
        isPresentCategoryList.toggle()
        
        if isPresentCategoryList {
            photoCategoryListView.snp.remakeConstraints {
                $0.top.equalTo(navigationBar.snp.bottom)
                $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            }
        } else {
            photoCategoryListView.snp.remakeConstraints {
                $0.top.equalTo(view.snp.bottom)
                $0.bottom.equalTo(view.snp.bottom)
                $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
                $0.height.equalTo(0)
            }
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func getCell(at indexPath: IndexPath?) -> PhotoCell? {
        guard let indexPath = indexPath else {
            Console.error("\(#function) indexPath가 존재하지 않습니다.")
            return nil
        }
        guard let cell = self.photoCollectionView.cellForItem(at: indexPath) as? PhotoCell else {
            return nil
        }
        return cell
    }
}

// MARK: - Layout Settting

private extension PhotoPickerViewController {
    func addSubviews() {
        [navigationBar, photoCollectionView, photoCategoryListView].forEach {
            view.addSubview($0)
        }
        
        [cancelButton, navigationTitle, nextButton].forEach {
            navigationBar.addSubview($0)
        }
    }
    
    func setConstraints() {
        
        navigationBar.snp.makeConstraints {
            $0.top.left.right.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(Metric.NavigationBar.height)
        }
        
        cancelButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(Metric.NavigationBar.backButtonLeftMargin)
        }
        
        navigationTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(Metric.NavigationBar.nextButtonRightMargin)
        }
        
        photoCollectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom)
            $0.bottom.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        photoCategoryListView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.bottom.equalTo(view.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(0)
        }
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct PhotoPickerViewController_Preview: PreviewProvider {
    
    static var previews: some View {
        PhotoPickerViewController().showPreview()
    }
}
#endif
