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
    
    // string fields
    self.thumbnailUrlString = [obj objectForKey:@"thumbnail_url"];
    self.featureUrlString = [obj objectForKey:@"feature_url"];
    
    // int fields
    self.width = [[obj objectForKey:@"width"] intValue];
    self.height = [[obj objectForKey:@"height"] intValue];
    self.artworkId = [obj objectForKey:@"uid"];
    self.createYear = [obj objectForKey:@"year"];
    
    // multilingual fields
    self.title = [self dataForLocalizedField:@"title" Data:obj];
    self.artistName = [self dataForLocalizedField:@"artist" Data:obj];
    self.theDescription = [self dataForLocalizedField:@"description" Data:obj];
    return self;
}

- (NSString *)dataForLocalizedField:(NSString *)field Data:(PFObject *)data{
    PFObject *obj = [data objectForKey:field];

    return [obj objectForKey:[[NSLocale currentLocale]localeIdentifier]];
}

@end
