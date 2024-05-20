//
//  SearchRepository.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation
import RxSwift

protocol SearchRepository {
    func searchArticleBy(_ text: String) -> Observable<[SearchResult]>
    func getRecentSearchTexts() -> Observable<[String]>
}

