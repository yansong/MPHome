//
//  FakeDataLoader.m
//  MPHome
//
//  Created by oasis on 12/19/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "FakeDataLoader.h"
#import <LoremIpsum/LoremIpsum.h>

@implementation FakeDataLoader

+ (instancetype)sharedInstance {
    static FakeDataLoader* _sharedInstance = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[FakeDataLoader alloc]init];
    });
    return _sharedInstance;
}

- (Artwork *)getArtworkDetail:(NSString *)artworkId {
    Artwork *artwork = [[Artwork alloc]init];
    
    NSLog(@"Retrieving artwork id: %@", artworkId);
    artwork.artworkId = @"20141219001";
    artwork.title = @"The Sleeping Gypsy";
    artwork.artistName = @"Henri Rousseau";
    artwork.createYear = @"1897";
    artwork.theDescription = @"The Sleeping Gypsy (French: La Bohémienne endormie) is an 1897 oil painting by French Naïve artist Henri Rousseau. The fantastical depiction of a lion musing over a sleeping woman on a moonlit night is one of the most recognizable artworks of modern times.\nRousseau first exhibited the painting at the 13th Salon des Indépendants, and tried unsuccessfully to sell it to the mayor of his hometown, Laval. Instead, it entered the private collection of a Parisian charcoal merchant where it remained until 1924, when it was discovered by the art critic Louis Vauxcelles. The Paris-based art dealer Daniel-Henry Kahnweiler purchased the painting in 1924, although a controversy arose over whether the painting was a forgery. It was acquired by art historian Alfred H. Barr Jr. for the New York Museum of Modern Art.\nThe painting has served as inspiration for poetry and music, and has been altered and parodied by various artists often with the lion replaced by a dog or other animal. In the Simpsons episode \"Mom and Pop Art\" Homer dreams of waking up in the artwork with the lion licking his head. A print of the work appears in the movie \"The Apartment\" above the comatose Fran Kubelik.";
    artwork.width = 2007;
    artwork.height = 1295;
    artwork.thumbnailUrlString = @"http://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Henri_Rousseau_-_La_Boh%C3%A9mienne_endormie_-_Google_Art_Project.jpg/512px-Henri_Rousseau_-_La_Boh%C3%A9mienne_endormie_-_Google_Art_Project.jpg";
    artwork.featureUrlString = @"http://upload.wikimedia.org/wikipedia/commons/thumb/c/c5/Henri_Rousseau_-_La_Boh%C3%A9mienne_endormie_-_Google_Art_Project.jpg/2048px-Henri_Rousseau_-_La_Boh%C3%A9mienne_endormie_-_Google_Art_Project.jpg";
    artwork.medium = @"oil on canvas";
    artwork.currentLocation = @"Museum of Modern Art";
    
    return artwork;
}

- (void)getArtworkDetail:(NSString *)artworkId completion:(ArtworkResultBlock)completion {
    if (completion) {
        Artwork *artwork = [self getArtworkDetail:artworkId];
        completion(artwork, nil);
    }
}

- (NSMutableArray *)getArtworks:(NSInteger)start end:(NSInteger)end {
    NSMutableArray *data = [[NSMutableArray alloc] init];
    for (int i = 0; i < end - start; i++) {
        // random width and height between 400 and 1200, multiplied by 10
        NSInteger width = (40 + arc4random_uniform(80)) * 10;
        NSInteger height = (40 + arc4random_uniform(80)) * 10;
        NSString *name = [LoremIpsum title];
        Artwork *artwork = [[Artwork alloc]initWithName:name width:width height:height];
        artwork.artistName = [LoremIpsum name];
        artwork.thumbnailUrlString = [[LoremIpsum URLForPlaceholderImageWithSize:CGSizeMake(width, height)] absoluteString];
        
        [data addObject:artwork];
    }
    return data;
}

- (void)getArtworksWithCompletion:(ArtworksResultBlock)completion {
    if (completion) {
        NSMutableArray *data = [self getArtworks];
        completion(data, nil);
    }
}

- (NSMutableArray *)getArtworks {
    return [self getArtworks:20];
}

- (NSMutableArray *)getArtworks:(NSInteger)count {
    return [self getArtworks:0 end:count];
}

@end
