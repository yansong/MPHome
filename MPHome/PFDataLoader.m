//
//  PFDataLoader.m
//  MPHome
//
//  Created by oasis on 12/22/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "PFDataLoader.h"
#import <Parse/Parse.h>

@implementation PFDataLoader

+ (instancetype)sharedInstance {
    static PFDataLoader* _sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PFDataLoader alloc]init];
        // set parse keys
        [Parse setApplicationId:@"SKAMXdtfD893Zkm7YyN2gbSouWFMJdjLtIJifw1c"
                      clientKey:@"UXpvzE96IrtMTOin9YISbfj2gdxGB3SUsSdEl0Qk"];
    });
    return _sharedInstance;
}

#pragma mark - MPDataLoaderProtocol
- (void)getArtworkDetail:(NSString *)artworkId completion:(ArtworkResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Artwork"];
    [query whereKey:@"uid" equalTo:artworkId];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        Artwork *artwork = [[Artwork alloc]initWithPFObject:object];
        completion(artwork, error);
    }];
}

- (void)getArtworksWithCompletion:(ArtworksResultBlock)completion {
    PFQuery *query = [PFQuery queryWithClassName:@"Artwork"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSLog(@"Successfully fetched %lu objects.", (unsigned long)objects.count);
            NSMutableArray *artworks = [[NSMutableArray alloc]init];
            for (PFObject *object in objects) {
                [artworks addObject:object];
            }
            completion(artworks, error);
        }
        else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
            completion(nil, error);
        }
    }];
}

@end
