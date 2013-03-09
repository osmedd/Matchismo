//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Owen Medd on 1/31/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (nonatomic) int score;
@property (strong, nonatomic) MatchInfo *lastMatchInfo;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (int)cardsToMatch
{
    if (!_cardsToMatch) _cardsToMatch = 2;
    return _cardsToMatch;
}

- (int)cardsInPlay
{
    return [self.cards count];
}

- (MatchInfo *)lastMatchInfo
{
    if (!_lastMatchInfo) _lastMatchInfo = [[MatchInfo alloc] init];
    return _lastMatchInfo;
}

- (id)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck usingCardsToMatch:(int)cardsToMatch
{
    self = [super init];
    
    if (self) {
        self.cardsToMatch = cardsToMatch;
        
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

- (void)addCardToGame:(Card *)card
{
    if (card != nil) {
        [self.cards addObject:card];
    }
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count ? self.cards[index] : nil);
}

- (void)deleteCardsAtIndexes:(NSIndexSet *)indexes
{
    [self.cards removeObjectsAtIndexes:indexes];
}

#define FLIP_COST -1
#define MISMATCH_PENALTY -2
#define MATCH_BONUS 4

- (void)scoreFlip:(Card *)card
{
    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    
    for (Card *otherCard in self.cards) {
        if (otherCard.isFaceUp && !otherCard.isUnplayable) {
            [otherCards addObject:otherCard];
        }
    }
    
    if ([otherCards count] == self.cardsToMatch-1) {
        self.lastMatchInfo = [card match:otherCards];
        if (self.lastMatchInfo.score) {
            if ([self.lastMatchInfo.matches indexOfObject:card] != NSNotFound) {
                card.unplayable = YES;
            }
            for (Card *otherCard in otherCards) {
                if ([self.lastMatchInfo.matches indexOfObject:otherCard] != NSNotFound) {
                    otherCard.unplayable = YES;
                } else {
                    otherCard.faceUp = NO;
                }
            }
            self.lastMatchInfo.score *= MATCH_BONUS;
        } else {
            for (Card *otherCard in otherCards) {
                otherCard.faceUp = NO;
            }
            self.lastMatchInfo.score = MISMATCH_PENALTY;
        }
    } else if ([otherCards count] < self.cardsToMatch-1) {
        self.lastMatchInfo.matchType = FLIPPED_UP;
    } else {
        NSLog(@"scoreFlip: found > %d other cards face up and playable!", self.cardsToMatch-1);
    }
}

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    self.lastMatchInfo = nil;
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            [self scoreFlip:card];
            self.lastMatchInfo.score += FLIP_COST;
            self.score += self.lastMatchInfo.score;
        } else {
            self.lastMatchInfo.matchType = FLIPPED_DOWN;
        }
        card.faceUp = !card.isFaceUp;
    }
}

@end
