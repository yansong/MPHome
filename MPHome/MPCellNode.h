//
//  MPCellNode.h
//  MPHome
//
//  Created by oasis on 12/10/14.
//  Copyright (c) 2014 watchpup. All rights reserved.
//

#import "ASCellNode.h"
#import "Artwork.h"

@interface MPCellNode : ASCellNode

- (instancetype)initWithArtwork: (Artwork *)artwork;
- (void)buildCellWithArtwork:(Artwork *)artwork;

@end
