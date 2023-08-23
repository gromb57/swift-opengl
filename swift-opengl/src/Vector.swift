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
}
