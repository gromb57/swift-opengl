//
//  MatrixTests.swift
//  swift-openglTests
//
//  Created by Jerome Bach on 21/08/2023.
//

import Foundation
import XCTest
import simd
import swift_opengl

final class MatrixTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        let x = simd_double4(x: 10, y: 20, z: 30, w: 40)
        let y = simd_double4(x: 1, y: 2, z: 3, w: 4)
        
        let a = simd_double2x4([x, y]) // columns
        XCTAssertEqual(a.columns.0, x)
        XCTAssertEqual(a.columns.1, y)
        
        let b = simd_double4x2(rows: [x, y]) // rows
        XCTAssertEqual(b.columns.0, [10, 1])
        XCTAssertEqual(b.columns.1, [20, 2])
        XCTAssertEqual(b.columns.2, [30, 3])
        XCTAssertEqual(b.columns.3, [40, 4])
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    /// Resolving :
    ///  2x + 4y = 2
    /// -4x + 2y = 14
    func testSolveEquations() throws {
        //  a 2 x 2 matrix containing the left-side coefficients
        let a = simd_double2x2(rows: [
            simd_double2( 2, 4),
            simd_double2(-4, 2)
        ])
        // a vector containing the right-side values:
        let b = simd_double2(2, 14)
        // To find the values of x and y, multiply the inverse of the matrix a with the vector b:
        let x = simd_mul(a.inverse, b)
        XCTAssertEqual(x.x, -2.6)
        XCTAssertEqual(x.y, 1.8, accuracy: 0.01)
    }
    
    /// Transform Vectors with Matrix Multiplication
    /// Translate
    /// 1 | 0 | tx
    /// 0 | 1 | ty
    /// 0 | 0 | 1
    ///
    func testTransformTranslate() throws {
        let positionVector = simd_float3(x: 3, y: 2, z: 1)
        let translationMatrix = Matrix.makeTranslationMatrix(tx: 1, ty: 3)
        let translatedVector = translationMatrix * positionVector
        
        XCTAssertEqual(translatedVector.x, 4.0)
        XCTAssertEqual(translatedVector.y, 5.0)
        XCTAssertEqual(translatedVector.z, 1.0)
    }
    
    /// Transform Vectors with Matrix Multiplication
    /// Rotate
    /// cos(angle) | -sin(angle) | 0
    /// sin(angle) | cos(angle) | 0
    /// 0 | 0 | 1
    ///
    func testTransformRotate() throws {
        let positionVector = simd_float3(x: 4, y: 5, z: 1)
        let angle = Measurement(value: 30, unit: UnitAngle.degrees)
        let radians = Float(angle.converted(to: .radians).value)
        let rotationMatrix = Matrix.makeRotationMatrix(angle: radians)
        let rotatedVector = rotationMatrix * positionVector
        
        XCTAssertEqual(rotatedVector.x, 0.964102, accuracy: 0.00001)
        XCTAssertEqual(rotatedVector.y, 6.33013, accuracy: 0.00001)
        XCTAssertEqual(rotatedVector.z, 1.0)
    }
    
    /// Transform Vectors with Matrix Multiplication
    /// Scale
    /// xScale | 0 | 0
    /// 0 | yScale | 0
    /// 0 | 0 | 1
    ///
    func testTransformScale() throws {
        let positionVector = simd_float3(x: 0.964102, y: 6.33013, z: 1.0)
        let scaleMatrix = Matrix.makeScaleMatrix(xScale: 8, yScale: 1.25)
        let scaledVector = scaleMatrix * positionVector
        
        XCTAssertEqual(scaledVector.x, 7.71282, accuracy: 0.00001)
        XCTAssertEqual(scaledVector.y, 7.91266, accuracy: 0.00001)
        XCTAssertEqual(scaledVector.z, 1.0)
    }
}
