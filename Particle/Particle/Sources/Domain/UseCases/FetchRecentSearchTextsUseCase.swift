//
//  FetchRecentSearchTextsUseCase.swift
//  Particle
//
//  Created by 홍석현 on 12/12/23.
//

import Foundation
import RxSwift

protocol FetchRecentSearchTextsUseCase {
    func execute() -> Observable<[String]>
    func updateRecentSearchText(_ text: String)
    func removeRecentSearch(_ text: String)
    func clearRecentSearches()
}

struct DefaultFetchRecentSearchTextsUseCase: FetchRecentSearchTextsUseCase {
    private let searchRepository: SearchRepository
    
    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }
    
    func execute() -> Observable<[String]> {
        searchRepository.getRecentSearchTexts()
    }
    
    func updateRecentSearchText(_ text: String) {
        var currentSearchList: [String] = UserDefaults.standard.stringArray(forKey: "RECENT_SEARCH_TEXT") ?? []
        currentSearchList.append(text)
        UserDefaults.standard.set(currentSearchList, forKey: "RECENT_SEARCH_TEXT")
    }
    
    func clearRecentSearches() {
        UserDefaults.standard.removeObject(forKey: "RECENT_SEARCH_TEXT")
    }
    
    func removeRecentSearch(_ text: String) {
        var currentSearchList: [String] = UserDefaults.standard.stringArray(forKey: "RECENT_SEARCH_TEXT") ?? []
        guard let lastIndex = currentSearchList.lastIndex(where: { $0 == text }) else { return }
        currentSearchList.remove(at: lastIndex)
        UserDefaults.standard.set(currentSearchList, forKey: "RECENT_SEARCH_TEXT")
    }
}
