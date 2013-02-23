//
//  SetCard.m
//  Matchismo
//
//  Created by Owen Medd on 2/19/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents
{
    NSString *symbol = @"";
    for (int i = 0; i < self.rank; i++) {
        symbol = [symbol stringByAppendingString:self.suit];
    }
    
    return symbol;
}

- (MatchInfo *)match:(NSArray *)otherCards
{
    MatchInfo *matchInfo = [[MatchInfo alloc] init];
    int score = 0;
    
    matchInfo.matchType = MATCH_NONE;
    [matchInfo.cardsConsidered addObject:self];
    [matchInfo.cardsConsidered addObjectsFromArray:otherCards];
    
    // base card always "matches"
    int numberMatchCount = 1; // overload "rank"
    int symbolMatchCount = 1; // overload "suit"
    int shadingMatchCount = 1;
    int colorMatchCount = 1;
    
    for (SetCard *otherCard in otherCards) {
        if ([otherCard.suit isEqualToString:self.suit]) {
            symbolMatchCount++;
        }
        if (otherCard.rank == self.rank) {
            numberMatchCount++;
        }
        if (otherCard.color == self.color) {
            colorMatchCount++;
        }
        if (otherCard.shading == self.shading) {
            shadingMatchCount++;
        }
    }
    
    int maxMatchCount = [otherCards count] + 1;
    
    if (symbolMatchCount == maxMatchCount) {
        matchInfo.matchType = MATCH_SYMBOL;
        score = maxMatchCount;
    } else if (numberMatchCount == maxMatchCount) {
        matchInfo.matchType = MATCH_NUMBER;
        score = maxMatchCount;
    } else if (colorMatchCount == maxMatchCount) {
        matchInfo.matchType = MATCH_COLOR;
        score = maxMatchCount;
    } else if (shadingMatchCount == maxMatchCount) {
        matchInfo.matchType = MATCH_SHADING;
        score = maxMatchCount;
    }
    
    if (matchInfo.matchType != MATCH_NONE) {
        [matchInfo.matches addObject:self];
        [matchInfo.matches addObjectsFromArray:otherCards];
    }
    
    matchInfo.score = score;
    
    return matchInfo;
}

+ (NSArray *)validSuits
{
    static NSArray *validSuits = nil;
    if (!validSuits) validSuits = @[@"▲", @"●", @"■"];
    return validSuits;
}

+ (NSArray *)rankStrings
{
    static NSArray *rankStrings = nil;
    if (!rankStrings) rankStrings = @[@"?", @"1", @"2", @"3"];
    return rankStrings;
}

+ (NSArray *)colorStrings
{
    static NSArray *colorStrings = nil;
    if (!colorStrings) colorStrings = @[@"?", @"1", @"2", @"3"];
    return colorStrings;
}

+ (NSUInteger)maxColor { return [[self colorStrings] count] - 1; }

- (void)setColor:(NSUInteger)color
{
    if (color <= [[self class] maxColor]) {
        _color = color;
    }
}

+ (NSArray *)shadingStrings
{
    static NSArray *shadingStrings = nil;
    if (!shadingStrings) shadingStrings = @[@"?", @"1", @"2", @"3"];
    return shadingStrings;
}

+ (NSUInteger)maxShading { return [[self shadingStrings] count] - 1; }

- (void)setShading:(NSUInteger)shading
{
    if (shading <= [[self class] maxShading]) {
        _shading = shading;
    }
}
@end
