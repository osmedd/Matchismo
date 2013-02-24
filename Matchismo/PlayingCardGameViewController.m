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

- (void)updateUI
{
    [super updateUI];
    
    UIImage *cardBackImage = [UIImage imageNamed:@"knights_cardback.png"];
    NSArray *cardButtons = [self getCardButtons];
    
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.game cardAtIndex:[cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setImage:(card.isFaceUp ? nil : cardBackImage) forState:UIControlStateNormal];
        //[cardButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        cardButton.layer.cornerRadius = 7.0;
        cardButton.clipsToBounds = YES;
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
}

@end
