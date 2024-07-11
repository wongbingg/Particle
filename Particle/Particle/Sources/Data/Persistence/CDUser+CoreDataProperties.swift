//
//  CDUser+CoreDataProperties.swift
//  
//
//  Created by 이원빈 on 2024/07/11.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var id: String?
    @NSManaged public var interestedTags: [String]?
    @NSManaged public var nickName: String?
    @NSManaged public var profileImageUrl: String?
    @NSManaged public var interestedRecords: NSObject?

}
