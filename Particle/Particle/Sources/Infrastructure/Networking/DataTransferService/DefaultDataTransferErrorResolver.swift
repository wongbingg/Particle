//
//  DefaultDataTransferErrorResolver.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation

public class DefaultDataTransferErrorResolver: DataTransferErrorResolver {
    public init() {}
    
    public func resolve(error: NetworkError) -> Error {
//        return error
        if case NetworkError.error(_, let data) = error { /// 서버에서 내려준 에러타입으로 변환
            guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else {
                return error
            }
            return errorResponse
        } else {
            return error
        }
    }
}
