//
//  NetworkConfigurable.swift
//  Particle
//
//  Created by 이원빈 on 2023/10/08.
//

import Foundation

public protocol NetworkConfigurable {
    
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParameters: [String: String] { get }
}
