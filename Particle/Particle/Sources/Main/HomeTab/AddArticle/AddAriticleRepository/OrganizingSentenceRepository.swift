//
//  OrganizingSentenceRepository.swift
//  Particle
//
//  Created by Sh Hong on 2023/07/12.
//

import Foundation
import RxSwift
import RxRelay

protocol OrganizingSentenceRepository {
    var sentenceFile: BehaviorSubject<[String]> { get }
    var sentenceFile2: BehaviorRelay<[OrganizingSentenceViewModel]> { get }
}

final class OrganizingSentenceRepositoryImp: OrganizingSentenceRepository {

    var sentenceFile: BehaviorSubject<[String]> = .init(value: [])
    
    var sentenceFile2: BehaviorRelay<[OrganizingSentenceViewModel]> = .init(value: [])
}
