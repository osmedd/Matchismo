//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Owen Medd on 2/19/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (id)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger symbol = 1; symbol <= [SetCard maxSymbol]; symbol++) {
            for (NSUInteger number = 1; number <= [SetCard maxNumber]; number++) {
                for (NSUInteger color = 1; color <= [SetCard maxColor]; color++) {
                    for (NSUInteger shading = 1; shading <= [SetCard maxShading]; shading++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.color = color;
                        card.shading = shading;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
