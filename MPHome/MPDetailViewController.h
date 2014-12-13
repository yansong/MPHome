//
//  MPDetailViewController.h
//  MPHome
//
//  Created by oasis on 12/11/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewControllerDelegate <NSObject>

- (void)didDismissDetailViewController;

@end

@interface MPDetailViewController : UIViewController

@property (nonatomic, weak) id<DetailViewControllerDelegate> delegate;
- (instancetype)initWithItemId:(NSString *)itemId;

@end
