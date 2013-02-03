//
//  MatchInfo.m
//  Matchismo
//
//  Created by Owen Medd on 2/2/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "MatchInfo.h"

@implementation MatchInfo

- (NSMutableArray *)cardsConsidered
{
    if (!_cardsConsidered) _cardsConsidered = [[NSMutableArray alloc] init];
    return _cardsConsidered;
}

- (NSMutableArray *)matches
{
    if (!_matches) _matches = [[NSMutableArray alloc] init];
    return _matches;
}

@end
