//
//  ViewController+OpenGL.swift
//  swift-opengl
//
//  Created by Jerome Bach on 13/08/2023.
//

import Foundation
import GLKit

extension ViewController {
    func setupGL() {
        // 1
        context = EAGLContext(api: .openGLES3)
        // 2
        EAGLContext.setCurrent(context)
        
        if let view = self.view as? GLKView, let context = context {
            // 3
            view.context = context
            // 4
            delegate = self
        }
        
        //
        //
        //
        
        // 1
        let vertexAttribColor = GLuint(GLKVertexAttrib.color.rawValue)
        // 2
        let vertexAttribPosition = GLuint(GLKVertexAttrib.position.rawValue)
        // 3
        let vertexSize = MemoryLayout<Vertex>.stride
        // 4
        let colorOffset = MemoryLayout<GLfloat>.stride * 3
        // 5
        let colorOffsetPointer = UnsafeRawPointer(bitPattern: colorOffset)
        
        //
        //
        //
        
        // 1
        glGenVertexArraysOES(1, &vao)
        // 2
        glBindVertexArrayOES(vao)
        
        //
        //
        //
        
        glGenBuffers(1, &vbo)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vbo)
        glBufferData(GLenum(GL_ARRAY_BUFFER), // 1
                     Vertices.size(),         // 2
                     Vertices,                // 3
                     GLenum(GL_STATIC_DRAW))  // 4
        
        //
        //
        //
        glEnableVertexAttribArray(vertexAttribPosition)
        glVertexAttribPointer(vertexAttribPosition,       // 1
                              3,                          // 2
                              GLenum(GL_FLOAT),           // 3
                              GLboolean(UInt8(GL_FALSE)), // 4
                              GLsizei(vertexSize),        // 5
                              nil)                        // 6
            
        glEnableVertexAttribArray(vertexAttribColor)
        glVertexAttribPointer(vertexAttribColor,
                              4,
                              GLenum(GL_FLOAT),
                              GLboolean(UInt8(GL_FALSE)),
                              GLsizei(vertexSize),
                              colorOffsetPointer)
        
        //
        //
        //
        
        glGenBuffers(1, &ebo)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), ebo)
        glBufferData(GLenum(GL_ELEMENT_ARRAY_BUFFER),
                     Indices.size(),
                     Indices,
                     GLenum(GL_STATIC_DRAW))
        
        //
        //
        //
        
        glBindVertexArrayOES(0)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), 0)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), 0)
    }
    
    func tearDownGL() {
        EAGLContext.setCurrent(context)

        glDeleteBuffers(1, &vao)
        glDeleteBuffers(1, &vbo)
        glDeleteBuffers(1, &ebo)
            
        EAGLContext.setCurrent(nil)
            
        context = nil
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // 1
        glClearColor(0.85, 0.85, 0.85, 1.0)
        // 2
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        //
        //
        //
        
        effect.prepareToDraw()
        
        //
        //
        //
        
        glBindVertexArrayOES(vao);
        glDrawElements(GLenum(GL_TRIANGLES),     // 1
                       GLsizei(Indices.count),   // 2
                       GLenum(GL_UNSIGNED_BYTE), // 3
                       nil)                      // 4
        glBindVertexArrayOES(0)
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
