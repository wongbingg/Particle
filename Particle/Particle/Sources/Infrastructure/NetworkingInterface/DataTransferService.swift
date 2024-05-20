//
//  DataTransferService.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/08.
//

import Foundation
import RxSwift

public protocol DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E) -> Observable<T> where E.Response == T
    
    func request<E: ResponseRequestable>(
        with endpoint: E) -> Observable<Data> where E.Response == Data
}

public enum DataTransferError: Error {
    case noResponse
    case parsing(Error)
    case networkFailure(NetworkError)
    case resolvedNetworkFailure(Error)
    case failToDecodeString
}

public protocol DataTransferErrorResolver {
    func resolve(error: NetworkError) -> Error
}

public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol DataTransferErrorLogger {
    func log(error: Error)
}
