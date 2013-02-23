//
//  GameResultViewController.m
//  Matchismo
//
//  Created by Owen Medd on 2/23/13.
//  Copyright (c) 2013 InterGuide Communications, Inc. All rights reserved.
//

#import "GameResultViewController.h"
#import "GameResult.h"

@interface GameResultViewController ()
@property (weak, nonatomic) IBOutlet UITextView *display;
@property (nonatomic) SEL sortSelector;
@end

@implementation GameResultViewController

- (void)updateUI
{
    NSString *displayText = @"";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    for (GameResult *result in [[GameResult allGameResults]sortedArrayUsingSelector:self.sortSelector]) {
        displayText = [displayText stringByAppendingFormat:@"%@ Score: %d (%@ %0g)\n", result.gameType, result.score, [formatter stringFromDate:result.end], round(result.duration)];
    }
    self.display.text = displayText;
}

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateUI];
}

@synthesize sortSelector = _sortSelector;  // because we implement BOTH setter and getter

// return default sort selector if none set (by score)

- (SEL)sortSelector
{
    if (!_sortSelector) _sortSelector = @selector(compareScoreToGameResult:);
    return _sortSelector;
}

// update the UI when changing the sort selector

- (void)setSortSelector:(SEL)sortSelector
{
    _sortSelector = sortSelector;
    [self updateUI];
}

- (IBAction)sortByDate
{
    self.sortSelector = @selector(compareEndDateToGameResult:);
}

- (IBAction)sortByScore
{
    self.sortSelector = @selector(compareScoreToGameResult:);
}

- (IBAction)sortByDuration
{
    self.sortSelector = @selector(compareDurationToGameResult:);
}

@end
