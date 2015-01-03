//
//  MPGLShaderUtils.h
//  MPHome
//
//  Created by oasis on 12/18/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPGLShaderUtils : NSObject

+ (int)createProgramWithVertexShaderFileName:(NSString*) vertexShaderFileName
                      fragmentShaderFileName:(NSString*) fragmentShaderFileName;

+ (int)createProgramWithVertexShaderFileName:(NSString*) vertexShaderFileName
                        withVertexShaderDefs:(NSString *) vertexShaderDefs
                      fragmentShaderFileName:(NSString *) fragmentShaderFileName
                      withFragmentShaderDefs:(NSString *) fragmentShaderDefs;

@end
