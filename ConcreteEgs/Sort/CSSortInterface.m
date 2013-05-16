//
//  CSSortInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-1.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSSortInterface.h"

#define BLOCK_VIEW_WIDTH 76.0
// TDOO : why center.y?
#define BLOCK_VIEW_START_X self.backgroundView.center.y - self.number * BLOCK_VIEW_WIDTH/2.0

#define BLOCKS_START_Y 302.0

#define ARROW_BLOCKS_Y_PADDING 22.0
#define ARROW_HEIGHT 30.0

#define LABEL_ARROW_Y_PADDING 12.0

@implementation CSSortInterface

- (instancetype)init
{
    if (self = [super init]) {
        self.number = 5;
        self.numberBlockViews = [[NSMutableArray alloc] initWithCapacity:self.number];
    }
    
    return self;
}

- (instancetype)initWithNumber:(NSUInteger)number
{
    if (self = [super init]) {
        self.number = number;
        self.numberBlockViews = [[NSMutableArray alloc] initWithCapacity:self.number];
    }
    
    return self;
}

- (NSUInteger)_randomNumber
{
    // to generate random number between 1~self.number
    return arc4random() % 11;
}

- (NSUInteger)numberInBlockViewAtIndex:(NSUInteger)index
{
    CSBlockView *blockView = (CSBlockView *)self.numberBlockViews[index];
    
    return [blockView.text integerValue];
}

- (void)setBlockViewAtIndex:(NSUInteger)index withNumber:(NSUInteger)number
{
    CSBlockView *blockView = (CSBlockView *)self.numberBlockViews[index];
    blockView.text = [NSString stringWithFormat:@"%u", number];
}

- (void)setRandomizedNumberToBlockViewAtIndex:(NSUInteger)index
{
    NSUInteger i = 0;
    NSUInteger searchMap[11] = {0};
    while (i < index) {
        searchMap[[self numberInBlockViewAtIndex:i++]] = 1;
    }
    
    NSUInteger r = [self _randomNumber];
    while (searchMap[r]) {
        r = [self _randomNumber];
    }
    /*
    NSUInteger r = 0;
    if (index == 0) r = 2;
    if (index == 1) r = 1;
    if (index == 2) r = 7;
    if (index == 3) r = 0;
    if (index == 4) r = 10;
    */
    [self setBlockViewAtIndex:index withNumber:r];
}

- (CSBlockView *)_defaultBlockViewWithFrame:(CGRect)frame
{
    CSBlockView *blockView = [[CSBlockView alloc] initWithFrame:frame];
    blockView.borderWidth = 10.0;
    blockView.status = BVStatusInactive;
    return blockView;
}

- (void)construct
{
    [super construct];
    
    for (NSUInteger i = 0; i < self.number; i++) {
        CSBlockView *blockView = [self _defaultBlockViewWithFrame:CGRectMake(BLOCK_VIEW_START_X + i * BLOCK_VIEW_WIDTH, BLOCKS_START_Y, BLOCK_VIEW_WIDTH, BLOCK_VIEW_WIDTH)];
        [self.backgroundView addSubview:blockView];
        [self.numberBlockViews addObject:blockView];
    }
    // (336, 469) (83, 76) ... (558, 469) (77, 76) ... (452, 469) (83, 76)
    self.comparisonResultLabel = [[UILabel alloc] init];
    self.comparisonResultLabel.center = CGPointMake(self.backgroundView.center.y, BLOCKS_START_Y + BLOCK_VIEW_WIDTH + 117.0);
    self.comparisonResultLabel.bounds = CGRectMake(0.0, 0.0, 69.0, 69.0);
    self.comparisonResultLabel.font = [UIFont boldSystemFontOfSize:24.0];
    self.comparisonResultLabel.backgroundColor = [UIColor clearColor];
    self.comparisonResultLabel.textAlignment = NSTextAlignmentCenter;
    self.comparisonResultLabel.opaque = NO;
    self.comparisonResultLabel.alpha = 0.0;
    [self.backgroundView addSubview:self.comparisonResultLabel];
    
    self.leftComparisonBlockView = [self _defaultBlockViewWithFrame:CGRectMake(self.comparisonResultLabel.frame.origin.x - 29.0 - 69.0, self.comparisonResultLabel.frame.origin.y, 69.0, 69.0)];
    self.rightComparisonBlockView = [self _defaultBlockViewWithFrame:CGRectMake(self.comparisonResultLabel.frame.origin.x + 29.0 + 69.0, self.comparisonResultLabel.frame.origin.y, 69.0, 69.0)];
    [self.backgroundView addSubview:self.leftComparisonBlockView];
    [self.backgroundView addSubview:self.rightComparisonBlockView];
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(310.0, 525.0, 412.0, 183.0)];
    self.consoleView.opaque = NO;
    self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
}

- (void)pointArrowIToIndex:(NSUInteger)index
{
    CSBlockView *blockView = (CSBlockView *)[self.numberBlockViews objectAtIndex:index];
    CGPoint lowerCenterEdgeOfBlockView = CGPointMake(blockView.center.x, blockView.center.y + blockView.bounds.size.height * 0.5);
    CGPoint fromPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, lowerCenterEdgeOfBlockView.y + ARROW_BLOCKS_Y_PADDING + ARROW_HEIGHT);
    CGPoint toPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, lowerCenterEdgeOfBlockView.y + ARROW_BLOCKS_Y_PADDING);
    
    if (!self.arrowI) {
        self.arrowI = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        
        [self.backgroundView addSubview:self.arrowI];
    }
    else {
        [self.arrowI moveParallelyPointingToPoint:toPoint animated:YES];
    }
    self.arrowI.arrowName = [NSString stringWithFormat:@"i=%d", index];
}

- (void)pointArrowKToIndex:(NSUInteger)index
{
    CSBlockView *blockView = (CSBlockView *)[self.numberBlockViews objectAtIndex:index];
    CGPoint lowerCenterEdgeOfBlockView = CGPointMake(blockView.center.x, blockView.center.y + blockView.bounds.size.height * 0.5);
    CGPoint fromPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, lowerCenterEdgeOfBlockView.y + ARROW_BLOCKS_Y_PADDING + ARROW_HEIGHT);
    CGPoint toPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, lowerCenterEdgeOfBlockView.y + ARROW_BLOCKS_Y_PADDING);
    
    if (!self.arrowK) {
        self.arrowK = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        
        [self.backgroundView addSubview:self.arrowK];
    }
    else {
        [self.arrowK moveParallelyPointingToPoint:toPoint animated:YES];
    }
    self.arrowK.arrowName = [NSString stringWithFormat:@"k=%d", index];
}

- (void)setBlockViewStatus:(BVStatus)status atIndex:(NSUInteger)index
{
    CSBlockView *blockView = (CSBlockView *)self.numberBlockViews[index];
    // TODO : animation bug
    [blockView setStatus:status animated:NO];
}

@end
