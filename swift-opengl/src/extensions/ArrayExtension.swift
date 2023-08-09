//
//  ArrayExtension.swift
//  swift-opengl
//
//  Created by Jerome Bach on 09/08/2023.
//

import Foundation

extension Array {
    func size() -> Int {
        return MemoryLayout<Element>.stride * self.count
    }
}
