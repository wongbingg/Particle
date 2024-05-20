//
//  UserReadDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

struct UserReadDTO: Decodable {
    let id: String
    let nickname: String
    let profileImageUrl: String
    let interestedTags: [String]
}
