//
//  Artwork.h
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Artwork : NSObject

@property (nonatomic, strong) NSString *name;
@property NSInteger width;
@property NSInteger height;
@property (nonatomic, strong) NSString *theDescription;
@property (nonatomic, strong) NSString *thumbnailUrlString;
@property (nonatomic, strong) NSString *imageUrlString;

- (instancetype)initWithName:(NSString *)name width:(NSInteger)width height:(NSInteger)height;

@end
