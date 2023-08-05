@testable import SVDB
import XCTest

final class SVDBTests: XCTestCase {
    override func setUp() {
        super.setUp()
        SVDB.shared.reset()
    }

    func testCreateCollection_Success() {
        let name = "uniqueCollectionName"

        do {
            _ = try SVDB.shared.collection(name)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testCreateCollection_CollectionAlreadyExists() {
        let name = "existingCollectionName"
        do {
            _ = try SVDB.shared.collection(name)
            print("created")
        } catch {
            XCTFail("Unexpected error: \(error)")
        }

        do {
            _ = try SVDB.shared.collection(name)
            XCTFail("Expected collectionAlreadyExists error, but no error was thrown.")
        } catch let error as SVDBError {
            XCTAssertEqual(error, SVDBError.collectionAlreadyExists)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func testRemoveDocument() throws {
        let svdb = SVDB.shared
        let collectionName = "test"
        let collection = try svdb.collection(collectionName)

        let document1 = Document(id: UUID(), text: "test1", embedding: [1.0, 2.0, 3.0])
        let document2 = Document(id: UUID(), text: "test2", embedding: [4.0, 5.0, 6.0])

        collection.addDocuments([document1, document2])

        collection.removeDocument(byId: document1.id)

        let query = [2.5, 3.5, 4.5]
        let searchResults = collection.search(query: query, num_results: 2)
        let resultIds = searchResults.map { $0.id }

        XCTAssertFalse(resultIds.contains(document1.id))
        XCTAssertTrue(resultIds.contains(document2.id))
    }
}
