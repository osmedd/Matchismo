//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Owen Medd on 2/15/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()
@end

@implementation SetGameViewController

- (void)setup
{
    
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    [self setup];
    return self;
}

- (NSUInteger)startingCardCount
{
    return 24;
}

- (NSUInteger)cardsToMatch
{
    return 3;
}

- (NSString *)gameType
{
    return @"Set";
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)getCardContents:(SetCard *)card
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:card.contents];
    NSRange range = [[attrStr string] rangeOfString: card.contents];
    UIColor *color = nil;
    
    switch (card.color) {
        case 1:
            color = [UIColor greenColor];
            break;
            
        case 2:
            color = [UIColor redColor];
            break;
            
        case 3:
            color = [UIColor purpleColor];
            break;
            
        default:
            NSLog(@"getCardContents: invalid color: %d", card.color);
            break;
    }
    
    double strokeWidth = 0;
    
    switch (card.shading) {
        case 1:
            // solid shading
            strokeWidth = -5;
            break;
            
        case 2:
            // open shading
            strokeWidth = 5;
            break;
            
        case 3:
            // striped shading
            strokeWidth = -5;
            color = [color colorWithAlphaComponent:0.3];
            break;
    }
    
    [attrStr addAttributes:@{ NSStrokeWidthAttributeName:@(strokeWidth),NSStrokeColorAttributeName:color, NSForegroundColorAttributeName:color } range:range];
    
    return attrStr;
}

- (void)updateUI
{
    [super updateUI];
    
    NSArray *cardButtons = [self getCardButtons];
    
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.game cardAtIndex:[cardButtons indexOfObject:cardButton]];
        //[cardButton setAttributedTitle:[self getCardContents:(SetCard *)card] forState:UIControlStateSelected];
        [cardButton setAttributedTitle:[self getCardContents:(SetCard *)card] forState:UIControlStateNormal];
        cardButton.backgroundColor = (card.isFaceUp ? [UIColor grayColor] : nil);
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(1, -1, -1, -1)];
        cardButton.clipsToBounds = YES;
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
    }
}

@end
