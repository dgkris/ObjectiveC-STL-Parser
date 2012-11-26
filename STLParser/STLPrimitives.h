//
//  STLPrimitives.h
//  STLParser
//
//  Created by Deepak G Krishnan on 25/11/12.
//  Copyright (c) 2012 dgkris@gmail.com. All rights reserved.
//

typedef struct {
    float x,y,z;
} Vertex;

typedef struct {
    float x,y,z;
} Normal;

typedef struct {
    Normal *normals;
    Vertex *vertices;
    int *indices;
    long verticesHandle,normalsHandle,indicesHandle;
} STLData;

