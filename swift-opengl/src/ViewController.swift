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
    
    var ebo = GLuint()
    var vbo = GLuint()
    var vao = GLuint()
    
    var effect = GLKBaseEffect()
    
    var isPerspective: Bool = true
    
    var isRotatingOnX: Bool = false
    var isRotatingOnY: Bool = false
    var isRotatingOnZ: Bool = false
    var rotation: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGL()
        self.setupContextMenu()
    }
    
    deinit {
        self.tearDownGL()
    }
    
    // MARK: Methods
    func setupGL() {
        // implements in subclasses
    }
}
