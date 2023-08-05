//
//  SwiftUIView.swift
//
//
//  Created by Jordan Howlett on 8/4/23.
//

@testable import SVDB
import XCTest

class SVDBCollectionTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SVDB.shared.reset()
    }

    override func tearDown() {
        super.tearDown()
        SVDB.shared.reset()
        try! SVDB.shared.collection("test").clear()
    }

    func testAddDocument_WithProvidedID() {
        let collection = Collection(name: "test")
        let id = UUID()
        let text = "Test text awesome 2"
        let embedding = [1.0, 2.0, 3.0]

        collection.addDocument(id: id, text: text, embedding: embedding)

        let results = collection.search(query: embedding, num_results: 5)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, text)
    }

    func testAddDocument_WithoutProvidedID() {
        let collection = Collection(name: "test")
        let text = "Test text Awesome"
        let embedding = [1.0, 2.0, 3.0]

        collection.addDocument(id: nil, text: text, embedding: embedding)

        let results = collection.search(query: embedding, num_results: 5)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, text)
    }

    func testAddDocument_MagnitudeCalculation() {
        let collection = Collection(name: "test")
        let embedding = [3.0, 4.0]

        collection.addDocument(id: nil, text: "text", embedding: embedding)

        let results = collection.search(query: embedding, num_results: 5)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.text, "text")
    }

    func testAddDocuments() {
        let svdb = SVDB.shared
        SVDB.shared.reset()
        let collectionName = "test"
        let collection = try! svdb.collection(collectionName)

        let document1 = Document(id: UUID(), text: "test1", embedding: [1.0, 2.0, 3.0])
        let document2 = Document(id: UUID(), text: "test2", embedding: [4.0, 5.0, 6.0])
        let query = [2.5, 3.5, 4.5]

        collection.addDocuments([document1, document2])

        let searchResults = collection.search(query: query, num_results: 5)

        let resultTexts = searchResults.map { $0.text }
        XCTAssertTrue(resultTexts.contains(document1.text))
        XCTAssertTrue(resultTexts.contains(document2.text))
        XCTAssertTrue(resultTexts.count == 2)
    }
}
