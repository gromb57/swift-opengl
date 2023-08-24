//
//  QuaternionsTests.swift
//  swift-openglTests
//
//  Created by Jerome Bach on 24/08/2023.
//

import XCTest
import swift_opengl
import simd

final class QuaternionsTests: XCTestCase {

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

    func testLength() throws {
        let ix: Double = 1.0
        let iy: Double = 4.0
        let iz: Double = 8.0
        let r: Double = 9.0
        XCTAssertEqual(Quaternions.length(ix: ix, iy: iy, iz: iz, r: r), sqrt(ix*ix + iy*iy + iz*iz + r*r))
    }
    
    func testIsUnit() throws {
        let ix: Double = 1.0
        let iy: Double = 4.0
        let iz: Double = 8.0
        let r: Double = 9.0
        let axis = simd_double3(x: ix,
                                y: iy,
                                z: iz)
        XCTAssertFalse(Quaternions.isUnit(length: Quaternions.length(ix: ix, iy: iy, iz: iz, r: r)))
        let q = Quaternions.convertToUnit(axis: axis, angle: r)
        XCTAssertTrue(Quaternions.isUnit(length: Quaternions.convertToUnit(axis: axis, angle: r).length))
    }
    
    func testConvertToUnit() throws {
        let axis = simd_double3(x: -2,
                                y: 1,
                                z: 0.5)
        XCTAssertEqual(Quaternions.convertToUnit(axis: axis, angle: .pi).length, 1.0)
    }
}
