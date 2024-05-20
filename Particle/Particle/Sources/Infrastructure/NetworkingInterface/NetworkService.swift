//
//  NetworkService.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/08.
//

import Foundation
import RxSwift

public protocol NetworkService {
    func request(endpoint: Requestable) -> Observable<Data> // NetworkError 활용
}

public protocol NetworkSessionManager {
    typealias NetworkingOutput = (data: Data, response: URLResponse)
    func request(_ request: URLRequest) -> Observable<NetworkingOutput>
}

public protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
    func log(responseData data: Data, response: URLResponse)
}
