//
//  MPCellNode.m
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPCellNode.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import "TextFormatter.h"

@interface MPCellNode ()
{
    Artwork *_artwork;
    ASNetworkImageNode *_imageNode;
    ASTextNode *_textNode;
    
    CGSize _cellSize;
}
@end

@implementation MPCellNode

- (instancetype)initWithArtwork:(Artwork *)artwork {
    if (!(self = [super init]))
        return nil;
    
    _artwork = artwork;
    _imageNode = [[ASNetworkImageNode alloc]init];
    _imageNode.backgroundColor = [UIColor colorWithRed:0xe0/255.0 green:0xe0/255.0 blue:0xe0/255.0 alpha:1.0];

    _imageNode.URL = [NSURL URLWithString:artwork.imageUrlString];
    NSLog(@"Fetching image from %@", artwork.imageUrlString);
    [self addSubnode:_imageNode];
    
    _textNode = [[ASTextNode alloc]init];
    NSLog(@"title is %@", artwork.name);
    _textNode.attributedString = [TextFormatter formatTextForTitle:artwork.name Content:artwork.artist];
    _textNode.backgroundColor = [UIColor whiteColor];
    [self addSubnode:_textNode];
    return self;
}

#pragma mark - ASDisplayNode overrides
- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    _cellSize = constrainedSize;
    CGSize textSize = CGSizeMake(constrainedSize.width, 60);
    
    return CGSizeMake(constrainedSize.width, (float)_artwork.height/_artwork.width * _cellSize.width + textSize.height);
}

- (void)layout {
    NSLog(@"layout called");
    _imageNode.frame = CGRectMake(0, 0, _cellSize.width, (float)_artwork.height/_artwork.width * _cellSize.width);
    //CGSize textSize = _textNode.calculatedSize;
    _textNode.frame = CGRectMake(0, _imageNode.frame.size.height, _cellSize.width, 60);
}

@end
