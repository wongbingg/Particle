//
//  CDRecord+CoreDataProperties.swift
//  
//
//  Created by 이원빈 on 2024/01/13.
//
//

import Foundation
import CoreData


extension CDRecord {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRecord> {
        return NSFetchRequest<CDRecord>(entityName: "CDRecord")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var tags: String?
    @NSManaged public var attribute: String?
    @NSManaged public var createdAt: String?
    @NSManaged public var createdBy: String?
    @NSManaged public var items: String?

}
