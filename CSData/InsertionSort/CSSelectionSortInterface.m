//
//  CSInsetionSortInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-18.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSSelectionSortInterface.h"
#import "CSBlockView.h"
#import "CSArrowView.h"

#pragma mark - Interface

#define BLOCK_VIEW_START_X 161.0
#define BLOCK_VIEW_WIDTH 69.0

#define BLOCKS_START_Y 302.0

#define ARROW_BLOCKS_Y_PADDING 22.0
#define ARROW_HEIGHT 30.0

#define AJ_TAG 510
#define AK_TAG 1216

@interface CSSelectionSortInterface ()
{
    NSInteger _currentI;
    NSInteger _currentK;
    __block NSInteger _currentJ;
    
    BOOL _justCompared;
    BOOL _justReplacedComparer;
}
@property (nonatomic, retain) UILabel *topLabel;
//@property (nonatomic, retain) UILabel *leftLabel;
@property (nonatomic, retain) CSArrowView *arrowI;
@property (nonatomic, retain) CSArrowView *arrowK;

@property (nonatomic, retain) CSBlockView *leftComparisonBlockView;
@property (nonatomic, retain) UILabel *comparisonResultLabel;
@property (nonatomic, retain) CSBlockView *rightComparisonBlockView;
@end

@implementation CSSelectionSortInterface

- (id)init
{
    if (self = [super init]) {
        _currentI = -1;
        _currentK = 9;
        _currentJ = -1;
        
        _justCompared = YES;
        _justReplacedComparer = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [_topLabel release];
//    [_leftLabel release];
    if (_arrowI) [_arrowI release];
    if (_arrowK) [_arrowK release];
    [_leftComparisonBlockView release];
    [_rightComparisonBlockView release];
    [_comparisonResultLabel release];
    
    [super dealloc];
}

- (void)_createBlockViewWithFrame:(CGRect)frame andTag:(NSUInteger)tag
{
    CSBlockView *blockView = [[CSBlockView alloc] initWithFrame:frame];
    blockView.borderWidth = 10.0;
    blockView.status = BVStatusInactive;
    blockView.tag = tag;
    [self.backgroundView addSubview:blockView];
    
    [blockView release];
}

- (NSUInteger)_randomNumber
{
    return arc4random()%10 + 1;
}

- (void)buildInterface
{
    for (NSUInteger i = 0; i < 10; i++)
        [self _createBlockViewWithFrame:CGRectMake(BLOCK_VIEW_START_X + i * BLOCK_VIEW_WIDTH, BLOCKS_START_Y, BLOCK_VIEW_WIDTH, BLOCK_VIEW_WIDTH) andTag:i+1];
    [self fillBlocksWithNumbers];
    
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(200.0, 40.0, 623.0, 70.0)];
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.font = [UIFont fontWithName:@"TimesNewRomanPS-BoldMT" size:18.0];
    self.topLabel = topLabel;
    [self.backgroundView addSubview:topLabel];
    
    [topLabel release];
    
    // (336, 469) (83, 76) ... (558, 469) (77, 76) ... (452, 469) (83, 76)
    [self _createBlockViewWithFrame:CGRectMake(336.0, 469.0, 83.0, 76.0) andTag:AJ_TAG];
    [self _createBlockViewWithFrame:CGRectMake(452.0, 469.0, 83.0, 76.0) andTag:AK_TAG];
    UILabel *comparisonResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(558.0, 469.0, 77.0, 76.0)];
    comparisonResultLabel.font = [UIFont boldSystemFontOfSize:22.0];
    comparisonResultLabel.backgroundColor = [UIColor clearColor];
    comparisonResultLabel.textAlignment = NSTextAlignmentCenter;
    comparisonResultLabel.opaque = NO;
    comparisonResultLabel.alpha = 0.0;
    
    self.comparisonResultLabel = comparisonResultLabel;
    [self.backgroundView addSubview:comparisonResultLabel];
    [comparisonResultLabel release];
}

- (void)fillBlocksWithNumbers
{
    NSUInteger index[11] = {0};
    
    NSUInteger generatedRandomNumber = 0;
    for (int i = 0; i < 10; i++) {
        generatedRandomNumber = [self _randomNumber];
        while (index[generatedRandomNumber]) {
            generatedRandomNumber = [self _randomNumber];
        }
        
        CSBlockView *blockView = (CSBlockView *)[self.backgroundView viewWithTag:i+1];
        [blockView setText:[NSString stringWithFormat:@"%u", generatedRandomNumber]];
        index[generatedRandomNumber] = 1;
    }
}

#pragma mark - View Change 'Setter'

- (void)setBlockViewStatus:(BVStatus)status forTag:(NSUInteger)tag animated:(BOOL)animated
{
    CSBlockView *blockView = (CSBlockView *)[self.backgroundView viewWithTag:tag];
    
    // cause @status setter will call UIView's -setNeedsDisplay, so we should see if we can save CPU time here.
    if (blockView.status == status) return;
    
    [blockView setStatus:status animated:animated];
}

- (void)setArrowIPointToBlockForTag:(NSUInteger)tag animated:(BOOL)animated
{
    CSBlockView *blockView = (CSBlockView *)[self.backgroundView viewWithTag:tag];
    CGPoint lowerCenterEdgeOfBlockView = CGPointMake(blockView.center.x, blockView.center.y + blockView.bounds.size.height * 0.5);
    CGPoint fromPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, lowerCenterEdgeOfBlockView.y + ARROW_BLOCKS_Y_PADDING + ARROW_HEIGHT);
    CGPoint toPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, ARROW_BLOCKS_Y_PADDING);
    
    if (!self.arrowI) {
        CSArrowView *arrowView = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        self.arrowI = arrowView;
        [self.backgroundView addSubview:arrowView];
        
        [arrowView release];
    }
    else {
        self.arrowK.hidden = NO;
        [self.arrowI moveParallelyPointingToPoint:toPoint animated:YES];
    }
}

- (void)setArrowKPointToBlockForTag:(NSUInteger)tag animated:(BOOL)animated
{
    CSBlockView *blockView = (CSBlockView *)[self.backgroundView viewWithTag:tag];
    CGPoint lowerCenterEdgeOfBlockView = CGPointMake(blockView.center.x, blockView.center.y + blockView.bounds.size.height * 0.5);
    CGPoint fromPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, lowerCenterEdgeOfBlockView.y + ARROW_BLOCKS_Y_PADDING + ARROW_HEIGHT);
    CGPoint toPoint = CGPointMake(lowerCenterEdgeOfBlockView.x, ARROW_BLOCKS_Y_PADDING);
    
    if (!self.arrowK) {
        CSArrowView *arrowView = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        self.arrowK = arrowView;
        [self.backgroundView addSubview:arrowView];
        
        [arrowView release];
    }
    else {
        self.arrowK.hidden = NO;
        [self.arrowK moveParallelyPointingToPoint:toPoint animated:YES];
    }
}

- (void)setCounterI:(NSInteger)constantI andK:(NSInteger)constantK
{
    for (NSUInteger i = 0; i < constantI; i++)
        [self setBlockViewStatus:BVStatusInactive forTag:i+1 animated:NO];
    
//    [self setBlockViewStatus:BVStatusActive forTag:constantI+1 animated:YES];
    [self setArrowIPointToBlockForTag:constantI+1 animated:YES];
    _currentI = constantI;
    if (constantK <= 0) {
        CSBlockView *aBlockView = (CSBlockView *)[self.backgroundView viewWithTag:AJ_TAG];
        [aBlockView setText:[NSString stringWithFormat:@"%d", [((CSBlockView *)[self.backgroundView viewWithTag:constantI+1]).text integerValue]]];
        _currentJ = _currentI;
        [self setBlockViewStatus:BVStatusActive forTag:_currentJ+1 animated:YES];
        _currentK = _currentI;
    }
    
    if (constantK > 0) {
        for (NSUInteger i = constantI; i < constantK; i++)
            [self setBlockViewStatus:BVStatusToBeActive forTag:i+1 animated:NO];
        
        [self setBlockViewStatus:BVStatusActive forTag:constantK + 1 animated:YES];
        [self setArrowKPointToBlockForTag:constantK + 1 animated:YES];
        _currentK = constantK;
    }
}

// TODO : Make 'a[j]' and 'a[k]' block. Thought the logic of the process.
- (void)setComparerBlockViewForTag:(NSUInteger)tag withText:(NSString *)text
{
    CSBlockView *aBlockView = (CSBlockView *)[self.backgroundView viewWithTag:tag];
    [aBlockView setText:text];
    
    _justReplacedComparer = YES;
}

- (void)compareComparer
{
    CSBlockView *ajBlockView = (CSBlockView *)[self.backgroundView viewWithTag:AJ_TAG];
    CSBlockView *akBlockView = (CSBlockView *)[self.backgroundView viewWithTag:AK_TAG];
    
    NSUInteger aj = [ajBlockView.text integerValue];
    NSUInteger ak = [akBlockView.text integerValue];
    
    if (aj > ak) {
        // gradually show comparisonResultLabel
        [UIView animateWithDuration:1.0 animations:^{
            self.comparisonResultLabel.alpha = 1.0;
        } completion:^(BOOL finished){
            
        }];
        
        CSBlockView *currentJBlockView = (CSBlockView *)[self.backgroundView viewWithTag:_currentJ+1];
        CSBlockView *currentKBlockView = (CSBlockView *)[self.backgroundView viewWithTag:_currentK+1];
        
        currentKBlockView.text = [NSString stringWithFormat:@"%d", aj];
        currentJBlockView.text = [NSString stringWithFormat:@"%d", ak];
        
        [self setBlockViewStatus:BVStatusActive forTag:_currentJ+1 animated:NO];
    }
    _currentJ = _currentK;
    _justReplacedComparer = NO;
    _justCompared = YES;
}

#pragma mark - APIs inherited from superclass

- (void)nextStep
{
    // TODO : State checking is ugly. Why not to try a more beautiful way to handle step-to-step thing.
    if (_justCompared) {
        if (_currentK >= 9)
            [self setCounterI:_currentI + 1 andK:-1];
        else {
             _justCompared = !_justCompared;
            [self setCounterI:_currentI andK:_currentK + 1];
        }
    }
    else if (!_justReplacedComparer) {
        CSBlockView *currentJBlockView = (CSBlockView *)[self.backgroundView viewWithTag:_currentK+1];
        [self setComparerBlockViewForTag:AK_TAG withText:currentJBlockView.text];
    }
    else {
        [self compareComparer];
    }
}

- (void)lastStep
{
    
}

- (BOOL)hasNext
{
    return 9-_currentI&&9-_currentK;
}

@end
