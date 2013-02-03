//
//  Card.m
//  Matchismo
//
//  Created by Owen Medd on 1/30/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "Card.h"

@implementation Card

- (MatchInfo *)match:(NSArray *)otherCards
{
    MatchInfo *matchInfo = [[MatchInfo alloc] init];
    int score = 0;
    
    [matchInfo.cardsConsidered addObject:self];
    
    for (Card *card in otherCards) {
        [matchInfo.cardsConsidered addObject:card];
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
            [matchInfo.matches addObject:card];
        }
    }
    
    if (score) {
        [matchInfo.matches addObject:self];
    }
    
    matchInfo.score = score;
    
    return matchInfo;
}

@end
