//
//  TextFormatter.m
//  MPHome
//
//  Created by oasis on 12/13/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "TextFormatter.h"


@implementation TextFormatter

+ (NSAttributedString *)formatTextForTitle:(NSString *)title Content:(NSString *)content {
    NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\r%@", title, content]];
    [infoString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    UIFont *titleFont = [UIFont fontWithName:@"Apple SD Gothic Neo" size:18.0f];
    
    [infoString addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, title.length)];
    [infoString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(title.length + 1, content.length)];
    
    return [infoString copy];
}

+ (CGFloat)heightForText:(NSAttributedString *)text Width:(CGFloat)width{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}
@end
