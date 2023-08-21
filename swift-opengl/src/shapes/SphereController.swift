//
//  SphereController.swift
//  swift-opengl
//
//  Created by Jerome Bach on 14/08/2023.
//

import Foundation
import GLKit

class SphereController: ViewController {
    
    var Vertices: [Vertex] = []
    
    var Indices: [GLubyte] = []
    
    override func viewDidLoad() {
        self.solidSphereC(radius: 1, slice: 16, stack: 8)
        
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

    private func tableau(_ slice: Int, _ stack: Int, _ tabSinPhi: inout [GLfloat], _ tabCosPhi: inout [GLfloat], _ tabCosTheta: inout [GLfloat], _ tabSinTheta: inout [GLfloat]) {
        var phi: GLfloat = 0
        var theta: GLfloat = 0
        let incrPhi: GLfloat =  2.0 * GLfloat.pi / Float(slice)
        let incrTheta: GLfloat = GLfloat.pi / Float(stack)
        
        for i in 0..<(slice+1) {
            tabSinPhi[i] = sin(phi)
            tabCosPhi[i] = cos(phi)
            phi = phi + incrPhi
        }
        for i in 0..<(stack+1) {
            tabSinTheta[i] = sin(theta)
            tabCosTheta[i] = cos(theta)
            theta = theta + incrTheta
        }
    }
    
    private func solidSphereC(radius: GLfloat, slice: Int, stack: Int) {
        var x, xs, y, ys, z, zs: GLfloat
        var tabSinPhi: [GLfloat] = Array(repeating: 0.0, count: slice + 1)
        var tabCosPhi: [GLfloat] = Array(repeating: 0.0, count: slice + 1)
        var tabSinTheta: [GLfloat] = Array(repeating: 0.0, count: stack + 1)
        var tabCosTheta: [GLfloat] = Array(repeating: 0.0, count: stack + 1)
        self.tableau(slice, stack, &tabSinPhi, &tabCosPhi, &tabCosTheta, &tabSinTheta)

        for i in 0..<stack {
            // glBegin(GL_QUAD_STRIP);
            for j in 0..<slice {
                x = tabSinTheta[i]*tabSinPhi[j];
                y = tabSinTheta[i]*tabCosPhi[j];
                z = tabCosTheta[i];
                xs = tabSinTheta[i+1]*tabSinPhi[j];
                ys = tabSinTheta[i+1]*tabCosPhi[j];
                zs = tabCosTheta[i+1];
                glNormal3f(x,y,z);
                self.Vertices.append(Vertex(x: radius * x, y: radius * y, z: radius * z, r: 0, g: 0, b: 0, a: 1))
                self.Indices.append(GLubyte(self.Vertices.count - 1))
                glNormal3f(xs,ys,zs);
                self.Vertices.append(Vertex(x: radius * xs, y: radius * ys, z: radius * zs, r: 1, g: 0, b: 0, a: 1))
                self.Indices.append(GLubyte(self.Vertices.count - 1))
            }
            // glEnd()
        }
    }
}
