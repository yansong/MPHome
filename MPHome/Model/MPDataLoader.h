//
//  MPDataLoader.h
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPDataLoader : NSObject

+(instancetype)sharedInstance;

-(NSMutableArray *)loadData:(int)count;

@end
