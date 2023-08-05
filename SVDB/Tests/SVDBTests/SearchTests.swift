//
//  SwiftUIView.swift
//
//
//  Created by Jordan Howlett on 8/4/23.
//

@testable import SVDB
import XCTest

class SVDBSearchTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SVDB.shared.reset()
    }

    func testSearchWithDefaultParameters() throws {
        let svdb = SVDB.shared
        let collectionName = "test"
        let collection = try svdb.collection(collectionName)

        let documents = [
            Document(id: UUID(), text: "test1", embedding: [1.0, 2.0, 3.0]),
            Document(id: UUID(), text: "test2", embedding: [4.0, 5.0, 6.0])
        ]

        collection.addDocuments(documents)
        let query = [2.5, 3.5, 4.5]

        let results = collection.search(query: query)

        XCTAssertEqual(results.count, 2)
    }

    func testSearchWithNumResults() throws {
        let svdb = SVDB.shared
        let collectionName = "test"
        let collection = try svdb.collection(collectionName)

        let documents = [
            Document(id: UUID(), text: "test1", embedding: [1.0, 2.0, 3.0]),
            Document(id: UUID(), text: "test2", embedding: [4.0, 5.0, 6.0])
        ]

        collection.addDocuments(documents)
        let query = [2.5, 3.5, 4.5]

        let results = collection.search(query: query, num_results: 1)

        XCTAssertEqual(results.count, 1)
    }

    func testSearchWithThreshold() throws {
        let svdb = SVDB.shared
        let collectionName = "test"
        let collection = try svdb.collection(collectionName)

        let documents = [
            Document(id: UUID(), text: "test1", embedding: [900.0, 5000.0, 13.0]),
            Document(id: UUID(), text: "test2", embedding: [4.0, 5.0, 6.0])
        ]

        collection.addDocuments(documents)
        let query = [4.0, 5.0, 6.0]

        let results = collection.search(query: query, threshold: 0.9)

        XCTAssertEqual(results.count, 1)
    }
}
