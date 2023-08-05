# Swift Vector Database (SVDB)

A new fast local on-device vector database for Swift Apps.

Built for those building the next-generation of user experiences only possible with on-device intelligence. 

Local on-device vector databases are just the beginning. 

## Installation
To install it using the Swift Package Manager, either directly add it to your project using Xcode 11, or specify it as dependency in the Package.swift file:

```
// ...
dependencies: [
    .package(url: "https://github.com/Dripfarm/SVDB.git", from: "1.0.0"),
],
//...
```


## Usage

### 1. Create Embeddings
```
let document = "cat"
```

ChatGPT:

```
import OpenAI

func embed(text: String) async -> [Double]? {
	let query = EmbeddingsQuery(model: .textEmbeddingAda, input: text)

	let result = try! await openAI.embeddings(query: query)

	return result.data.first?.embedding
}

let wordEmbedding = embed(text: document)
```

NLEmbeddings

```
import NaturalLanguage

let embedding: NLEmbedding? = NLEmbedding.wordEmbedding(for: .english)

let wordEmedding = embedding?.vector(for: document) //returns double array
```

### 2. Add Documents

```
let animalCollection = SVDB.shared.collection("animals")

SVDB.shared.addDocument(text: document, embedding: wordEmbedding)

```

### 3. Search

```
let dogEmedding = embedding?.vector(for: "dog")

let results = animalCollection.search(query: dogEmedding)
```

## Demo

Check out the demo [Demo](https://github.com/Dripfarm/SVDB/tree/master/SVDBDemo)

## Todo
Not sure. I want to make it easier to add documents and take care of the embeddings for you. Any suggestions?