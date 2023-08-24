//
//  Quaternions.swift
//  swift-opengl
//
//  Created by Jerome Bach on 24/08/2023.
//

import Foundation
import simd

/// SEE: https://developer.apple.com/documentation/accelerate/working_with_quaternions
/// Quaternions are defined by a scalar (real) part, and three imaginary parts collectively called the vector part. Quaternions are often used in graphics programming as a compact representation of the rotation of an object in three dimensions.
///
/// Quaternions have some advantages over matrices. For example, they're smaller: A 3 x 3 matrix of floats is 48 bytes, and a single-precision quaternion is 16 bytes. They also can offer better performance: Although a single rotation using a quaternion is a little slower than one using a matrix, when combining actions, quaternions can be up to 30% faster.
struct Quaternions {
    /// The length of a quaternion is the square root of the sum of the squares of its components
    /// - Parameters:
    ///   - ix: Double
    ///   - iy: Double
    ///   - iz: Double
    ///   - r: Double
    static func length(
        ix: Double = 1.0,
        iy: Double = 4.0,
        iz: Double = 8.0,
        r: Double = 9.0
    ) -> Double {
        let q = simd_quatd(ix: ix, iy: iy, iz: iz, r: r)
        return q.length
    }
    
    /// Quaternions with a length of one are called unit quaternions and can represent rotations in 3D space
    /// - Parameter length: Double
    /// - Returns: Bool
    static func isUnit(length: Double) -> Bool {
        return length == 1.0
    }
    
    /// You can easily convert a nonunit quaternion representing a rotation into a unit quaternion by normalizing its axes.
    /// - Parameters:
    ///   - axis: simd_double3
    ///   - angle: Double
    /// - Returns: simd_quatd
    static func convertToUnit(axis: simd_double3, angle: Double) -> simd_quatd {
        let q = simd_quatd(angle: .pi,
                            axis: simd_normalize(axis))
        return q
    }
}
