//
//  RawDataResponseDecoder.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation

public class RawDataResponseDecoder: ResponseDecoder {
    
    public init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    public func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
