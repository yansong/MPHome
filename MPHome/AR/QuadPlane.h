//
//  QuadPlane.h
//  MPHome
//
//  Created by oasis on 12/18/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#ifndef MPHome_QuarPlane_h
#define MPHome_QuarPlane_h

#define NUM_QUAD_VERTEX 4
#define NUM_QUAD_INDEX 6


static const float quadVertices[NUM_QUAD_VERTEX * 3] =
{
    -1.00f,  -1.00f,  0.0f,
    1.00f,  -1.00f,  0.0f,
    1.00f,   1.00f,  0.0f,
    -1.00f,   1.00f,  0.0f,
};

static const float quadTexCoords[NUM_QUAD_VERTEX * 2] =
{
    0, 0,
    1, 0,
    1, 1,
    0, 1,
};

static const float quadNormals[NUM_QUAD_VERTEX * 3] =
{
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    0, 0, 1,
    
};

static const unsigned short quadIndices[NUM_QUAD_INDEX] =
{
    0,  1,  2,  0,  2,  3,
};


#endif
