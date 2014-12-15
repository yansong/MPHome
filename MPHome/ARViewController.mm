//
//  ARViewController.m
//  MPHome
//
//  Created by oasis on 12/15/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "ARViewController.h"
#import <QCAR/Area.h>


@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDismissButton];
}

- (void)addDismissButton {
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
    dismissButton.translatesAutoresizingMaskIntoConstraints = NO;
    dismissButton.tintColor = [UIColor whiteColor];
    
    dismissButton.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    UIImage *buttonImage = [UIImage imageNamed:@"btnClose"];
    [dismissButton setImage:buttonImage forState:UIControlStateNormal];
    [dismissButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    dismissButton.layer.cornerRadius = 6;
    dismissButton.clipsToBounds = YES;
    [dismissButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
    
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"H:[dismissButton]-20-|"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
    [self.view addConstraints:[NSLayoutConstraint
                               constraintsWithVisualFormat:@"V:|-25-[dismissButton]"
                               options:0
                               metrics:nil
                               views:NSDictionaryOfVariableBindings(dismissButton)]];
}

- (void)dismiss:(id)sender
{
    if (_delegate) {
        [_delegate didDismissARViewController];
    }
    else {
        [self dismissViewControllerAnimated:NO completion:NULL];
    }
}


@end
