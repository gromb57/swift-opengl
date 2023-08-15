//
//  PyramidController.swift
//  swift-opengl
//
//  Created by Jerome Bach on 15/08/2023.
//

import Foundation
import GLKit

class PyramidController: ViewController {
    
    var Vertices: [Vertex] = [
        Vertex(x:  -1, y: 0, z: -1, r: 1, g: 0, b: 0, a: 1),
        Vertex(x:  -1, y:  0, z: 1, r: 0, g: 1, b: 0, a: 1),
        Vertex(x: 1, y:  0, z: 1, r: 0, g: 0, b: 1, a: 1),
        Vertex(x: 1, y: 0, z: -1, r: 0, g: 0, b: 0, a: 1),
        Vertex(x: 0, y: 1, z: 0, r: 0, g: 0, b: 0, a: 1),
    ]
    
    var Indices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0,
        0, 3, 4,
        0, 1, 4,
        1, 2, 4,
        2, 3, 4
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isPerspective = false
        self.isRotatingOnX = false
        self.isRotatingOnY = false
        self.isRotatingOnZ = false
    }
    
    override func setupGL() {
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

