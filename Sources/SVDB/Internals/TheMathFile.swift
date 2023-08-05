//
//  MathFunctions.swift
//

import Accelerate

enum MathFunctions {
    static func cosineSimilarity(_ a: [Double], _ b: [Double], magnitudeA: Double, magnitudeB: Double) -> Double {
        var result = 0.0
        vDSP_dotprD(a, 1, b, 1, &result, vDSP_Length(a.count))
        return result / (magnitudeA * magnitudeB)
    }

    static func euclideanDistance(_ a: [Double], _ b: [Double]) -> Double {
        var differences = [Double](repeating: 0.0, count: a.count)
        vDSP_vsubD(a, 1, b, 1, &differences, 1, vDSP_Length(a.count))

        var squaredDifferences = [Double](repeating: 0.0, count: a.count)
        vDSP_vsqD(differences, 1, &squaredDifferences, 1, vDSP_Length(a.count))

        var sumOfSquaredDifferences = 0.0
        vDSP_sveD(squaredDifferences, 1, &sumOfSquaredDifferences, vDSP_Length(a.count))

        return sqrt(sumOfSquaredDifferences)
    }
}
