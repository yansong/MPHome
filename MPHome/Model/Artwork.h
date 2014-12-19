//
//  Artwork.h
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artwork : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *artworkId;
@property NSInteger width;          // artwork width in mm
@property NSInteger height;         // artwork height in mm
@property (nonatomic, strong) NSString *artistName;
@property (nonatomic, strong) NSString *createYear;
@property (nonatomic, strong) NSString *theDescription;
@property (nonatomic, strong) NSString *thumbnailUrlString;
@property (nonatomic, strong) NSString *featureUrlString;
@property (nonatomic, strong) NSString *medium;
@property (nonatomic, strong) NSString *artType;
@property (nonatomic, strong) NSString *currentLocation;

- (instancetype)initWithName:(NSString *)name width:(NSInteger)width height:(NSInteger)height;

@end
