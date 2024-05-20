//
//  RecordReadDTO.swift
//  Particle
//
//  Created by 이원빈 on 2023/08/16.
//

import Foundation

struct RecordReadDTO: Decodable {
    let id: String
    let title: String
    let url: String
    let items: [RecordItemReadDTO]
    let tags: [String]
    let attribute: Attribute
    let createdAt: String
    let createdBy: String
    
    func toDomain() -> RecordCellModel {
        .init(
            id: id,
            createdAt: createdAt,
            items: items.map { $0.toDomain() },
            title: title,
            url: url,
            color: attribute.color,
            style: attribute.style
        )
    }
    
    func fetchDateSectionHeaderString() -> String {
        return DateManager.shared.convert(previousDate: createdAt, to: "yyyy년 MM월")
    }
    
    func fetchDate() -> Date {
        return DateManager.shared.convert(dateString: createdAt)
    }
    
    static func stub(id: String = "1", attribute: Attribute = .stub()) -> Self {
        .init(
            id: id,
            title: "미니멀리스트의 삶",
            url: "www.naver.com",
            items: [
                .stub(content: "개인적으로 나는 매일 글쓰는 일을 습관처럼 하고 있다."),
                .stub(content: "그렇게 쓴 글은 매일 사회관계망서비스(SNS)에 남기기도 하고, 모아서 책으로 내기도 한다.", isMain: true),
                .stub(content: "이런 습관들이 지금의 나를 만들어 줄 수 있었다.")
            ],
            tags: ["iOS"],
            attribute: attribute,
            createdAt: "2023-09-30T01:59:05.230Z",
            createdBy: "노란 삼각형"
        )
    }
    
    struct RecordItemReadDTO: Decodable {
        let content: String
        let isMain: Bool
        
        func toDomain() -> (content: String, isMain: Bool) {
            return (content, isMain)
        }
        
        static func stub(content: String = "contentcontentcontent", isMain: Bool = false) -> Self {
            .init(content: content, isMain: isMain)
        }
    }
    
    struct Attribute: Decodable {
        let color: String // YELLOW or BLUE
        let style: String // TEXT or CARD
        
        static func stub(color: String = "YELLOW", style: String = "TEXT") -> Self {
            .init(color: color, style: style)
        }
    }
}

// MARK: - CoreData로 부터 읽어오는 String 값을 DTO 모델로 변경해주는 과정
/// coredata에 커스텀타입을 지정할 수 없으므로 string 안에서 태그값으로 구분

extension RecordReadDTO.Attribute {
    static func decode(from string: String) -> Self {
        let codeList = string.components(separatedBy: "&") // & 로 구분해서 값을 저장 할 것이다.
        if codeList.count == 2 {
            let colorInfo = codeList[0]
            let styleInfo = codeList[1]
            return .init(color: colorInfo, style: styleInfo)
        } else {
            return .init(color: "empty", style: "empty") // 오류상황
        }
    }
}

extension [RecordReadDTO.RecordItemReadDTO] {
    static func decode(from string: String) -> Self {
        let sentenceList = string.components(separatedBy: "&") // 각각의 문장을 &로 구분
        let dtoList = sentenceList.map { RecordReadDTO.RecordItemReadDTO.decode(from: $0) }
        return dtoList
    }
}

extension RecordReadDTO.RecordItemReadDTO {
    static func decode(from string: String) -> Self {
        let codeList = string.components(separatedBy: "%") // string , bool(T,F)
        if codeList.count == 2 {
            return .init(content: codeList[0], isMain: codeList[1] == "T")
        } else {
            return .init(content: "empty", isMain: false) // 오류상황
        }
    }
}
