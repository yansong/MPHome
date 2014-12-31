//
//  PFDataLoader.h
//  MPHome
//
//  Created by oasis on 12/22/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDataLoaderProtocol.h"

@interface PFDataLoader : NSObject<MPDataLoaderProtocol>

+ (instancetype)sharedInstance;
@property (readonly) NSInteger itemsPerRequest;

@end
