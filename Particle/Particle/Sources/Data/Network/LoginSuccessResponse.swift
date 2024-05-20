//
//  LoginSuccessResponse.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct LoginSuccessResponse: Decodable {
    let tokens: LoginToken
    let isNew: Bool
    
    struct LoginToken: Decodable {
        let accessToken: String
        let refreshToken: String
    }
}
