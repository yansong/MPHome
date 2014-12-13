//
//  MPDetailViewController.m
//  MPHome
//
//  Created by oasis on 12/11/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPDetailViewController.h"
#import "Artwork.h"
#import "MPDataLoader.h"

@interface MPDetailViewController()
{
    Artwork* _artwork;
    UIScrollView *_scrollview;
}
@end

@implementation MPDetailViewController

- (instancetype)initWithItemId:(NSString *)itemId{
    if (!(self = [super init]))
        return nil;
    _artwork = [[MPDataLoader sharedInstance]loadDataById:itemId];
    CGRect fullscreenRect = [[UIScreen mainScreen]applicationFrame];
    _scrollview = [[UIScrollView alloc] initWithFrame:fullscreenRect];
    _scrollview.contentSize = CGSizeMake(320, 758);
    _scrollview.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:_scrollview];
    [self addDismissButton];
    return self;
}

- (void)addDismissButton {
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor whiteColor];
    dismissButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:dismissButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f
                                                           constant:0.f]];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:[dismissButton]-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
}

- (void)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:NULL];
}


@end
