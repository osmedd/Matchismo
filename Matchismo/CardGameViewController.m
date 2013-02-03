//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Owen Medd on 1/30/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "MatchInfo.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *gameModeControl;
@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] usingCardsToMatch:self.gameModeControl.selectedSegmentIndex+2];
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)updateUI
{
   
    UIImage *cardBackImage = [UIImage imageNamed:@"knights_cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        [cardButton setImage:(card.isFaceUp ? nil : cardBackImage) forState:UIControlStateNormal];
        cardButton.layer.cornerRadius = 7.0;
        cardButton.clipsToBounds = YES;
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (NSString *)concatCardContents:(NSArray *)cardList
{
    NSMutableArray *contentList = [[NSMutableArray alloc] init];
    
    for (Card *card in cardList) {
        [contentList addObject:card.contents];
    }
    
    return [contentList componentsJoinedByString:@""];
}

- (NSString *)formatLastFlipLabel:(UIButton *)sender
{
    NSString *lastFlipLabel = nil;
    MatchInfo *matchInfo = self.game.lastMatchInfo;
    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    switch (matchInfo.matchType) {
        case FLIPPED_UP:
            lastFlipLabel = [NSString stringWithFormat:@"Flipped up %@", card.contents];
            break;
        case MATCH_NONE:
            lastFlipLabel = [NSString stringWithFormat:@"No match! %@ %d points", [self concatCardContents:matchInfo.cardsConsidered], matchInfo.score];
            break;
        case MATCH_RANK:
        case MATCH_SUIT:
            lastFlipLabel = [NSString stringWithFormat:@"Matched! %@ %d points", [self concatCardContents:matchInfo.matches], matchInfo.score];
            break;
        default:
            break;
    }
    
    return lastFlipLabel;
}

- (IBAction)flipCard:(UIButton *)sender
{
    if (self.flipCount == 0) {
        self.gameModeControl.enabled = NO;
    }
    
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.lastFlipLabel.text = [self formatLastFlipLabel:sender];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)dealCards:(UIButton *)sender {
    self.game = nil;
    self.flipCount = 0;
    self.lastFlipLabel.text = @"";
    self.gameModeControl.enabled = YES;
    [self updateUI];
}

- (IBAction)gameModeChanged:(UISegmentedControl *)sender {
    self.game.cardsToMatch = sender.selectedSegmentIndex+2;
}

@end
