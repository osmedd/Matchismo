//
//  SetCard.h
//  Matchismo
//
//  Created by Owen Medd on 2/19/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "PlayingCard.h"

@interface SetCard : PlayingCard

@property (nonatomic) NSUInteger color;
@property (nonatomic) NSUInteger shading;

+ (NSUInteger)maxColor;
+ (NSUInteger)maxShading;

@end
