//
//  ViewController+OpenGL.swift
//  swift-opengl
//
//  Created by Jerome Bach on 13/08/2023.
//

import Foundation
import GLKit

extension ViewController {
    func tearDownGL() {
        EAGLContext.setCurrent(context)

        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
            
        EAGLContext.setCurrent(nil)
            
        context = nil
    }
}

extension ViewController: GLKViewControllerDelegate {
    func glkViewControllerUpdate(_ controller: GLKViewController) {

        // 1
        let aspect = fabsf(Float(view.bounds.size.width) / Float(view.bounds.size.height))
        // 2
        var projectionMatrix: GLKMatrix4
        
        if self.isPerspective {
            projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0), aspect, 4.0, 10.0)
            // 3
            effect.transform.projectionMatrix = projectionMatrix
        } else {
            effect.transform.projectionMatrix = GLKMatrix4Identity
        }
        
        //
        //
        //
        
        // 1  - perpective
        var modelViewMatrix: GLKMatrix4
        if self.isPerspective {
            modelViewMatrix = GLKMatrix4MakeTranslation(0.0, 0.0, -6.0)
        } else {
            modelViewMatrix = GLKMatrix4Identity
        }
        // 2
        if self.isRotating {
            rotation += 90 * Float(timeSinceLastUpdate)
            modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(rotation), 0, 0, 1)
        }
        // 3
        effect.transform.modelviewMatrix = modelViewMatrix
    }
}
