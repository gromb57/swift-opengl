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
    
    static func degreesToRadians(_ degrees: Float) -> Float {
        return degrees * .pi / 180
    }
    
    /// Apply a rotation
    /// - Parameters:
    ///   - originVector: simd_float3
    ///   - degrees: Float
    /// - Returns: simd_float3
    static func rotatePointAroundSphere(originVector: simd_float3, degrees: Float) -> simd_float3 {
        let quaternion = simd_quatf(angle: degreesToRadians(degrees),
                                    axis: simd_float3(x: 1,
                                                      y: 0,
                                                      z: 0))
        let rotatedVector = quaternion.act(originVector)
        return rotatedVector
    }

    static func interpolateTwoPointsOnSphere() {
        let origin = simd_float3(0, 0, 1)


        let q0 = simd_quatf(angle: .pi / 6,
                            axis: simd_normalize(simd_float3(x: 0,
                                                             y: -1,
                                                             z: 0)))
        let u0 = simd_act(q0, origin)


        let q1 = simd_quatf(angle: .pi / 6,
                            axis: simd_normalize(simd_float3(x: -1,
                                                             y: 1,
                                                             z: 0)))
        let u1 = simd_act(q1, origin)


        let q2 = simd_quatf(angle: .pi / 20,
                            axis: simd_normalize(simd_float3(x: 1,
                                                             y: 0,
                                                             z: -1)))

        // The simd_slerp(_:_:_:) function linearly interpolates along the shortest arc between two quaternions. The following code calls simd_slerp(_:_:_:) with small increments to its t parameter, adding a line segment at each interpolated value to build the short arc between q0 and q1 shown in the preceding image:
        for t: Float in stride(from: 0, to: 1, by: 0.001) {
            let q = simd_slerp(q0, q1, t)
            // code to add line segment at `q.act(origin)`
        }
        
        // The simd_slerp_longest(_:_:_:) function linearly interpolates along the longest arc between two quaternions. The following code calls simd_slerp_longest(_:_:_:) with small increments to its t parameter, adding a line segment at each interpolated value to build the long arc between q1 and q2 shown in the preceding image:
        for t: Float in stride(from: 0, to: 1, by: 0.001) {
            let q = simd_slerp_longest(q1, q2, t)
            // code to add line segment at `q.act(origin)`
        }
    }
    
    static func interpolateMultiplePointsOnSphere(rotations: [simd_quatf]) {
        // To interpolate between multiple quaternions that define positions on the surface of a sphere, the simd library provides the simd_spline(_:_:_:_:_:) function.
        
        // Much like simd_slerp(_:_:_:), simd_spline(_:_:_:_:_:) accepts the two quaternions to interpolate between, but also requires the surrounding two quaternions. Given an array of quaternions named rotations, the following code iterates over each element, adding a line segment at each interpolated value to build the smooth line

        for i in 1 ... rotations.count - 3 {
            for t: Float in stride(from: 0, to: 1, by: 0.001) {
                let q = simd_spline(rotations[i - 1],
                                    rotations[i],
                                    rotations[i + 1],
                                    rotations[i + 2],
                                    t)
                // code to add line segment at `q.act(origin)`
            }
        }
    }
}
