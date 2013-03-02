//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Owen Medd on 2/15/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardCollectionViewCell.h"
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
    return 12;
}

- (NSUInteger)cardsToMatch
{
    return 3;
}

- (NSString *)gameType
{
    return @"Set";
}

- (NSString *)viewCellID
{
    return @"SetCard";
}

- (BOOL)shouldRemoveCardMatches
{
    return YES;
}

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (NSAttributedString *)getCardContents:(SetCard *)card
{
    NSArray *colorPallette = @[[UIColor redColor], [UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0], [UIColor purpleColor]];
    NSArray *alphaPallette = @[@0, @0.2, @1];
    UIColor *cardOutlineColor = colorPallette[((SetCard *)card).color-1];
    UIColor *cardColor = [cardOutlineColor colorWithAlphaComponent:(CGFloat)[alphaPallette[((SetCard *)card).shading-1] floatValue]];
    NSDictionary *cardAttributes = @{NSForegroundColorAttributeName:cardColor, NSStrokeColorAttributeName:cardOutlineColor, NSStrokeWidthAttributeName:@-5};
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:card.contents attributes:cardAttributes];
    
    return attrStr;
}

- (void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            setCardView.symbol = setCard.symbol;
            setCardView.number = setCard.number;
            setCardView.color = setCard.color;
            setCardView.shading = setCard.shading;
            if (setCardView.faceUp != setCard.isFaceUp) {
                if (animate) {
                    [UIView transitionWithView:setCardView
                                      duration:0.5
                                       options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:^{
                                        setCardView.faceUp = setCard.isFaceUp;
                                    } completion:NULL];
                } else {
                    setCardView.faceUp = setCard.isFaceUp;
                }
            }
            setCardView.alpha = setCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

//- (void)updateUI
//{
//    NSArray *cardButtons = [self getCardButtons];
//    
//    for (UIButton *cardButton in cardButtons) {
//        Card *card = [self.game cardAtIndex:[cardButtons indexOfObject:cardButton]];
//        //[cardButton setAttributedTitle:[self getCardContents:(SetCard *)card] forState:UIControlStateSelected];
//        [cardButton setAttributedTitle:[self getCardContents:(SetCard *)card] forState:UIControlStateNormal];
//        cardButton.backgroundColor = (card.isFaceUp ? [UIColor grayColor] : nil);
//        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(1, -1, -1, -1)];
//        cardButton.clipsToBounds = YES;
//        cardButton.selected = card.isFaceUp;
//        cardButton.enabled = !card.isUnplayable;
//        cardButton.alpha = card.isUnplayable ? 0.0 : 1.0;
//    }
//}

@end
