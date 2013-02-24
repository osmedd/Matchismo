//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Owen Medd on 1/30/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "GameResult.h"

@interface CardGameViewController : UIViewController
- (Deck *)createDeck;
- (void)updateUI; // temporary while refactoring
- (NSArray *)getCardButtons; // temporary while refactoring
@property (strong, nonatomic) CardMatchingGame *game; // temporary, make private after updateUI is all in base class

//- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; // abstract

@property (readonly, nonatomic) NSUInteger startingCardCount; // abstract
@property (readonly, nonatomic) NSUInteger cardsToMatch; // abstract
@property (readonly, nonatomic) NSString *gameType; // abstract
@end
