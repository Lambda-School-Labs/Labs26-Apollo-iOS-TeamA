// Copyright © 2020 Shawn James. All rights reserved.
// Topic+CoreDataProperties.swift
//

import CoreData
import Foundation

extension Topic {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

//    @NSManaged public var id: Int64
    public var id: Int64? {
        get {
            willAccessValue(forKey: "id")
            defer { didAccessValue(forKey: "id") }

            return primitiveValue(forKey: "id") as? Int64
        }
        set {
            willChangeValue(forKey: "id")
            defer { didChangeValue(forKey: "id") }

            guard let value = newValue else {
                setPrimitiveValue(nil, forKey: "id")
                return
            }
            setPrimitiveValue(value, forKey: "id")
        }
    }

    @NSManaged public var joinCode: String?
    @NSManaged public var leaderId: String
    @NSManaged public var topicName: String?
    //    @NSManaged public var contextId: Int64
    public var contextId: Int64? {
        get {
            willAccessValue(forKey: "contextId")
            defer { didAccessValue(forKey: "contextId") }

            return primitiveValue(forKey: "contextId") as? Int64
        }
        set {
            willChangeValue(forKey: "contextId")
            defer { didChangeValue(forKey: "contextId") }

            guard let value = newValue else {
                setPrimitiveValue(nil, forKey: "contextId")
                return
            }
            setPrimitiveValue(value, forKey: "contextId")
        }
    }

    // MARK: - Relationships

    @NSManaged public var members: NSSet?

    // MARK: - App Use

    @NSManaged public var questionsToSend: Array<Int>? // coding key assigned
    @NSManaged public var responsesToSend: Array<Int>? // coding key assigned

    // relationships (app use)

    @NSManaged public var questions: NSSet? // doesn't get sent
    @NSManaged public var responses: NSSet? // doesn't get sent
}

// MARK: Generated accessors for members

extension Topic {
    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)
}

// MARK: Generated accessors for questions

extension Topic {
    @objc(addQuestionsObject:)
    @NSManaged public func addToQuestions(_ value: Question)

    @objc(removeQuestionsObject:)
    @NSManaged public func removeFromQuestions(_ value: Question)

    @objc(addQuestions:)
    @NSManaged public func addToQuestions(_ values: NSSet)

    @objc(removeQuestions:)
    @NSManaged public func removeFromQuestions(_ values: NSSet)
}

// MARK: Generated accessors for responses

extension Topic {
    @objc(addResponsesObject:)
    @NSManaged public func addToResponses(_ value: Response)

    @objc(removeResponsesObject:)
    @NSManaged public func removeFromResponses(_ value: Response)

    @objc(addResponses:)
    @NSManaged public func addToResponses(_ values: NSSet)

    @objc(removeResponses:)
    @NSManaged public func removeFromResponses(_ values: NSSet)
}