//
//  TriangleView.swift
//  HelloTriangle
//
//  Created by Csaba Pap on 2021. 11. 28..
//

import Foundation
import MetalKit

public typealias float3 = SIMD3<Float>

class TriangleView: MTKView {
    
    var commandQueue: MTLCommandQueue!
    var renderPipelineState: MTLRenderPipelineState!
    
    var buffer: MTLBuffer!

    let vertices: [float3] = [
        float3(0, 1, 0),
        float3(-1, -1, 0),
        float3(1, -1, 0)
    ]
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        self.clearColor = MTLClearColor(red: 0.4, green: 0.8, blue: 0.4, alpha: 1)
        self.colorPixelFormat = .bgra8Unorm
        
        self.commandQueue = device?.makeCommandQueue()
        
        createPipelineState()
        
        createBuffers()
    }
    
    func createPipelineState() {
        let library = device?.makeDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: "base_vertex_function")
        let fragmentFunction = library?.makeFunction(name: "base_fragment_function")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        do {
            try renderPipelineState = device?.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func createBuffers() {
        buffer = device?.makeBuffer(bytes: vertices, length: MemoryLayout<float3>.stride * vertices.count, options: [])
    }
    
    
    override func draw(_ dirtyRect: NSRect) {
        guard let drawable = self.currentDrawable, let renderPassDescriptor = self.currentRenderPassDescriptor else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        commandEncoder?.setVertexBuffer(buffer, offset: 0, index: 0)
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        commandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
}
