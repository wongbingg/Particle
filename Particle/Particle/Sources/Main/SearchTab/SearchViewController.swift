//
//  SearchViewController.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

protocol SearchPresentableListener: AnyObject {
    func requestSearchBy(text: String)
    func requestSearchBy(tag: String)
    
    func fetchRecentSearchList()
    func removeRecentSearch(_ text: String)
    func clearRecentSearches()
    func searchResultSelected(_ result: SearchResult)
}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    
    weak var listener: SearchPresentableListener?
    
    
    private var disposeBag = DisposeBag()
    private let searchResult = PublishRelay<[SearchResult]>()
    private var tags = BehaviorRelay<[String]>(value: [])
    private var recentSearchList = BehaviorRelay<[String]>(value: [])
    
    private var mainView: SearchMainView {
        return self.view as! SearchMainView
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        title = "검색"
        tabBarItem.image = .particleImage.searchTabIcon
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = SearchMainView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialView()
        
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listener?.fetchRecentSearchList()
    }
    
    private func bind() {
        // MARK: - 최근 검색어 바인딩
        recentSearchList
            .bind(to: mainView.recentSearchView.recentSearchList.rx.items(
                cellIdentifier: SearchListCell.defaultReuseIdentifier,
                cellType: SearchListCell.self)
            ) { tableView, item, cell in
                cell.bind(item)
                cell.listener = self
            }
            .disposed(by: disposeBag)
        
        // MARK: - 관심 태그 바인딩
        tags
            .bind(to: mainView.recentSearchView.tagCollectionView.rx.items(
                cellIdentifier: LeftAlignedCollectionViewCell.defaultReuseIdentifier,
                cellType: LeftAlignedCollectionViewCell.self
            )) { collectionView, item, cell in
                cell.titleLabel.text = item
            }
            .disposed(by: disposeBag)
        
        // MARK: - 최근 검색어 선택으로 검색
        mainView.recentSearchView
            .recentSearchList.rx.modelSelected(String.self).asDriver()
            .drive(onNext: { [weak self] recentData in
                self?.mainView.searchBar.searchTextField.rx.text.onNext(recentData)
                self?.listener?.requestSearchBy(text: recentData)
            })
            .disposed(by: disposeBag)
        
        // MARK: - 관심 태그 선택으로 검색
        mainView.recentSearchView.tagCollectionView.rx.modelSelected(String.self).asDriver()
            .drive { [weak self] tag in
                self?.listener?.requestSearchBy(tag: tag)
            }
            .disposed(by: disposeBag)

        // MARK: - 검색 결과 보여주는 로직
        mainView.searchBar.rx.searchButtonClicked
            .compactMap { [weak self] in
                self?.mainView.searchBar.text
            }
            .subscribe(onNext: { [weak self] text in
                self?.listener?.requestSearchBy(text: text)
            })
            .disposed(by: disposeBag)
        
        Observable<Bool>.merge([
            mainView.searchBar.rx.text.orEmpty.filter { $0.isEmpty == true }.map { _ in false },
            mainView.searchBar.rx.searchButtonClicked.map { _ in true },
            mainView.searchBar.rx.cancelButtonClicked.map { _ in false },
            mainView.recentSearchView.recentSearchList.rx.itemSelected.map { _ in true },
            mainView.searchBar.rx.textDidEndEditing
                .map { _ in false }
                .asObservable()
        ])
        .bind { [weak self] isStart in
            if isStart {
                self?.showSearchResult()
            } else {
                self?.hiddenSearchResult()
            }
        }
        .disposed(by: disposeBag)
        
        mainView.recentSearchView.recentSearchListRemoveButton.rx.tap
            .bind { [weak self] in
                self?.listener?.clearRecentSearches()
            }
            .disposed(by: disposeBag)
        
        searchResult
            .bind(to: mainView.searchResultView.searchResultTableView.rx.items(
                cellIdentifier: SearchResultListCell.defaultReuseIdentifier,
                cellType: SearchResultListCell.self
            )) { tableView, item, cell in
                cell.bind(
                    title: item.title,
                    subTitles: item.items.map { $0.content },
                    tags: item.tags
                )
            }
            .disposed(by: disposeBag)
        
        mainView.searchResultView.searchResultTableView.rx.modelSelected(SearchResult.self)
            .bind { [weak self] result in
                self?.listener?.searchResultSelected(result)
            }
            .disposed(by: disposeBag)
        
        searchResult
            .map { $0.isEmpty == true }
            .asDriver(onErrorJustReturn: false)
            .drive { [weak self] isEmpty in
                self?.mainView.searchResultEmptyView.isHidden = (isEmpty == false)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupInitialView() {
        mainView.backgroundColor = .particleColor.black
        navigationController?.isNavigationBarHidden = true
    }
    
    func showSearchResult() {
        mainView.recentSearchView.isHidden = true
        mainView.searchResultView.isHidden = false
        mainView.searchResultEmptyView.isHidden = true
    }
    
    func hiddenSearchResult() {
        mainView.recentSearchView.isHidden = false
        mainView.searchResultView.isHidden = true
        mainView.searchResultEmptyView.isHidden = true
    }
    
    func updateSearchResult(_ result: [SearchResult]) {
        searchResult.accept(result)
    }
    
    func fetchUserInterestTags(_ tags: [String]) {
        self.tags.accept(tags)
    }
    
    func fetchRecentSearchTexts(_ texts: [String]) {
        self.recentSearchList.accept(texts)
    }
}

extension SearchViewController: SearchListCellListener {
    func deleteButtonTapped(_ text: String?) {
        guard let text = text else { return }
        self.listener?.removeRecentSearch(text)
    }
}

// MARK: - Preview

#if canImport(SwiftUI) && DEBUG
import SwiftUI
import AuthenticationServices

@available(iOS 13.0, *)
struct SearchViewController_Preview: PreviewProvider {
    static var previews: some View {
        SearchViewController().showPreview()
    }
}
#endif
