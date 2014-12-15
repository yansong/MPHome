//
//  ARViewController.h
//  MPHome
//
//  Created by oasis on 12/15/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ARViewControllerDelegate <NSObject>

- (void)didDismissARViewController;

@end


@interface ARViewController : UIViewController

@property (nonatomic, weak) id<ARViewControllerDelegate> delegate;

@end
