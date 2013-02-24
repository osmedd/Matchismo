//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Owen Medd on 2/24/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@end
