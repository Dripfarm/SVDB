//
//  ContentView.swift
//  SVDBDemo
//
//  Created by Jordan Howlett on 8/4/23.
//

import Accelerate
import CoreML
import NaturalLanguage
import SVDB
import SwiftUI

struct EmbeddingEntry: Codable {
    let id: UUID
    let text: String
    let embedding: [Double]
    let magnitude: Double
}

func generateRandomSentence() -> String {
    var sentence = ""
    for _ in 1...5 {
        if let randomWord = words.randomElement() {
            sentence += randomWord + " "
        }
    }
    return sentence.trimmingCharacters(in: .whitespaces)
}

struct ContentView: View {
    let collectionName: String = "testCollection"
    @State private var collection: Collection?
    @State private var query: String = "emotions"
    @State private var newEntry: String = ""
    @State private var neighbors: [(String, Double)] = []

    var body: some View {
        VStack {
            TextField("Enter query", text: $query)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                TextField("New Entry", text: $newEntry)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add Entry") {
                    Task {
                        await addEntry(newEntry)
                    }
                }
            }
            .padding()

            Button("Find Neighbors") {
                self.neighbors.removeAll()
                Task {
                    await findNeighbors()
                }
            }

            Button("Generate Random Embeddings") {
                Task {
                    await generateRandomEmbeddings()
                }
            }
            .padding()

            List(neighbors, id: \.0) { neighbor in
                Text("\(neighbor.0) - \(neighbor.1)")
            }
        }
        .padding()
        .onAppear {
            Task {
                await loadCollection()
            }
        }
    }

    func loadCollection() async {
        do {
            collection = try SVDB.shared.collection(collectionName)
        } catch {
            print("Failed to load collection:", error)
        }
    }

    func generateRandomEmbeddings() async {
        var randomSentences: [String] = []
        for _ in 1...100 {
            let sentence = generateRandomSentence()
            randomSentences.append(sentence)
        }

        for sentence in randomSentences {
            await addEntry(sentence)
        }

        print("Done creating")
    }

    func addEntry(_ entry: String) async {
        guard let collection = collection else { return }
        guard let embedding = generateEmbedding(for: entry) else {
            return
        }

        collection.addDocument(text: entry, embedding: embedding)
    }

    func generateEmbedding(for sentence: String) -> [Double]? {
        guard let embedding = NLEmbedding.wordEmbedding(for: .english) else {
            return nil
        }

        let words = sentence.lowercased().split(separator: " ")
        guard let firstVector = embedding.vector(for: String(words.first!)) else {
            return nil
        }

        var vectorSum = [Double](firstVector)

        for word in words.dropFirst() {
            if let vector = embedding.vector(for: String(word)) {
                vDSP_vaddD(vectorSum, 1, vector, 1, &vectorSum, 1, vDSP_Length(vectorSum.count))
            }
        }

        var vectorAverage = [Double](repeating: 0, count: vectorSum.count)
        var divisor = Double(words.count)
        vDSP_vsdivD(vectorSum, 1, &divisor, &vectorAverage, 1, vDSP_Length(vectorAverage.count))

        return vectorAverage
    }

    func findNeighbors() async {
        guard let collection = collection else { return }
        guard let queryEmbedding = generateEmbedding(for: query) else {
            return
        }

        let results = collection.search(query: queryEmbedding)
        neighbors = results.map { ($0.text, $0.score) }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
