//
//  VectorTests.swift
//  swift-openglTests
//
//  Created by Jerome Bach on 22/08/2023.
//

import XCTest
import simd
import swift_opengl

final class VectorTests: XCTestCase {

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
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLuma() throws {
        XCTAssertEqual(Vector.lumaForColor(red: 0, green: 0, blue: 0), 0)
        XCTAssertEqual(Vector.lumaForColor(red: 1, green: 1, blue: 1), 1)
        XCTAssertEqual(Vector.lumaForColor(red: 0.5, green: 0.5, blue: 0.5), 0.5)
    }

    func testDistanceLength() throws {
        let a = simd_float2(x: 3, y: 4)
        let b = simd_float2(x: 0, y: 0)

        // Both distance and length = 5
        let dist = simd_distance(a, b)
        let len = simd_length(a)
        
        XCTAssertEqual(dist, 5)
        XCTAssertEqual(len, 5)
    }

    func testCompareDistance() throws {
        let a = simd_float2(x: 3, y: 4)
        let b = simd_float2(x: 0, y: 0)
        
        let target = simd_float2(x: 5, y: 2)

        let aIsTheClosest: Bool = simd_distance_squared(a, target) < simd_distance_squared(b, target)
        XCTAssertTrue(aIsTheClosest)
    }
    
    func testCompareDistance2() throws {
        let a = simd_float2(x: 3, y: 4)
        let b = simd_float2(x: 0, y: 0)
        
        let target = simd_float2(x: -1, y: -1)

        let aIsTheClosest: Bool = simd_distance_squared(a, target) < simd_distance_squared(b, target)
        XCTAssertFalse(aIsTheClosest)
    }

    func testCalculateRefraction() {
        let incident = simd_double2(x: 1.5, y: -1)
        let normal = simd_double2(x: 0, y: 1)
        
        let (reflected, refracted) = Vector.calculateRefraction(incident: incident, normal: normal)
        
        XCTAssertEqual(reflected.x, 0.83, accuracy: 0.01)
        XCTAssertEqual(reflected.y, 0.55, accuracy: 0.01)
        XCTAssertEqual(refracted.x, 0.55, accuracy: 0.01)
        XCTAssertEqual(refracted.y, -0.83, accuracy: 0.01)
    }

    func testNormalizeTriangle() {
        let vertex1 = simd_float3(-1.5, 0.5, 0)
        let vertex2 = simd_float3(1, 0, 3)
        let vertex3 = simd_float3(0.5, -0.5, -1.5)
        
        let normal = Vector.normalizeTriangle(vertex1: vertex1, vertex2: vertex2, vertex3: vertex3)
        XCTAssertEqual(normal.x, 0.35, accuracy: 0.01)
        XCTAssertEqual(normal.y, 0.92, accuracy: 0.01)
        XCTAssertEqual(normal.z, -0.14, accuracy: 0.01)
    }
    
    func testInterpolateLinearly() {
        let values = Vector.interpolateLinearly()
        XCTAssertEqual(values.count, 1024)
    }
    
    func testInterpolateSmoothly() {
        let values = Vector.interpolateSmoothly()
        XCTAssertEqual(values.count, 1024)
        XCTAssertEqual(values.first, 0.0)
        XCTAssertEqual(values.last ?? 0.0, 1.0, accuracy: 0.0001)
    }
}
