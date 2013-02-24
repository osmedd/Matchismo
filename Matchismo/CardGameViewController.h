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

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; // abstract
- (Deck *)createDeck;

@property (readonly, nonatomic) NSUInteger startingCardCount; // abstract
@property (readonly, nonatomic) NSUInteger cardsToMatch; // abstract
@property (readonly, nonatomic) NSString *gameType; // abstract
@end
