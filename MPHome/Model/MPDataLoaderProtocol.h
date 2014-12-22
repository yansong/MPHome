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

// returns detailed artwork information
- (Artwork *)getArtworkDetail:(NSString *)artworkId;
- (void)getArtworkDetail:(NSString *)artworkId completion:(ArtworkResultBlock)completion;
//- (void)getArtworkDetail:(NSString *)artworkId completion:(void (^)(Artwork *artwork, NSError* error))completion;

// get brief artwork list
- (NSMutableArray *)getArtworks;
- (void)getArtworksWithCompletion:(ArtworksResultBlock)completion;

// get a range of artworks
- (NSMutableArray *)getArtworks:(NSInteger)start end:(NSInteger)end;

@optional

- (NSInteger)artworkTotal;

- (NSMutableArray *)getArtworks:(NSInteger)count;

@end
