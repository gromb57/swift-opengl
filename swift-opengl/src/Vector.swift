//
//  Vector.swift
//  swift-opengl
//
//  Created by Jerome Bach on 22/08/2023.
//

import Foundation
import simd

struct Vector {
    static let rec709Luma = simd_float3(0.2126, 0.7152, 0.0722)
    
    /// Get luminance of a color
    /// - Parameters:
    ///   - red: Float 0..1
    ///   - green: Float 0..1
    ///   - blue: Float 0..1
    /// - Returns: Float 0..1
    static func lumaForColor(red: Float, green: Float, blue: Float) -> Float {
        let luma = simd_dot(rec709Luma,
                            simd_float3(red, green, blue))
        
        return luma
    }
    
    /// Calculate reflection and refraction
    /// - Parameters:
    ///   - incident: simd_double2
    ///   - normal: simd_double2
    /// - Returns: (reflection, refraction)
    static func calculateRefraction(incident: simd_double2, normal: simd_double2) -> (simd_double2, simd_double2) {
        // normalize vectors
        let incidentNormalized = simd_normalize(incident)
        let normalNormalized = simd_normalize(normal)
        
        // calculate reflection
        let reflected = simd_reflect(incidentNormalized, normalNormalized)
        
        // calculate refraction
        let air = 1.0       // refractive index for air
        let glass = 1.5     // refractive index for glass
        let refracted = simd_refract(incidentNormalized, normalNormalized, air / glass)
        
        return (reflected, refracted)
    }
    
    ///The normal of a triangle in 3D space is the vector perpendicular to its surface
    /// - Parameters:
    ///   - vertex1: simd_float3
    ///   - vertex2: simd_float3
    ///   - vertex3: simd_float3
    /// - Returns: simd_float3
    static func normalizeTriangle(vertex1: simd_float3, vertex2: simd_float3, vertex3: simd_float3) -> simd_float3 {
        let vector1 = vertex2 - vertex3
        let vector2 = vertex2 - vertex1
        
        let normal = simd_normalize(simd_cross(vector1, vector2))
        
        return normal
    }

    static func interpolateLinearly(from: Float = 0.0, to: Float = 1.0) -> [Float] {
        let linear: [Float] = stride(from: from, to: to, by: 1 / 1024).map { x in
            return simd_mix(-100, 100, x)
        }
        return linear
    }
    
    static func interpolateSmoothly() -> [Float] {
        let smooth: [Float] = (-512 ..< 512).map { x in
            return simd_smoothstep(-512, 512, Float(x))
        }
        return smooth
    }
}
