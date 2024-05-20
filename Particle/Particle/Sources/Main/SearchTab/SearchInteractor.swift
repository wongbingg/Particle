//
//  SearchInteractor.swift
//  Particle
//
//  Created by 이원빈 on 2023/07/18.
//

import RIBs
import RxSwift
import SceneKit

protocol SearchRouting: ViewableRouting {
    func attachMyRecordList(tag: String)
    func detachMyRecordList()
    
    func attachRecordDetail(data: SearchResult)
    func detachRecordDetail()
}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
    
    func updateSearchResult(_ result: [SearchResult])
    func fetchUserInterestTags(_ tags: [String])
    func fetchRecentSearchTexts(_ texts: [String])
}

protocol SearchListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {
    weak var router: SearchRouting?
    weak var listener: SearchListener?
    
    private let search = PublishSubject<String>()
    private let fetchRecentSearchTextList = PublishSubject<Void>()
    private var disposeBag = DisposeBag()
    
    private let searchUseCase: SearchUseCase
    private let userInterestedTagsUseCase: FetchUserInterestTagsUseCase
    private let fetchRecentSearchTextsUseCase: FetchRecentSearchTextsUseCase
    
    init(
        presenter: SearchPresentable,
        searchUseCase: SearchUseCase,
        userInterestedTagsUseCase: FetchUserInterestTagsUseCase,
        fetchRecentSearchTextsUseCase: FetchRecentSearchTextsUseCase
    ) {
        self.searchUseCase = searchUseCase
        self.userInterestedTagsUseCase = userInterestedTagsUseCase
        self.fetchRecentSearchTextsUseCase = fetchRecentSearchTextsUseCase
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        search
            .flatMap(searchUseCase.executeBy(text:))
            .bind { [weak self] result in
                self?.presenter.updateSearchResult(result)
            }
            .disposed(by: disposeBag)
                        
        fetchRecentSearchTextList
            .flatMap(fetchRecentSearchTextsUseCase.execute)
            .bind { [weak self] result in
                self?.presenter.fetchRecentSearchTexts(result)
            }
            .disposed(by: disposeBag)
        
        userInterestedTagsUseCase.execute()
            .bind { [weak self] result in
                self?.presenter.fetchUserInterestTags(result)
            }
            .disposed(by: disposeBag)
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func requestSearchBy(tag: String) {
        router?.attachMyRecordList(tag: tag)
    }
    
    func requestSearchBy(text: String) {
        search.onNext(text)
        fetchRecentSearchTextsUseCase.updateRecentSearchText(text)
        fetchRecentSearchTextList.onNext(())
    }
    
    func myRecordListBackButtonTapped() {
        router?.detachMyRecordList()
    }
    
    func fetchRecentSearchList() {
        fetchRecentSearchTextList.onNext(())
    }
    
    func removeRecentSearch(_ text: String) {
        fetchRecentSearchTextsUseCase.removeRecentSearch(text)
        fetchRecentSearchTextList.onNext(())
    }
    
    func clearRecentSearches() {
        fetchRecentSearchTextsUseCase.clearRecentSearches()
        fetchRecentSearchTextList.onNext(())
    }
    
    func searchResultSelected(_ result: SearchResult) {
        router?.attachRecordDetail(data: result)
    }
    
    func recordDetailCloseButtonTapped() {
        router?.detachRecordDetail()
    }
}
