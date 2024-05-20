//
//  DefaultNetworkService.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/08.
//

import Foundation
import RxSwift

public final class DefaultNetworkService: NetworkService {
    
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    private var disposeBag = DisposeBag()
    
    public init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger = DefaultNetworkErrorLogger()
    ) {
        self.sessionManager = sessionManager
        self.config = config
        self.logger = logger
    }
    
    private func resolve(error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        } else {
            let code = URLError.Code(rawValue: (error as NSError).code)
            switch code {
            case .notConnectedToInternet: return .notConnected
            case .cancelled: return .cancelled
            default: return .generic(error)
            }
        }
    }
    
    private func handleResponse(data: Data, response: URLResponse) throws -> Data {
        
        if let response = response as? HTTPURLResponse {
            if (200...299).contains(response.statusCode) {
                return data
            } else {
                let error = NetworkError.error(statusCode: response.statusCode, data: data)
                logger.log(error: error)
                throw error
            }
        } else {
            logger.log(responseData: data, response: response)
            return data
        }
    }
    
    private func request(request: URLRequest) -> Observable<Data> {
        logger.log(request: request)
        return sessionManager.request(request)
            .map { pair in
                let data = try self.handleResponse(data: pair.data, response: pair.response)
                return data
            }
            .catch { error in
                let mappedError = self.resolve(error: error)
                return .error(mappedError)
            }
    }

    public func request(endpoint: Requestable) -> Observable<Data> {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest)
        } catch {
            return .error(NetworkError.urlGeneration)
        }
    }
}
