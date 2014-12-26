//
//  NSAttributedString+ThemeStrings.h
//  MPHome
//
//  Created by oasis on 12/25/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (ThemeStrings)

+ (NSAttributedString *)attrStringForTitle:(NSString *)text;
+ (NSAttributedString *)attrStringForSubtitle:(NSString *)text;
+ (NSAttributedString *)attrStringForContent:(NSString *)text;

@end
