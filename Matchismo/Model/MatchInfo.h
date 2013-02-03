//
//  MatchInfo.h
//  Matchismo
//
//  Created by Owen Medd on 2/2/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MatchInfo : NSObject

typedef enum {
    FLIPPED_UP,
    FLIPPED_DOWN,
    MATCH_NONE,
    MATCH_SUIT,
    MATCH_RANK
} MATCH_TYPE;

@property (nonatomic) MATCH_TYPE matchType;
@property (strong, nonatomic) NSMutableArray *cardsConsidered; // of Card
@property (strong, nonatomic) NSMutableArray *matches; // of Card
@property (nonatomic) int score;

@end
