//
//  File.swift
//
//
//  Created by Jordan Howlett on 8/4/23.
//

import Foundation

public struct Document: Codable, Identifiable {
    public let id: UUID
    public let text: String
    public let embedding: [Double]
    public let magnitude: Double

    public init(id: UUID? = nil, text: String, embedding: [Double]) {
        self.id = id ?? UUID()
        self.text = text
        self.embedding = embedding
        self.magnitude = sqrt(embedding.reduce(0) { $0 + $1 * $1 })
    }
}
