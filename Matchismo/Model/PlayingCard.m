//
//  PlayingCard.m
//  Matchismo
//
//  Created by Owen Medd on 1/30/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (MatchInfo *)match:(NSArray *)otherCards
{
    MatchInfo *matchInfo = [[MatchInfo alloc] init];
    int score = 0;
    
    matchInfo.matchType = MATCH_NONE;
    [matchInfo.cardsConsidered addObject:self];
    [matchInfo.cardsConsidered addObjectsFromArray:otherCards];
    
    int suitMatchCount = 1; // count base card as "matched"
    int rankMatchCount = 1; // count base card as "matched"
    for (PlayingCard *otherCard in otherCards) {
        if ([otherCard.suit isEqualToString:self.suit]) {
            suitMatchCount++;
        }
        if (otherCard.rank == self.rank) {
            rankMatchCount++;
        }
    }
    
    int maxMatchCount = otherCards.count + 1;
    
    if (rankMatchCount == maxMatchCount) { // 0.235% chance
        matchInfo.matchType = MATCH_RANK;
        score = 4 * maxMatchCount;
    } else if (suitMatchCount == maxMatchCount) { // 5% chance
        matchInfo.matchType = MATCH_SUIT;
        score = 3 * maxMatchCount;
    } else if (maxMatchCount > 2 && rankMatchCount == maxMatchCount-1) { // 17.9% chance
        matchInfo.matchType = MATCH_RANK;
        score = 2 * maxMatchCount;
    } else if (maxMatchCount > 2 && suitMatchCount == maxMatchCount-1) { // 71.5% chance
        matchInfo.matchType = MATCH_SUIT;
        score = 1 * maxMatchCount;
    }
    
    if (matchInfo.matchType != MATCH_NONE) {
        [matchInfo.matches addObject:self];
        for (PlayingCard *otherCard in otherCards) {
            if ((matchInfo.matchType == MATCH_RANK && self.rank == otherCard.rank) || (matchInfo.matchType == MATCH_SUIT && [self.suit isEqualToString:otherCard.suit])) {
                [matchInfo.matches addObject:otherCard];
            }
        }
    }
    matchInfo.score = score;
    
    return matchInfo;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
    return rankStrings;
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
