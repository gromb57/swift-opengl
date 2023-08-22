//
//  Matrix.swift
//  swift-opengl
//
//  Created by Jerome Bach on 22/08/2023.
//

import Foundation
import simd

struct Matrix {
    static func makeTranslationMatrix(tx: Float, ty: Float) -> simd_float3x3 {
        var matrix = matrix_identity_float3x3
        
        matrix[2, 0] = tx
        matrix[2, 1] = ty
        
        return matrix
    }
    
    static func makeRotationMatrix(angle: Float) -> simd_float3x3 {
        let rows = [
            simd_float3(cos(angle), -sin(angle), 0),
            simd_float3(sin(angle), cos(angle), 0),
            simd_float3(0,          0,          1)
        ]
        
        return float3x3(rows: rows)
    }
    
    static func makeScaleMatrix(xScale: Float, yScale: Float) -> simd_float3x3 {
        let rows = [
            simd_float3(xScale,      0, 0),
            simd_float3(     0, yScale, 0),
            simd_float3(     0,      0, 1)
        ]
        
        return float3x3(rows: rows)
    }
}
