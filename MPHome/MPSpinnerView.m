//
//  MPSpinnerView.m
//  LoadingAnim
//
//  Created by oasis on 12/26/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPSpinnerView.h"
const CGFloat kImageWidth = 34.0;
const CGFloat kImageHeight = 34.0;

@interface MPSpinnerView()
{
    UIImageView *_spinner;
}
@end

@implementation MPSpinnerView

- (instancetype)initWithImage:(UIImage *)image Frame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }

    CGRect rect = CGRectMake(frame.origin.x + frame.size.width / 2.0 - kImageWidth / 2.0,
                             frame.origin.y + frame.size.height / 2.0 - kImageHeight / 2.0, kImageWidth, kImageHeight);
    _spinner = [[UIImageView alloc]initWithFrame:rect];
    _spinner.image = image;
    [self addSubview:_spinner];
    [self rotateSpinner];
    
    return self;
}

- (void)rotateSpinner {
    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [_spinner setTransform:CGAffineTransformRotate(_spinner.transform, M_PI)];
    } completion:^(BOOL finished) {
        if (finished) {
            [self rotateSpinner];
        }
    }];

}

@end
