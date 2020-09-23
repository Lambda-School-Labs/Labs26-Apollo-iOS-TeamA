//
//  CoreDataTests.swift
//  labs-ios-starterTests
//
//  Created by Kenny on 9/22/20.
//  Copyright © 2020 Lambda, Inc. All rights reserved.
//

import XCTest
import CoreData
@testable import labs_ios_starter

class CoreDataTests: XCTestCase {
    let fetchController = FetchController()

    func testCanSaveAndFetchTopic() {
        let member = Member(id: "Test1", email: "test1@test.com", firstName: "Test", lastName: "Member", avatarURL: URL(string: "http://devgauge.com"))
        let members = NSSet().adding(member) as NSSet
        //members = members.adding(member) as NSSet
        
        Topic(id: 1, joinCode: "join1", leaderId: member.id!, members: members, topicName: "TestTopic", contextId: 2)

        do {
            try CoreDataManager.shared.saveContext()
        } catch {
            XCTFail("error saving CoreData: \(error)")
        }
        let fetchedTopics = fetchController.fetchLeaderTopics(with: [1])
        XCTAssertEqual(fetchedTopics?.count, 1)
    }

    func testCanEstablishMemberRelationship() {
        let fetchedTopics = fetchController.fetchLeaderTopics(with: [1])
        let members = fetchedTopics?[0].members
        XCTAssertNotNil(members)
        XCTAssertTrue(members!.count > 0)
    }

    func testCanEditTopicWithExternalChange() {
        let fetchedTopic = fetchController.fetchLeaderTopics(with: [1])?[0]
        let name = fetchedTopic?.topicName
        XCTAssertNotNil(name)
        fetchedTopic?.topicName = "Changed It"
        XCTAssertNotEqual(name, fetchedTopic?.topicName)
    }

}