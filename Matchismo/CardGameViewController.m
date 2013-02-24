//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Owen Medd on 1/30/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "MatchInfo.h"

@interface CardGameViewController () <UICollectionViewDataSource>
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) GameResult *gameResult;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) NSMutableArray *flipHistory;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISlider *historySlider;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastFlipLabel;
@end

@implementation CardGameViewController

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return self.startingCardCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PlayingCard" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card];
    return cell;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    // abstract
}

- (GameResult *)gameResult
{
    if (!_gameResult) {
        _gameResult = [[GameResult alloc] init];
        _gameResult.gameType = [self gameType];
    }
    return _gameResult;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount usingDeck:[self createDeck] usingCardsToMatch:self.cardsToMatch];
    }
    return _game;
}

- (Deck *)createDeck { return nil; } // abstract

- (NSMutableArray *)flipHistory
{
    if (!_flipHistory) _flipHistory = [[NSMutableArray alloc] init];
    return _flipHistory;
}

- (void)viewDidLoad
{
    int historySliderCount = self.flipHistory.count;
    self.historySlider.maximumValue = historySliderCount == 0 ? 0 : historySliderCount -1;
    self.historySlider.minimumValue = 0;
    self.historySlider.value = self.historySlider.minimumValue;
    
    [self updateUI];
}

- (void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        [self updateCell:cell usingCard:card];
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

- (NSAttributedString *)formatLastFlipLabel:(NSInteger)cardIndex
{
    NSMutableAttributedString *contents = [[NSMutableAttributedString alloc] init];
    MatchInfo *matchInfo = self.game.lastMatchInfo;
    Card *card = [self.game cardAtIndex:cardIndex];
    
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

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    if (indexPath) {
        [self.game flipCardAtIndex:indexPath.item];
        self.flipCount++;
        [self updateUI];
        self.gameResult.score = self.game.score;
        self.lastFlipLabel.attributedText = [self formatLastFlipLabel:indexPath.item];
        [self.flipHistory addObject:self.lastFlipLabel.attributedText];
        self.lastFlipLabel.alpha = 1.0;
    }
}

//- (IBAction)flipCard:(UIButton *)sender
//{
//    //[self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
//    self.lastFlipLabel.attributedText = [self formatLastFlipLabel:sender];
//    [self.flipHistory addObject:self.lastFlipLabel.attributedText];
//    self.lastFlipLabel.alpha = 1.0;
//    self.flipCount++;
//    [self updateUI];
//    self.gameResult.score = self.game.score;
//}

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
