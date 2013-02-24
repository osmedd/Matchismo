//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Owen Medd on 2/24/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (NSUInteger)startingCardCount
{
    return 16;
}

- (NSUInteger)cardsToMatch
{
    return 2;
}

- (NSString *)gameType
{
    return @"Match";
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }    
}

@end
