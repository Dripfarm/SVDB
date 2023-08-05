import Accelerate
import CoreML
import NaturalLanguage

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public class SVDB {
    public static let shared = SVDB()
    private var collections: [String: Collection] = [:]

    private init() {}

    public func collection(_ name: String) throws -> Collection {
        if collections[name] != nil {
            throw SVDBError.collectionAlreadyExists
        }

        let collection = Collection(name: name)
        collections[name] = collection
        try collection.load()
        return collection
    }

    public func getCollection(_ name: String) -> Collection? {
        return collections[name]
    }

    public func releaseCollection(_ name: String) {
        collections[name] = nil
    }

    public func reset() {
        for (_, collection) in collections {
            collection.clear()
        }
        collections.removeAll()
    }
}
