//
//  UIColor+ThemeColors.m
//  MPHome
//
//  Created by oasis on 12/25/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "UIColor+ThemeColors.h"

@implementation UIColor (ThemeColors)
+ (UIColor *)titleColor {
    return [self colorWithRed:255 green:0xFF blue:255];
}

+ (UIColor *)subtitleColor {
    return [self colorWithRed:255 green:0xFF blue:255];
}

+ (UIColor *)contentTextColor {
    return [self colorWithRed:255 green:0xFF blue:255];
}

+ (UIColor *)colorWithRed:(NSUInteger)red
                    green:(NSUInteger)green
                     blue:(NSUInteger)blue
{
    return [UIColor colorWithRed:(float)(red/255.f)
                           green:(float)(green/255.f)
                            blue:(float)(blue/255.f)
                           alpha:1.f];
}

@end
