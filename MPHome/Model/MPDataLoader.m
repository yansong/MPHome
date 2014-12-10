//
//  MPDataLoader.m
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "MPDataLoader.h"
#import "Artwork.h"
#import <LoremIpsum/LoremIpsum.h>

@implementation MPDataLoader

+ (instancetype)sharedInstance {
    static MPDataLoader* _sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[MPDataLoader alloc]init];
    });
    return _sharedInstance;
}

- (NSMutableArray *)loadData:(int)count {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        // random width and height between 400 and 1200, multiplied by 10
        NSInteger width = 40 + arc4random_uniform(800);
        NSInteger height = 40 +arc4random_uniform(800);
        NSString *name = [LoremIpsum title];
        Artwork *artwork = [[Artwork alloc]initWithName:name width:width height:height];
        artwork.imageUrlString = [[LoremIpsum URLForPlaceholderImageWithSize:CGSizeMake(width, height)] absoluteString];
        
        [data addObject:artwork];
    }
    return data;
}

@end
