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

- (instancetype)initWithPFObject:(PFObject *)obj {
    if (!(self = [super init]))
        return nil;
    
    self.title = [obj objectForKey:@"title"];
    self.thumbnailUrlString = [obj objectForKey:@"thumbnail_url"];
    self.featureUrlString = [obj objectForKey:@"feature_url"];
    self.artistName = [obj objectForKey:@"artist"];
    self.width = [[obj objectForKey:@"width"] intValue];
    self.height = [[obj objectForKey:@"height"] intValue];
    self.artworkId = [obj objectForKey:@"uid"];
    self.theDescription = [obj objectForKey:@"description"];
    return self;
}

@end
