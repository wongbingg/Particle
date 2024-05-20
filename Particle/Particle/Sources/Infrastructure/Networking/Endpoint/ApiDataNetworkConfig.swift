//
//  ApiDataNetworkConfig.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/08.
//

import Foundation

public struct ApiDataNetworkConfig: NetworkConfigurable {
    public let baseURL: URL

    public let headers: [String: String]

    public let queryParameters: [String: String]

    public init(baseURL: URL,
                headers: [String: String] = [:],
                queryParameters: [String: String] = [:]) {
      self.baseURL = baseURL
      self.headers = headers
      self.queryParameters = queryParameters
    }
}
