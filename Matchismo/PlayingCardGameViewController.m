//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Owen Medd on 2/24/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (NSUInteger)startingCardCount
{
    return 22;
}

- (NSUInteger)cardsToMatch
{
    return 2;
}

- (NSString *)gameType
{
    return @"Match";
}

- (NSString *)viewCellID
{
    return @"PlayingCard";
}

- (BOOL)shouldRemoveCardMatches
{
    return NO;
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            if (playingCardView.faceUp != playingCard.isFaceUp) {
                if (animate) {
                    [UIView transitionWithView:playingCardView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:^{
                                        playingCardView.faceUp = playingCard.isFaceUp;
                                    } completion:NULL];
                } else {
                    playingCardView.faceUp = playingCard.isFaceUp;
                }
            }
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }    
}

@end
