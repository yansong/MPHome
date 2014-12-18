//
//  AREAGLView.m
//  MPHome
//
//  Created by oasis on 12/16/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "AREAGLView.h"
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

#import <QCAR/UIGLViewProtocol.h>
#import <QCAR/QCAR.h>
#import <QCAR/State.h>
#import <QCAR/Tool.h>
#import <QCAR/Renderer.h>
#import <QCAR/TrackableResult.h>
#import <QCAR/ImageTarget.h>
#import <QCAR/Trackable.h>
#import <QCAR/VideoBackgroundConfig.h>

#import "ARUtilities.h"
#import "MPGLShaderUtils.h"

#import "QuadPlane.h"

//******************************************************************************
// *** OpenGL ES thread safety ***
//
// OpenGL ES on iOS is not thread safe.  We ensure thread safety by following
// this procedure:
// 1) Create the OpenGL ES context on the main thread.
// 2) Start the QCAR camera, which causes QCAR to locate our EAGLView and start
//    the render thread.
// 3) QCAR calls our renderFrameQCAR method periodically on the render thread.
//    The first time this happens, the defaultFramebuffer does not exist, so it
//    is created with a call to createFramebuffer.  createFramebuffer is called
//    on the main thread in order to safely allocate the OpenGL ES storage,
//    which is shared with the drawable layer.  The render (background) thread
//    is blocked during the call to createFramebuffer, thus ensuring no
//    concurrent use of the OpenGL ES context.
//
//******************************************************************************

namespace {
    // --- Data private to this unit ---
    
    // Model scale factor
    const float kObjectScaleNormal = 3.0f;
}

@interface AREAGLView()<UIGLViewProtocol>
{
    EAGLContext *_context;
    
    // buffers used to render to this view
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    
    // shader handles
    GLuint shaderProgramID;
    GLint vertexHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
    GLint texSampler2DHandle;
    
    GLuint textureName;
    
    MPARSession* _arSession;
}

- (void)initShaders;
- (void)createFramebuffer;
- (void)deleteFramebuffer;
- (void)setFramebuffer;
- (BOOL)presentFramebuffer;

@end

@implementation AREAGLView

// Implement this to ensure the view's underlying layer is of type CAEAGLLayer
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#pragma mark - AR View life cycle
- (instancetype)initWithFrame:(CGRect)frame arSession:(MPARSession *)session{
    if (!(self = [super init]))
        return nil;
    
    _arSession = session;
    
    if (YES == [_arSession isRetinaDisplay]) {
        [self setContentScaleFactor:2.0f];
    }
    
    // TODO: in sample code, load all textures (image data, width, height) here
    
    // Create OpenGL ES2 context
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // The EAGLContext must be set for each thread that wishes to use it.
    // Set it the first time this method is called (on main thread)
    if (_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_context];
    }
    
    // TODO: in sample code, generates ES textures for use
    textureName = [self buildTexture];
    
    [self initShaders];
    
    return self;
}

- (void)dealloc {
    [self deleteFramebuffer];
    
    // Tear down context
    if ([EAGLContext currentContext] == _context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    // TODO: release augmentation texture
}

- (void)finishOpenGLESCommands {
    // Called in response to applicationWillResignActive.  The render loop has
    // been stopped, so we now make sure all OpenGL ES commands complete before
    // we (potentially) go into the background
    if (_context) {
        [EAGLContext setCurrentContext:_context];
        glFinish();
    }
}

- (void)freeOpenGLESResources {
    // Called in response to applicationDidEnterBackground.  Free easily
    // recreated OpenGL ES resources
    [self deleteFramebuffer];
    glFinish();
}

#pragma mark - UIGLViewProtocol
// MARK: render function
- (void)renderFrameQCAR {
    
    [self setFramebuffer];
    
    // clear color and depth buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
    // ???: what's this?
    glEnable(GL_DEPTH_TEST);
    // we must detect if background reflection is active and adjust the culling direction.
    glDisable(GL_CULL_FACE);
    glCullFace(GL_BACK);
    if (QCAR::Renderer::getInstance().getVideoBackgroundConfig().mReflection == QCAR::VIDEO_BACKGROUND_REFLECTION_ON)
        glFrontFace(GL_CW);     // front camera
    else
        glFrontFace(GL_CCW);    // back camera
    
    for (int i = 0; i < state.getNumTrackableResults(); i++) {
        // Get the trackable
        const QCAR::TrackableResult *result = state.getTrackableResult(i);
        const QCAR::Trackable &trackable = result->getTrackable();
        
        QCAR::Vec2F targetSize = ((QCAR::ImageTarget *)&trackable)->getSize();
        
        QCAR::Matrix44F modelViewMatrix = QCAR::Tool::convertPose2GLMatrix(result->getPose());
        QCAR::Matrix44F modelViewProjection;
        
        ARUtilities::translatePoseMatrix(0.0f, 0.0f, kObjectScaleNormal, &modelViewMatrix.data[0]);
        ARUtilities::scalePoseMatrix(targetSize.data[0], targetSize.data[1], 1.0f, &modelViewMatrix.data[0]);
        ARUtilities::multiplyMatrix(&_arSession.projectionMatrix.data[0], &modelViewMatrix.data[0], &modelViewProjection.data[0]);
        
        glUseProgram(shaderProgramID);
        
        glVertexAttribPointer(vertexHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)&quadVertices[0]);
        glVertexAttribPointer(normalHandle, 3, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)&quadNormals[0]);
        glVertexAttribPointer(textureCoordHandle, 2, GL_FLOAT, GL_FALSE, 0, (const GLvoid*)&quadTexCoords[0]);

        glEnableVertexAttribArray(vertexHandle);
        glEnableVertexAttribArray(normalHandle);
        glEnableVertexAttribArray(textureCoordHandle);
        
        glActiveTexture(GL_TEXTURE0);
        glBindTexture(GL_TEXTURE_2D, textureName);
        
        glUniformMatrix4fv(mvpMatrixHandle, 1, GL_FALSE, (GLfloat*)&modelViewProjection.data[0]);
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_SHORT, (const GLvoid *)&quadIndices[0]);
    }
    
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    
    glDisableVertexAttribArray(vertexHandle);
    glDisableVertexAttribArray(normalHandle);
    glDisableVertexAttribArray(textureCoordHandle);
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];
}

#pragma mark - OpenGL ES management
- (void)initShaders {
    shaderProgramID = [MPGLShaderUtils createProgramWithVertexShaderFileName:@"Simple.vertsh"
                                                      fragmentShaderFileName:@"Simple.fragsh"];
    if (0 < shaderProgramID) {
        vertexHandle = glGetAttribLocation(shaderProgramID, "vertexPosition");
        normalHandle = glGetAttribLocation(shaderProgramID, "vertexNormal");
        textureCoordHandle = glGetAttribLocation(shaderProgramID, "vertexTexCoord");
        mvpMatrixHandle = glGetUniformLocation(shaderProgramID, "modelViewProjectionMatrix");
        texSampler2DHandle = glGetUniformLocation(shaderProgramID, "texSampler2D");
    }
    else {
        NSLog(@"Could not initialize augmentation shader");
    }
}

- (void)createFramebuffer {
    if (_context) {
        // create default framebuffer object
        glGenFramebuffers(1, &defaultFramebuffer);
        glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
        
        // create color render buffer and allocate backing store
        glGenRenderbuffers(1, &colorRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
        
        // Allocate the renderbuffer's storage (shared with the drawable object)
        [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer*)self.layer];
        GLint framebufferWidth;
        GLint framebufferHeight;
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &framebufferWidth);
        glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &framebufferHeight);
        
        // Create the depth render buffer and allocate storage
        glGenRenderbuffers(1, &depthRenderbuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, depthRenderbuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, framebufferWidth, framebufferHeight);
        
        // Attach color and depth render buffer to the frame buffer
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderbuffer);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, depthRenderbuffer);
        
        // Leave the color render buffer bound so future rendering operations will act on it
        glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    }
}

- (void)deleteFramebuffer {
    if (_context) {
        [EAGLContext setCurrentContext:_context];
        
        
        if (defaultFramebuffer) {
            glDeleteFramebuffers(1, &defaultFramebuffer);
            defaultFramebuffer = 0;
        }
        
        if (colorRenderbuffer) {
            glDeleteRenderbuffers(1, &colorRenderbuffer);
            colorRenderbuffer = 0;
        }
        
        if (depthRenderbuffer) {
            glDeleteRenderbuffers(1, &depthRenderbuffer);
            depthRenderbuffer = 0;
        }
    }
}

- (void)setFramebuffer {
    // ??? what's this for?
    // The EAGLContext must be set for each thread that wishes to use it.
    // Set it the first time this method is called (on main thread)
    if (_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_context];
    }
    
    if (!defaultFramebuffer) {
        // Perform on the main thread to ensure safe memory allocation for the
        // shared buffer.  Block until the operation is complete to prevent
        // simultaneous access to the OpenGL context
        [self performSelectorOnMainThread:@selector(createFramebuffer) withObject:self waitUntilDone:YES];
    }
    
    glBindFramebuffer(GL_FRAMEBUFFER, defaultFramebuffer);
}

- (BOOL)presentFramebuffer {
    // setFramebuffer must have been called before presentFramebuffer, therefore
    // we know the context is valid and has been set for this (render) thread
    
    // Bind the colour render buffer and present it
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderbuffer);
    
    return [_context presentRenderbuffer:GL_RENDERBUFFER];
}

# pragma mark - Private funcs
- (GLuint)buildTexture {
    // get core graphics image reference
    CGImageRef textureImage = [[UIImage imageNamed:@"demoPic.png"] CGImage];
    if (!textureImage) {
        NSLog(@"Failed to load image.");
        exit(1);
    }
    
    // create core graphics bitmap context
    size_t width = CGImageGetWidth(textureImage);
    size_t height = CGImageGetHeight(textureImage);
    
    GLubyte *textureData = (GLubyte *)calloc(width * height * 4, sizeof(GLubyte));
    
    CGContextRef textureContext = CGBitmapContextCreate(textureData, width, height, 8, width * 4, CGImageGetColorSpace(textureImage), kCGImageAlphaPremultipliedLast);
    
    // draw the image into the context
    CGContextDrawImage(textureContext, CGRectMake(0, 0, width, height), textureImage);
    CGContextRelease(textureContext);
    
    // send pixel data to opengl
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, textureData);
    
    free(textureData);
    return texName;
}

@end
