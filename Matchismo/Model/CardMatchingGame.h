//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Owen Medd on 1/31/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated initializer!
- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck usingCardsToMatch:(int)cardsToMatch;

- (void)flipCardAtIndex:(NSUInteger)index;

- (Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic) int cardsToMatch;
@property (nonatomic, readonly) int score;
@property (strong, nonatomic, readonly) MatchInfo *lastMatchInfo;

@end
