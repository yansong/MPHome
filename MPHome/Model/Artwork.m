//
//  Artwork.m
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "Artwork.h"

@implementation Artwork

- (instancetype)initWithName:(NSString *)name width:(NSInteger)width height:(NSInteger)height {
    if (!(self = [super init]))
        return nil;
    
    _title = name;
    _width = width;
    _height = height;
    
    return self;
}

@end
