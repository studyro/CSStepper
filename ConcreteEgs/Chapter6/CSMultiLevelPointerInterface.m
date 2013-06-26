//
//  CSMultiLevelPointerInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSMultiLevelPointerInterface.h"
#import "CSClusteredBlockView.h"
#import "NSString+Separator.h"
#import "CSConsoleView.h"

#define PBLOCK_START_X 223.0
#define PBLOCK_START_Y 150.0
#define BLOCKS_PADDING_Y 49.0
#define BLOCK_WIDHT 83.0
#define BLOCK_HEIGHT 61.0
#define STRBLOCK_START_X 423.0

#define CLUSTERED_START_X 600.0

@interface CSMultiLevelPointerInterface ()

@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, assign) NSUInteger currentPPIndex;
@property (nonatomic, strong) NSMutableArray *pBlockViews;
@property (nonatomic, strong) NSMutableArray *pLabels;

@property (nonatomic, strong) NSMutableArray *pToStrArrowViews;

@property (nonatomic, strong) NSMutableArray *strBlockViews;
@property (nonatomic, strong) NSMutableArray *strLabels;

@property (nonatomic, strong) NSMutableArray *strToClusteredArrowViews;

@property (nonatomic, strong) NSMutableArray *clusteredBlockViews;

@property (nonatomic, strong) CSConsoleView *consoleView;
@property (nonatomic, strong) CSArrowView *ppArrowView;
@property (nonatomic, strong) UILabel *ppLabel;
@property (nonatomic, strong) CSBlockView *ppBlockView;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation CSMultiLevelPointerInterface

- (id)init
{
    if (self = [super init]) {
        self.number = 4;
        self.currentPPIndex = 0;
        self.pBlockViews = [[NSMutableArray alloc] init];
        self.strBlockViews = [[NSMutableArray alloc] init];
        self.pToStrArrowViews = [[NSMutableArray alloc] init];
        self.pLabels = [[NSMutableArray alloc] init];
        self.strLabels = [[NSMutableArray alloc] init];
        self.clusteredBlockViews = [[NSMutableArray alloc] init];
        self.strToClusteredArrowViews = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (NSString *)stringAtIndex:(NSUInteger)idx
{
    switch (idx) {
        case 0:
            return @"enter";
            break;
            
        case 1:
            return @"lamp";
            break;
            
        case 2:
            return @"pointer";
            break;
            
        case 3:
            return @"first";
            break;
            
        default:
            return nil;
            break;
    }
}

- (void)construct
{
    [super construct];
    
    for (NSUInteger i = 0; i < self.number; i++) {
        CGFloat blockY = PBLOCK_START_Y + i * (BLOCK_HEIGHT + BLOCKS_PADDING_Y);
        NSUInteger idxPointingTo = 3 - i;
        
        CSBlockView *pBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(PBLOCK_START_X, blockY, BLOCK_WIDHT, BLOCK_HEIGHT)];
        pBlockView.borderWidth = 4.0;
        pBlockView.text = [NSString stringWithFormat:@"&str[%d]", idxPointingTo];
        pBlockView.backgroundColor = [UIColor clearColor];
        [self.pBlockViews addObject:pBlockView];
        [self.backgroundView addSubview:pBlockView];
        
        UILabel *pLabel = [[UILabel alloc] initWithFrame:CGRectMake(PBLOCK_START_X, blockY + BLOCK_HEIGHT + 6.0, BLOCK_WIDHT, 30.0)];
        pLabel.font = [UIFont systemFontOfSize:18.0];
        pLabel.text = [NSString stringWithFormat:@"p[%d]", i];
        pLabel.backgroundColor = [UIColor clearColor];
        pLabel.textAlignment = NSTextAlignmentCenter;
        [self.pLabels addObject:pLabel];
        [self.backgroundView addSubview:pLabel];
        
        CSBlockView *strBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(STRBLOCK_START_X, blockY, BLOCK_WIDHT, BLOCK_HEIGHT)];
        strBlockView.borderWidth = 4.0;
//        strBlockView.text = [NSString stringWithFormat:@"\"%@\"", [[self class] stringAtIndex:i]];;
        strBlockView.backgroundColor = [UIColor clearColor];
        [self.strBlockViews addObject:strBlockView];
        [self.backgroundView addSubview:strBlockView];
        
        UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(STRBLOCK_START_X, blockY + BLOCK_HEIGHT + 6.0, BLOCK_WIDHT, 30.0)];
        strLabel.font = [UIFont systemFontOfSize:18.0];
        strLabel.text = [NSString stringWithFormat:@"str[%d]", i];
        strLabel.backgroundColor = [UIColor clearColor];
        strLabel.textAlignment = NSTextAlignmentCenter;
        [self.strLabels addObject:strLabel];
        [self.backgroundView addSubview:strLabel];
        
        CSArrowView *pToStrArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(pBlockView.center.x + BLOCK_WIDHT * 0.5, pBlockView.center.y) toPoint:CGPointMake(STRBLOCK_START_X, PBLOCK_START_Y + idxPointingTo * (BLOCK_HEIGHT + BLOCKS_PADDING_Y) + BLOCK_HEIGHT * 0.5)];
        [self.pToStrArrowViews addObject:pToStrArrowView];
        [self.backgroundView addSubview:pToStrArrowView];
        
        NSString *str = [[self class] stringAtIndex:i];
        NSArray *lettersArray = [str separatedCharStringArrayWithTail:YES];
        NSUInteger letterCount = lettersArray.count;
        NSUInteger unitWidth = 46.0;
        CSClusteredBlockView *cbv = [[CSClusteredBlockView alloc] initWithPartition:letterCount andFrame:CGRectMake(CLUSTERED_START_X, blockY + 10.0, unitWidth * letterCount, 41.0)];
        cbv.textArray = lettersArray;
        cbv.boundLineWidth = 2.0;
        cbv.inlineWidth = 2.0;
        cbv.font = [UIFont systemFontOfSize:17.0];
        cbv.backgroundColor = [UIColor clearColor];
        [self.clusteredBlockViews addObject:cbv];
        [self.backgroundView addSubview:cbv];
        
        CSArrowView *strToClusteredArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(strBlockView.center.x + 0.5 * BLOCK_WIDHT, strBlockView.center.y) toPoint:CGPointMake(cbv.frame.origin.x, cbv.center.y)];
        [self.strToClusteredArrowViews addObject:strToClusteredArrowView];
        [self.backgroundView addSubview:strToClusteredArrowView];
    }
    
    UILabel *pArrayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(PBLOCK_START_X, PBLOCK_START_Y - 40.0, BLOCK_WIDHT, 30.0)];
    pArrayNameLabel.font = [UIFont systemFontOfSize:17.0];
    pArrayNameLabel.text = @"char **p[]";
    pArrayNameLabel.backgroundColor = [UIColor whiteColor];
    pArrayNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:pArrayNameLabel];
    
    UILabel *strArrayNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(STRBLOCK_START_X, PBLOCK_START_Y - 40.0, BLOCK_WIDHT, 30.0)];
    strArrayNameLabel.font = [UIFont systemFontOfSize:17.0];
    strArrayNameLabel.text = @"char *str[]";
    strArrayNameLabel.backgroundColor = [UIColor clearColor];
    strArrayNameLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:strArrayNameLabel];
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(336.0, 646.0, 188.0, 38.0)];
    [self.backgroundView addSubview:self.consoleView];
    
    self.ppArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(PBLOCK_START_X - 40.0, PBLOCK_START_Y + 0.5 * BLOCK_HEIGHT) toPoint:CGPointMake(PBLOCK_START_X, PBLOCK_START_Y + 0.5 * BLOCK_HEIGHT)];
    [self.backgroundView addSubview:self.ppArrowView];
    
    self.ppBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(self.ppArrowView.fromPoint.x - BLOCK_WIDHT, PBLOCK_START_Y, BLOCK_WIDHT, BLOCK_HEIGHT)];
    self.ppBlockView.borderWidth = 4.0;
    self.ppBlockView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.ppBlockView];
    
    self.ppLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.ppBlockView.frame.origin.x, PBLOCK_START_Y + BLOCK_HEIGHT + 5.0, 40.0, 20.0)];
    self.ppLabel.font = [UIFont systemFontOfSize:17.0];
    self.ppLabel.text = @"pp";
    self.ppLabel.backgroundColor = [UIColor clearColor];
    self.ppLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:self.ppLabel];
    
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(276.0, 630.0, 474.0, 40.0)];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.font = [UIFont systemFontOfSize:19.0];
    self.tipLabel.textColor = [UIColor redColor];
    self.tipLabel.opaque = NO, self.tipLabel.alpha = 0.0;
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.backgroundView addSubview:self.tipLabel];
    
    UILabel *expressionsList = [[UILabel alloc] initWithFrame:CGRectMake(654.0, 593.0, 244.0, 161.0)];
    expressionsList.backgroundColor = [UIColor clearColor];
    expressionsList.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    expressionsList.font = [UIFont systemFontOfSize:18.0];
    expressionsList.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",
                            [self expressionPrintf:0 stepIndex:3],
                            [self expressionPrintf:1 stepIndex:5],
                            [self expressionPrintf:2 stepIndex:3],
                            [self expressionPrintf:3 stepIndex:3]];
    [self.backgroundView addSubview:expressionsList];
}

- (NSString *)stringToPrintf:(NSUInteger)nTh
{
    NSString *str = nil;
    
    if (nTh == 0) {
        str = @"point";
    }
    else if (nTh == 1) {
        str = @"er";
    }
    else if (nTh == 2) {
        str = @"st";
    }
    else if (nTh == 3) {
        str = @"amp";
    }
    return str;
}

- (NSString *)expressionPrintf:(NSUInteger)nTh stepIndex:(NSUInteger)step
{
    NSString *str = nil;
    switch (nTh) {
        case 0:
        {
            if (step == 1)
                str = @"++pp";
            else if (step == 2)
                str = @"*(++pp)";
            else if (step == 3)
                str = @"*(*(++pp))";
        }
            break;
            
        case 1:
        {
            if (step == 1)
                str = @"++pp";
            else if (step == 2)
                str = @"*(++pp)";
            else if (step == 3)
                str = @"--(*(++pp))";
            else if (step == 4)
                str = @"*(--(*(++pp)))";
            else if (step == 5)
                str = @"*(--(*(++pp)))+3";
        }
            break;
        
        case 2:
        {
            if (step == 1)
                str = @"pp[-2]";
            else if (step == 2)
                str = @"*pp[-2]";
            else if (step == 3)
                str = @"*pp[-2]+3";
        }
            break;
            
        case 3:
        {
            if (step == 1)
                str = @"pp[-1]";
            else if (step == 2)
                str = @"pp[-1][-1]";
            else if (step == 3)
                str = @"pp[-1][-1]+1";
        }
            
        default:
            break;
    }
    
    return str;
}

- (void)changePToStringArrowAtIndex:(NSUInteger)idx pointToStrAtIndex:(NSUInteger)toIndex
{
    if (toIndex >= self.number) return;
    
    CSBlockView *strBlockView = self.strBlockViews[toIndex];
    CSArrowView *pToStrArrow = self.pToStrArrowViews[idx];
    CGPoint toPoint = CGPointMake(strBlockView.frame.origin.x, strBlockView.center.y);
    
    pToStrArrow.lineColor = [UIColor redColor];
    [pToStrArrow setFromPoint:pToStrArrow.fromPoint toPoint:toPoint animated:YES];
}

- (void)movePPArrowView:(CSArrowView *)ppArrowView pointingToPAtIndex:(NSUInteger)idx
{
    if (idx >= self.number) return;
    
    CSBlockView *pBlockView = self.pBlockViews[idx];
    CGFloat blockCenterY = pBlockView.center.y;
    [UIView animateWithDuration:0.5 animations:^{
        [ppArrowView setFromPoint:CGPointMake(self.ppArrowView.fromPoint.x, blockCenterY) toPoint:CGPointMake(pBlockView.frame.origin.x, blockCenterY) animated:NO];
        if (ppArrowView == self.ppArrowView) {
//            self.ppLabel.frame = CGRectMake(self.ppArrowView.fromPoint.x, blockCenterY - 20.0, 20.0, 20.0);
            self.ppBlockView.center = CGPointMake(self.ppBlockView.center.x, pBlockView.center.y);
            self.ppLabel.center = CGPointMake(self.ppBlockView.center.x, pBlockView.frame.origin.y + BLOCK_HEIGHT + 5.0);
        }
    }];
}

- (void)highlightBlockInArray:(NSMutableArray *)array atIndex:(NSUInteger)index
{
    CSBlockView *b = array[index];
    
    [b setStatus:BVStatusActive animated:YES];
}

- (void)highlightBlocksInClusteredBlockViewsAtIndex:(NSUInteger)index fromLetterIndex:(NSUInteger)letterIdx
{
    CSClusteredBlockView *cbv = self.clusteredBlockViews[index];
    
    NSMutableArray *indexes = [[NSMutableArray alloc] init];
    for (NSUInteger i = letterIdx; i < cbv.textArray.count; i++) {
        NSNumber *indexToHightLight = [NSNumber numberWithUnsignedInteger:i];
        [indexes addObject:indexToHightLight];
    }
    
    [cbv highlightBlockAtIndexes:indexes];
}

- (void)recoverBlocksAndArrows;
{
    for (NSUInteger i = 0; i < self.number; i++) {
        CSBlockView *pBlockView = self.pBlockViews[i];
        CSBlockView *strBlockView = self.strBlockViews[i];
        CSArrowView *pToStrArrow = self.pToStrArrowViews[i];
        CSClusteredBlockView *cbv = self.clusteredBlockViews[i];
        
        [pBlockView setStatus:BVStatusNormal animated:YES];
        [strBlockView setStatus:BVStatusNormal animated:YES];
        pToStrArrow.lineColor = [UIColor blackColor];
        [cbv recoverBlocks];
    }
}

- (void)animatedShowTipLabel:(BOOL)show
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tipLabel.alpha = show ? 1.0 : 0.0;
    }];
}

- (void)fillTipLabelWithString:(NSString *)string
{
    self.tipLabel.text = string;
}

- (void)moveTipLabelToCenterPoint:(CGPoint)centerPoint
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tipLabel.center = centerPoint;
    }];
}

#pragma mark - Private Execution Methods

- (void)_executeCompletionForPrintf:(NSUInteger)printfIdx
{
    [self setBackgroundViewGesturesEnable:YES];
    [self recoverBlocksAndArrows];
    
    [self.consoleView appendSring:[self stringToPrintf:printfIdx]];
}

- (void)_executeFirstPrintf
{
    NSUInteger printfIdx = 0;
    [self setBackgroundViewGesturesEnable:NO];
    [self nextBatchStepsOfCount:3 timeInterval:3.0 stepBlock:^(NSUInteger currentStep){
        if (currentStep == 1) {
            self.currentPPIndex++;
            [self movePPArrowView:self.ppArrowView pointingToPAtIndex:self.currentPPIndex];
            [self animatedShowTipLabel:YES];
            
            [self moveTipLabelToCenterPoint:CGPointMake(178.0, 238.0)];
        }
        else if (currentStep == 2) {
            [self highlightBlockInArray:self.pBlockViews atIndex:self.currentPPIndex];
        }
        else if (currentStep == 3) {
            [self highlightBlockInArray:self.strBlockViews atIndex:3 - self.currentPPIndex];
            [self highlightBlocksInClusteredBlockViewsAtIndex:3 - self.currentPPIndex fromLetterIndex:0];
            
            [self moveTipLabelToCenterPoint:CGPointMake(557.0, 349.0)];
        }
        [self fillTipLabelWithString:[self expressionPrintf:printfIdx stepIndex:currentStep]];
    } completionBlock:^{
        [self _executeCompletionForPrintf:printfIdx];
    }];
}

- (void)_executeSecondPrintf
{
    NSUInteger printfIdx = 1;
    [self setBackgroundViewGesturesEnable:NO];
    [self nextBatchStepsOfCount:5 timeInterval:3.0 stepBlock:^(NSUInteger currentStep){
        if (currentStep == 1) {
            self.currentPPIndex++;
            [self movePPArrowView:self.ppArrowView pointingToPAtIndex:self.currentPPIndex];
            [self animatedShowTipLabel:YES];
            
            [self moveTipLabelToCenterPoint:CGPointMake(178.0, 345.0)];
        }
        else if (currentStep == 2) {
            [self highlightBlockInArray:self.pBlockViews atIndex:self.currentPPIndex];
        }
        else if (currentStep == 3) {
            [self changePToStringArrowAtIndex:self.currentPPIndex pointToStrAtIndex:0];
            CSBlockView *pBlock = self.pBlockViews[self.currentPPIndex];
            pBlock.text = @"&str[0]";
        }
        else if (currentStep == 4) {
            [self highlightBlockInArray:self.strBlockViews atIndex:0];
            
            [self moveTipLabelToCenterPoint:CGPointMake(453.0, 92.0)];
        }
        else if (currentStep == 5) {
            [self highlightBlocksInClusteredBlockViewsAtIndex:0 fromLetterIndex:3];
            
            [self moveTipLabelToCenterPoint:CGPointMake(760.0, 136.0)];
        }
        [self fillTipLabelWithString:[self expressionPrintf:printfIdx stepIndex:currentStep]];
    } completionBlock:^{
        [self _executeCompletionForPrintf:printfIdx];
    }];
}

- (void)_executeThirdPrintf
{
    NSUInteger printfIdx = 2;
    [self setBackgroundViewGesturesEnable:NO];
    [self nextBatchStepsOfCount:3 timeInterval:3.0 stepBlock:^(NSUInteger currentStep){
        if (currentStep == 1) {
            [self highlightBlockInArray:self.pBlockViews atIndex:0];
            [self animatedShowTipLabel:YES];
            
            [self moveTipLabelToCenterPoint:CGPointMake(161.0, 125.0)];
        }
        else if (currentStep == 2) {
            [self highlightBlockInArray:self.strBlockViews atIndex:3];
            
            [self moveTipLabelToCenterPoint:CGPointMake(429.0, 600.0)];
        }
        else if (currentStep == 3) {
            [self highlightBlocksInClusteredBlockViewsAtIndex:3 fromLetterIndex:3];
            
            [self moveTipLabelToCenterPoint:CGPointMake(759.0, 461.0)];
        }
        [self fillTipLabelWithString:[self expressionPrintf:printfIdx stepIndex:currentStep]];
    } completionBlock:^{
        [self _executeCompletionForPrintf:printfIdx];
    }];
}

- (void)_executeForthPrintf
{
    NSUInteger printfIdx = 3;
    [self setBackgroundViewGesturesEnable:NO];
    [self nextBatchStepsOfCount:3 timeInterval:3.0 stepBlock:^(NSUInteger currentStep){
        if (currentStep == 1) {
            [self highlightBlockInArray:self.pBlockViews atIndex:self.currentPPIndex - 1];
            [self animatedShowTipLabel:YES];
            
            [self moveTipLabelToCenterPoint:CGPointMake(155.0, 233.0)];
        }
        else if (currentStep == 2) {
            [self highlightBlockInArray:self.strBlockViews atIndex:1];
            
            [self moveTipLabelToCenterPoint:CGPointMake(572.0, 245.0)];
        }
        else if (currentStep == 3) {
            [self highlightBlocksInClusteredBlockViewsAtIndex:1 fromLetterIndex:1];
            
            [self moveTipLabelToCenterPoint:CGPointMake(736.0, 245.0)];
        }
        [self fillTipLabelWithString:[self expressionPrintf:printfIdx stepIndex:currentStep]];
    } completionBlock:^{
        [self _executeCompletionForPrintf:printfIdx];
    }];
}

#pragma mark - Public Methods

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1];
    
    if (nodeFirst == 3) {
        if (nodeSecond == 0) {
            [self _executeFirstPrintf];
        }
        else if (nodeSecond == 1) {
            [self _executeSecondPrintf];
        }
        else if (nodeSecond == 2) {
            [self _executeThirdPrintf];
        }
        else if (nodeSecond == 3) {
            [self _executeForthPrintf];
        }
    }
}

- (void)tryToBeginNewScope
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1];
    
    NSUInteger loopCount = -1;
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 3 && nodeSecond == NSNotFound) {
            loopCount = 0;
        }
    }
    
    [[CSProgram sharedProgram] beginNewScopeWithLoopCount:loopCount];
}

- (BOOL)highlightNextLine
{
    return [super highlightNextLine];
}

@end
