//
//  MPDataLoaderProtocol.h
//  MPHome
//
//  Created by oasis on 12/19/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artwork.h"

@protocol MPDataLoaderProtocol <NSObject>

@required

// returns detailed artwork information
- (Artwork *)getArtworkDetail:(NSString *)artworkId;

// get brief artwork list
- (NSMutableArray *)listArtworks;

// get a range of artworks
- (NSMutableArray *)listArtworks:(NSInteger)start end:(NSInteger)end;

@optional

- (NSInteger)artworkTotal;

- (NSMutableArray *)listArtworks:(NSInteger)count;

@end
