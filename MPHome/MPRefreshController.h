//
//  MPRefreshController.h
//  MPHome
//
//  Created by oasis on 12/29/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MPRefreshControllerDelegate <NSObject>

@required
- (void)beginPullUpLoading;

@end

@interface MPRefreshController : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView viewDelegate:(id <MPRefreshControllerDelegate>)delegate;

@end
