//
//  SearchDataSource.swift
//  Particle
//
//  Created by 홍석현 on 11/23/23.
//

import Foundation
import RxSwift

protocol SearchDataSource {
    func getSearchResultBy(text: String) -> Observable<[SearchResultDTO]>
    func getSearchResultBy(tag: String) -> Observable<[SearchResultDTO]>
}
