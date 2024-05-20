//
//  DefaultDataTransferService.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation
import RxSwift

public final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    private let errorResolver: DataTransferErrorResolver
    private let errorLogger: DataTransferErrorLogger
    
    public init(
        with networkService: NetworkService,
        errorResolver: DataTransferErrorResolver = DefaultDataTransferErrorResolver(),
        errorLogger: DataTransferErrorLogger = DefaultDataTransferErrorLogger()
    ) {
        self.networkService = networkService
        self.errorResolver = errorResolver
        self.errorLogger = errorLogger
    }
}

extension DefaultDataTransferService: DataTransferService {
    
    private func decode<T: Decodable>(data: Data, decoder: ResponseDecoder) throws -> T {
        do {
            let result: T = try decoder.decode(data)
            return result
        } catch {
            self.errorLogger.log(error: error)
            throw DataTransferError.parsing(error)
        }
    }
    
    private func resolve(networkError error: NetworkError) -> DataTransferError {
        let resolvedError = self.errorResolver.resolve(error: error)
        return resolvedError is NetworkError ? .networkFailure(error) : .resolvedNetworkFailure(resolvedError)
    }
    
    public func request<T, E>(with endpoint: E) -> Observable<T> where T : Decodable, T == E.Response, E : ResponseRequestable {
        return networkService.request(endpoint: endpoint)
            .map { data in
                let result: T = try self.decode(data: data, decoder: endpoint.responseDecoder)
                return result
            }
            .catch { error in
                self.errorLogger.log(error: error)

                if let networkError = error as? NetworkError {
                  let transferError = self.resolve(networkError: networkError)
                    return .error(transferError)
                } else if let transferError = error as? DataTransferError {
                    return .error(transferError)
                } else {
                    return .error(DataTransferError.resolvedNetworkFailure(error))
                }
            }
    }
    
    public func request<E>(with endpoint: E) -> Observable<Data> where E : ResponseRequestable, E.Response == Data {
        return networkService.request(endpoint: endpoint)
            .catch { error in
                self.errorLogger.log(error: error)

                if let networkError = error as? NetworkError {
                  let transferError = self.resolve(networkError: networkError)
                    return .error(transferError)
                } else if let transferError = error as? DataTransferError {
                    return .error(transferError)
                } else {
                    return .error(DataTransferError.resolvedNetworkFailure(error))
                }
            }
    }
}
