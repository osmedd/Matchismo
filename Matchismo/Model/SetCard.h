//
//  SetCard.h
//  Matchismo
//
//  Created by Owen Medd on 2/19/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "PlayingCard.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shading;

+ (NSUInteger)maxSymbol;
+ (NSUInteger)maxNumber;
+ (NSUInteger)maxColor;
+ (NSUInteger)maxShading;

@end
