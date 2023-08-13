//
//  ViewController.swift
//  swift-opengl
//
//  Created by Jerome Bach on 09/08/2023.
//

import Foundation
import UIKit
import GLKit

class ViewController: GLKViewController {
    var context: EAGLContext?
    
    var Vertices = [
        Vertex(x:  1, y: -1, z: 0, r: 1, g: 0, b: 0, a: 1),
        Vertex(x:  1, y:  1, z: 0, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: -1, y:  1, z: 0, r: 0, g: 0, b: 1, a: 1),
        Vertex(x: -1, y: -1, z: 0, r: 0, g: 0, b: 0, a: 1),
    ]
    
    var Indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]
    
    var ebo = GLuint()
    var vbo = GLuint()
    var vao = GLuint()
    
    var effect = GLKBaseEffect()
    
    var isPerspective: Bool = true
    
    var isRotating: Bool = false
    var rotation: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGL()
        self.setupContextMenu()
    }
    
    deinit {
        self.tearDownGL()
    }
}
