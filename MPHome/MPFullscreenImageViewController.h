//
//  MPFullscreenImageViewController.h
//  MPHome
//
//  Created by oasis on 12/31/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MPFullscreenViewControllerDelegate <NSObject>

- (void)didDismissFullscreenViewController;

@end


@interface MPFullscreenImageViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, weak) id<MPFullscreenViewControllerDelegate> delegate;

- (instancetype)initWithImage:(UIImage *)image Width:(NSInteger)width Height:(NSInteger)height;

@end
