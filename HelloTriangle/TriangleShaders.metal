//
//  TriangleShaders.metal
//  HelloTriangle
//
//  Created by Csaba Pap on 2021. 11. 28..
//

#include <metal_stdlib>
using namespace metal;

vertex float4 base_vertex_function(device float3 *vertices [[ buffer(0)]],
                                   uint vertexId [[vertex_id]]) {
    return float4(vertices[vertexId], 1);
}

fragment half4 base_fragment_function() {
    return half4(1);
}

