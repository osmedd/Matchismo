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
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@end

@implementation CardGameViewController

- (GameResult *)gameResult
{
    if (!_gameResult) _gameResult = [[GameResult alloc] init];
    return _gameResult;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init] usingCardsToMatch:2];
        self.gameResult.gameType = @"Match";
    }
    return _game;
}

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

- (void)viewDidLoad
{
    int historySliderCount = self.flipHistory.count;
    self.historySlider.maximumValue = historySliderCount == 0 ? 0 : historySliderCount -1;
    self.historySlider.minimumValue = 0;
    self.historySlider.value = self.historySlider.minimumValue;    
}

- (void)updateUI
{
   
    UIImage *cardBackImage = [UIImage imageNamed:@"knights_cardback.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
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
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    int historySliderCount = self.flipHistory.count;
    self.historySlider.maximumValue = historySliderCount == 0 ? 0 : historySliderCount;
    self.historySlider.minimumValue = 0;
    self.historySlider.value = self.historySlider.maximumValue;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}

- (NSAttributedString *)getCardContents:(Card *)card
{
    NSMutableAttributedString *contents = [[NSMutableAttributedString alloc] initWithString:card.contents];
    return contents;
}

- (NSAttributedString *)concatCardContents:(NSArray *)cardList
{
    NSMutableAttributedString *contents = [[NSMutableAttributedString alloc] init];
    
    int count = 0;
    for (Card *card in cardList) {
        if (count++ > 0) {
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
        }
        [contents appendAttributedString:[self getCardContents:card]];
    }
    
    return contents;
}

- (NSAttributedString *)formatLastFlipLabel:(UIButton *)sender
{
    NSMutableAttributedString *contents = [[NSMutableAttributedString alloc] init];
    MatchInfo *matchInfo = self.game.lastMatchInfo;
    Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:sender]];
    
    switch (matchInfo.matchType) {
        case FLIPPED_UP:
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped up "]];
            [contents appendAttributedString:[self getCardContents:card]];
            break;
        case FLIPPED_DOWN:
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:@"Flipped down "]];
            [contents appendAttributedString:[self getCardContents:card]];
            break;
        case MATCH_NONE:
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:@"No match! "]];
            [contents appendAttributedString:[self concatCardContents:matchInfo.cardsConsidered]];
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%d)", matchInfo.score]]];
            break;
        default:
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:@"Match! "]];
            [contents appendAttributedString:[self concatCardContents:matchInfo.cardsConsidered]];
            [contents appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" (%d)", matchInfo.score]]];
            break;
    }
    
    return contents;
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.lastFlipLabel.attributedText = [self formatLastFlipLabel:sender];
    [self.flipHistory addObject:self.lastFlipLabel.attributedText];
    self.lastFlipLabel.alpha = 1.0;
    self.flipCount++;
    [self updateUI];
    self.gameResult.score = self.game.score;
}

- (IBAction)dealCards:(UIButton *)sender {
    self.game = nil;
    self.gameResult = nil;
    self.flipHistory = nil;
    self.flipCount = 0;
    self.lastFlipLabel.text = @"";
    [self updateUI];
}

- (IBAction)historySliderValueChanged:(UISlider *)sender {
    if (self.flipHistory.count > 0) {
        self.lastFlipLabel.alpha = (sender.value == sender.maximumValue) ? 1.0 : 0.3;
        self.lastFlipLabel.attributedText = sender.value < 1 ? [[NSAttributedString alloc] initWithString:@"Game start!"] : self.flipHistory[(int)sender.value-1];
    }
}

@end
