//
//  MPDataLoaderProtocol.h
//  MPHome
//
//  Created by oasis on 12/19/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Artwork.h"

typedef void (^ArtworkResultBlock)(Artwork *artwork, NSError *error);
typedef void (^ArtworksResultBlock)(NSMutableArray *artworks, NSError *error);

@protocol MPDataLoaderProtocol <NSObject>

@required

// get detailed artwork information async
- (void)getArtworkDetail:(NSString *)artworkId completion:(ArtworkResultBlock)completion;

// get brief artwork list async
- (void)getArtworksWithCompletion:(ArtworksResultBlock)completion;

@optional

// sync versions
- (Artwork *)getArtworkDetail:(NSString *)artworkId;
- (NSMutableArray *)getArtworks;
- (NSInteger)artworkTotal;
- (NSMutableArray *)getArtworks:(NSInteger)count;
- (NSMutableArray *)getArtworks:(NSInteger)start end:(NSInteger)end;

@end
