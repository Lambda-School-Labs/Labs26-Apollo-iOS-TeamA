// Copyright © 2020 Shawn James. All rights reserved.
// RequestQuestion+CoreDataProperties.swift
//

import CoreData
import Foundation

extension RequestQuestion {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RequestQuestion> {
        return NSFetchRequest<RequestQuestion>(entityName: "RequestQuestion")
    }

    @NSManaged public var id: Int64
    // var contextId: Int
    @NSManaged public var question: String
    @NSManaged public var ratingStyle: String
    @NSManaged public var reviewType: String
    @NSManaged public var topic: Topic
}
