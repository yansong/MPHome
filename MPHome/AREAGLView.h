//
//  AREAGLView.h
//  MPHome
//
//  Created by oasis on 12/16/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPARSession.h"

@interface AREAGLView : UIView

- (instancetype)initWithFrame:(CGRect)frame arSession:(MPARSession *)session;

- (void)setupArImage:(CGImageRef)image width:(NSInteger)width height:(NSInteger)height;
- (void)finishOpenGLESCommands;
- (void)freeOpenGLESResources;

@end
