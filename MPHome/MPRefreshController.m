//
//  MPRefreshController.m
//  MPHome
//
//  Created by oasis on 12/29/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPRefreshController.h"

@interface MPRefreshController()

@property (nonatomic, weak) id<MPRefreshControllerDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation MPRefreshController

- (instancetype)initWithScrollView:(UIScrollView *)scrollView viewDelegate:(id <MPRefreshControllerDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.scrollView = scrollView;
        [self setup];
    }
    return self;
}

- (void)setup {
    
}

- (void)configurateObserverWithScrollView:(UIScrollView *)scrollView {
    
}

@end
