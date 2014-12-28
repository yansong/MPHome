//
//  TextFormatter.m
//  MPHome
//
//  Created by oasis on 12/13/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "TextFormatter.h"
#import "UIColor+ThemeColors.h"


@implementation TextFormatter

+ (NSAttributedString *)formatTextForTitle:(NSString *)title Content:(NSString *)content {
    NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\r%@", title, content]];
    UIFont *titleFont = [UIFont fontWithName:@"Apple SD Gothic Neo" size:16.0f];
    [infoString addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, title.length)];
    [infoString addAttribute:NSForegroundColorAttributeName value:[UIColor titleColor] range:NSMakeRange(0, title.length)];
    
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.3 * titleFont.lineHeight;
    style.hyphenationFactor = 1.0;
    
    [infoString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, infoString.length)];
    
    UIFont *contentFont = [UIFont fontWithName:@"Apple SD Gothic Neo" size:14.0f];
    [infoString addAttribute:NSFontAttributeName value:contentFont range:NSMakeRange(title.length + 1, content.length)];
    [infoString addAttribute:NSForegroundColorAttributeName value:[UIColor subtitleColor] range:NSMakeRange(title.length + 1, content.length)];
    
    return [infoString copy];
}

+ (CGFloat)heightForText:(NSAttributedString *)text Width:(CGFloat)width{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}
@end
