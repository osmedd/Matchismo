//
//  SetCardView.h
//  Matchismo
//
//  Created by Juan C. Catalan on 18/02/13.
//  Copyright (c) 2013 CS193p. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger symbol, number, shading, color; // 1..3
@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic) CGFloat cornerRadius;


@end
