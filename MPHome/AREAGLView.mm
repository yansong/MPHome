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

@interface AREAGLView()<UIGLViewProtocol>
{
    EAGLContext *_context;
    
    // buffers used to render to this view
    GLuint defaultFramebuffer;
    GLuint colorRenderbuffer;
    GLuint depthRenderbuffer;
    
    // shader handles
    GLuint shaderProgramID;
    GLint vetextHandle;
    GLint normalHandle;
    GLint textureCoordHandle;
    GLint mvpMatrixHandle;
    GLint texSampler2DHandle;
}
@end

@implementation AREAGLView

// Implement this to ensure the view's underlying layer is of type CAEAGLLayer
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

#pragma mark - AR View life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super init]))
        return nil;
    
    // TODO: enable retina mode if available on the device
    
    // TODO: in sample code, load all textures (image data, width, height) here
    
    // Create OpenGL ES2 context
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    // The EAGLContext must be set for each thread that wishes to use it.
    // Set it the first time this method is called (on main thread)
    if (_context != [EAGLContext currentContext]) {
        [EAGLContext setCurrentContext:_context];
    }
    
    // TODO: in sample code, generates ES textures for use
    
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
- (void)renderFrameQCAR {
    [self setFramebuffer];
    
    // clear color and depth buffer
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // render video background and retrieve tracking state
    QCAR::State state = QCAR::Renderer::getInstance().begin();
    QCAR::Renderer::getInstance().drawVideoBackground();
    
    
    
    QCAR::Renderer::getInstance().end();
    [self presentFramebuffer];
}

#pragma mark - OpenGL ES management
- (void)initShaders {
    // TODO: initialize augmentation shader
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
    // ????
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

@end
