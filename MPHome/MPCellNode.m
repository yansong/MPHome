//
//  MPCellNode.m
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPCellNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface MPCellNode ()
{
    Artwork *_artwork;
    ASNetworkImageNode *_imageNode;
    ASTextNode *_textNode;
}
@end

@implementation MPCellNode

- (instancetype)initWithArtwork:(Artwork *)artwork {
    if (!(self = [super init]))
        return nil;
    
    _artwork = artwork;
    _imageNode = [[ASNetworkImageNode alloc]init];
    _imageNode.backgroundColor = [UIColor purpleColor];
    _imageNode.URL = [NSURL URLWithString:artwork.imageUrlString];
    NSLog(@"Fetching image from %@", artwork.imageUrlString);
    [self addSubnode:_imageNode];
    
    _textNode = [[ASTextNode alloc]init];
    NSLog(@"title is %@", artwork.name);
    _textNode.attributedString = [[NSAttributedString alloc]initWithString:artwork.name attributes:[self textStyle]];
    [self addSubnode:_textNode];
    return self;
}

- (NSDictionary *)textStyle {
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12.0f];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.paragraphSpacing = 0.5 * font.lineHeight;
    style.hyphenationFactor = 1.0;
    
    return @{NSFontAttributeName: font,
             NSParagraphStyleAttributeName: style };
}

#pragma mark - ASDisplayNode overrides
- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize imageSize = CGSizeMake(_artwork.width, _artwork.height);
    CGSize textSize = CGSizeMake(300, 20);
    
    return CGSizeMake(constrainedSize.width, imageSize.height + textSize.height);
}

- (void)layout {
    NSLog(@"layout called");
    _imageNode.frame = CGRectMake(0, 0, _artwork.width, _artwork.height);
    _textNode.frame = CGRectMake(0, _artwork.height, 300, 20);
}

@end
