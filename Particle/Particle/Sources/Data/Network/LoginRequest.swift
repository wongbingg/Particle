//
//  LoginRequest.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct LoginRequest: Encodable {
    let provider: String
    let identifier: String
}
