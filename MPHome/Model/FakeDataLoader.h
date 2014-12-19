//
//  FakeDataLoader.h
//  MPHome
//
//  Created by oasis on 12/19/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDataLoaderProtocol.h"

@interface FakeDataLoader : NSObject<MPDataLoaderProtocol>

+ (instancetype)sharedInstance;

@end
