//
//  JSONResponseDecoder.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/09.
//

import Foundation

public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()

    public init() { }

    public func decode<T: Decodable>(_ data: Data) throws -> T {
      return try jsonDecoder.decode(T.self, from: data)
    }
}

public class StringResponseDecoder: ResponseDecoder {
    
    public func decode<T>(_ data: Data) throws -> T where T : Decodable {
        if let responseString = String(data: data, encoding: .utf8) {
            return responseString as! T
        } else {
            throw DataTransferError.failToDecodeString
        }
    }
}
