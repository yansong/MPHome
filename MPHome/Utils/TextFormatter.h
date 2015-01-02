//
//  TextFormatter.h
//  MPHome
//
//  Created by oasis on 12/13/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TextFormatter : NSObject

+ (NSAttributedString *)formatTextForTitle:(NSString *)title Content:(NSString *)content;
+ (CGFloat)heightForText:(NSAttributedString *)text Width:(CGFloat)width;
+ (NSAttributedString *)formatHelpText:(NSString *)text;

@end
