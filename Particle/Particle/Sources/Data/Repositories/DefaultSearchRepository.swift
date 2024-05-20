//
//  DefaultSearchRepository.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import RxSwift
import Foundation

struct DefaultSearchRepository: SearchRepository {
    private let searchDataSource: SearchDataSource
    
    init(
        searchDataSource: SearchDataSource
    ) {
        self.searchDataSource = searchDataSource
    }
    
    func searchArticleBy(_ text: String) -> Observable<[SearchResult]> {
        return searchDataSource.getSearchResultBy(text: text)
            .map { $0.map { $0.toDomain() } }
            .catchAndReturn([])
    }
    
    func getRecentSearchTexts() -> Observable<[String]> {
        guard var recentSearchList = UserDefaults.standard.stringArray(forKey: "RECENT_SEARCH_TEXT") else { return Observable.just([]) }
        recentSearchList.reverse()
        return Observable.just(recentSearchList)
    }
}
