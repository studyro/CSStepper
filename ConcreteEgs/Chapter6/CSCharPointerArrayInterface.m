//
//  CSCharPointerArrayInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-10.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSCharPointerArrayInterface.h"
#import "CSConsoleView.h"
#import "CSBlockView.h"
#import "CSClusteredBlockView.h"
#import "CSArrowView.h"

#define BLOCKS_PADDING_Y 55.0
#define BLOCKS_HEIGHT 52.0

#define PTR_LABEL_HEIGHT 30.0

@interface CSCharPointerArrayInterface ()
{
    __block NSInteger _counterA;
    BOOL _isNextStepBatch;
    __block BOOL _isBatchExecuting;
}
@property (strong, nonatomic) NSMutableArray *ptrBlocksViews;

@property (strong, nonatomic) NSMutableArray *ptrLabels;

@property (strong, nonatomic) NSMutableArray *ptrToStrArrowViews;

@property (strong, nonatomic) NSMutableArray *strBlockViews;

@property (strong, nonatomic) NSMutableArray *strArrowViews;

@property (assign, nonatomic) NSUInteger stringNumber;

@property (strong, nonatomic) CSConsoleView *consoleView;

@end

@implementation CSCharPointerArrayInterface

+ (NSArray *)charArrayAtIndex:(NSUInteger)idx
{
    if (idx >= 4) return nil;
    
    NSArray *result = nil;
    
    switch (idx) {
        case 0:
            result = @[@"T",@"u",@"r", @"b", @"o", @" ", @"C", @"\\0"];
            break;
            
        case 1:
            result = @[@"B", @"o", @"r", @"l", @"a", @"n", @"d", @" ", @"C", @"+", @"+", @"\\0"];
            break;
        
        case 2:
            result = @[@"A", @"c", @"c", @"e", @"s", @"s", @"\\0"];
            break;
        
        case 3:
            result = @[@"\\0"];
            break;
            
        default:
            break;
    }
    
    return result;
}

+ (NSString *)stringAtIndex:(NSUInteger)idx
{
    if (idx > 4) return nil;
    
    NSArray *charArray = [[self class] charArrayAtIndex:idx];
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < [charArray count] - 1; i++) {
        NSString *chara = [charArray objectAtIndex:i];
        [mutableString appendString:chara];
    }
    
    return [mutableString copy];
}

+ (NSArray *)strModelArrayWithIndex:(NSUInteger)idx
{
    if (idx >= 4) return nil;
    
    NSArray *value = [[self class] charArrayAtIndex:idx];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < 12; i++) {
        NSString *tempKey = [NSString stringWithFormat:@"string[%u][%u]", idx, i];
        
        NSString *tempValue = (i + 1 < [value count]) ? value[i] : @"残值";
        
        [array addObject:@{tempKey: tempValue}];
    }
    
    return [array copy];
}

+ (NSArray *)ptrArrayLoopAtIndex:(NSUInteger)idx
{
    if (idx >= 4) return nil;
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < idx; i++) {
        NSString *key = [NSString stringWithFormat:@"pstr[%u]", i];
        NSString *value = [NSString stringWithFormat:@"string[%u]", i];
        
        [mutableArray addObject:@{key: value}];
    }
    
    return [mutableArray copy];
}

- (id)init
{
    if (self = [super init]) {
        self.ptrBlocksViews = [[NSMutableArray alloc] init];
        self.ptrLabels = [[NSMutableArray alloc] init];
        self.ptrToStrArrowViews = [[NSMutableArray alloc] init];
        self.strBlockViews = [[NSMutableArray alloc] init];
        self.strArrowViews = [[NSMutableArray alloc] init];
        
        self.stringNumber = 4;
        _isNextStepBatch = NO;
        _isBatchExecuting = NO;
        
        _counterA = -1;
    }
    return self;
}

- (void)construct
{
    [super construct];
    
    NSUInteger i;
    
    for (i = 0; i < self.stringNumber; i++) {
        CSBlockView *blockView = [[CSBlockView alloc] initWithFrame:CGRectMake(255.0, 163.0 + (BLOCKS_PADDING_Y + BLOCKS_HEIGHT) * i, 115.0, BLOCKS_HEIGHT)];
        blockView.text = @"残值";
        blockView.opaque = NO;
        blockView.alpha = 0.0;
        
        [self.ptrBlocksViews addObject:blockView];
        [self.backgroundView addSubview:blockView];
        
        CGPoint fromPoint = CGPointMake(blockView.frame.origin.x + blockView.frame.size.width - 12.0, blockView.center.y);
        CGPoint toPoint = CGPointMake(fromPoint.x + 72.0, fromPoint.y);
        CSArrowView *arrowView = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        arrowView.hidden = YES;
        
        [self.ptrToStrArrowViews addObject:arrowView];
        [self.backgroundView addSubview:arrowView];
        
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(blockView.center.x, blockView.frame.origin.y + blockView.frame.size.height + 0.5 * PTR_LABEL_HEIGHT + 10.0);
        label.bounds = CGRectMake(0.0, 0.0, blockView.bounds.size.width, PTR_LABEL_HEIGHT);
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = [NSString stringWithFormat:@"pstr[%u]", i];
        label.opaque = NO, label.alpha = 0.0;
        
        [self.ptrLabels addObject:label];
        [self.backgroundView addSubview:label];
    }
    
    for (i = 0; i < self.stringNumber; i++) {
        CSClusteredBlockView *clusteredBlockView = [[CSClusteredBlockView alloc] initWithPartition:12 andFrame:CGRectMake(445.0, 164.0 + (BLOCKS_PADDING_Y + BLOCKS_HEIGHT) * i, 419.0, BLOCKS_HEIGHT)];
        clusteredBlockView.opaque = NO;
        clusteredBlockView.alpha = 0.0;
        
        [self.strBlockViews addObject:clusteredBlockView];
        [self.backgroundView addSubview:clusteredBlockView];
        
        CGPoint blockViewBottomPoint = CGPointMake(445.0, clusteredBlockView.frame.origin.y + clusteredBlockView.frame.size.height);
        CSArrowView *arrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(blockViewBottomPoint.x, blockViewBottomPoint.y + 34.0) toPoint:CGPointMake(blockViewBottomPoint.x, blockViewBottomPoint.y + 5)];
        arrowView.arrowName = [NSString stringWithFormat:@"string[%d]", i];
        arrowView.opaque = NO, arrowView.alpha = 0.0;
        
        [self.strArrowViews addObject:arrowView];
        [self.backgroundView addSubview:arrowView];
    }
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(310.0, 525.0, 412.0, 183.0)];
    self.consoleView.opaque = NO;
    self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
}

- (void)setPtrBlocksViewsVisible:(BOOL)isVisible completion:(void (^)(BOOL finished))completionBlock
{
    CGFloat finAlpha = isVisible ? 1.0 : 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        for (NSUInteger i = 0; i < self.stringNumber; i++) {
            CSBlockView *blockView = self.ptrBlocksViews[i];
            blockView.alpha = finAlpha;
            
            UILabel *label = self.ptrLabels[i];
            label.alpha = finAlpha;
        }
    } completion:^(BOOL finished){
        completionBlock(finished);
    }];
}

- (void)setStrBlockViewsVisible:(BOOL)isVisible completion:(void (^)(BOOL finished))completionBlock
{
    CGFloat finAlpha = isVisible ? 1.0 : 0.0;
    
    [UIView animateWithDuration:1.0 animations:^{
        for (NSUInteger i = 0; i < self.stringNumber; i++) {
            CSClusteredBlockView *clusteredBlockView = self.strBlockViews[i];
            clusteredBlockView.alpha = finAlpha;
            
            CSArrowView *av = self.strArrowViews[i];
            av.alpha = finAlpha;
        }
    } completion:^(BOOL finished){
        completionBlock(finished);
    }];
}

#pragma mark - Private Execution Methods

- (void)_executeSimpleAssigningWithChildNodes:(NSUInteger *)childNodes
{
    if (childNodes[0] == 0) {
        __weak typeof(self) weakSelf = self;
        [self setStrBlockViewsVisible:YES completion:^(BOOL finished){
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            for (NSUInteger i = 0; i < weakSelf.stringNumber; i++) {
                CSClusteredBlockView *clusteredBlockView = weakSelf.strBlockViews[i];
                
                clusteredBlockView.textArray = [[weakSelf class] charArrayAtIndex:i];
                
                [array addObject:@{[NSString stringWithFormat:@"string[%u][]", i]: [[weakSelf class] strModelArrayWithIndex:i]}];
            }
            
            [[CSMemModel sharedMemModel] setValueInStack:array named:@"string[][]"];
        }];
    }
    else if (childNodes[0] == 1) {
        __weak typeof(self) weakSelf = self;
        [self setPtrBlocksViewsVisible:YES completion:^(BOOL finished){
            
            NSMutableArray *valueArray = [[NSMutableArray alloc] init];
            
            for (NSUInteger i = 0; i < weakSelf.stringNumber; i++) {
                CSBlockView *blockView = weakSelf.ptrBlocksViews[i];
                
                [valueArray addObject:@{blockView.text: @"残值"}];
            }
            
            [[CSMemModel sharedMemModel] setValueInStack:valueArray named:@"pstr[]"];
        }];
    }
    else if (childNodes[0] == 2) {
        // do nothing
    }
}

- (void)_executePtrAssigningLoopWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeThird = childNodes[1];
    if (nodeThird == NSNotFound) {
        _counterA++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%u", _counterA] named:@"a"];
    }
    else {
        CSBlockView *blockView = self.ptrBlocksViews[_counterA];
        blockView.text = [NSString stringWithFormat:@"string[%u]", _counterA];
        
        CSArrowView *arrowView = self.ptrToStrArrowViews[_counterA];
        arrowView.hidden = NO;
        
        [[CSMemModel sharedMemModel] setValueInStack:[[self class] ptrArrayLoopAtIndex:_counterA] named:@"pstr"];
    }
}

- (void)_executePrintfLoopWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeThird = childNodes[1];
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.consoleView.alpha = 1.0;
        }];
        
        [self setBackgroundViewGesturesEnable:NO];
        [self nextBatchStepsOfCount:(self.stringNumber - 1) * 2 - 1 timeInterval:1.5 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [self setBackgroundViewGesturesEnable:YES];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        _counterA++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%u", _counterA] named:@"a"];
    }
    else {
        [self.consoleView appendSring:[NSString stringWithFormat:@"Language %u is %@\n", _counterA + 1, [[self class] stringAtIndex:_counterA]]];
    }
}

- (void)_endAssigningLoop
{
    _counterA = -1;
}

#pragma mark - Public Interface

- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse
{
    [[CSMemModel sharedMemModel] openStackWithName:stackName collapseFormerVariables:shouldCollapse];
    if ([stackName isEqualToString:kCSStackNameMain]) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:[self stackVariableArrayWithArray:nil name:@"string" count:4] named:@"string"];
        [[CSMemModel sharedMemModel] pushValue:[self stackVariableArrayWithArray:nil name:@"ptr" count:4] named:@"ptr"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"a"];
        [[CSMemModel sharedMemModel] commitTransaction];
    }
}

- (void)tryToBeginNewScope
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2];
    
    NSInteger loopCount = -1;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeSecond == NSNotFound) {
            loopCount = 0;
        }
        else if (nodeSecond == 3 && nodeThird == NSNotFound)
        {
            loopCount = self.stringNumber;
        }
        else if (nodeSecond == 4 && nodeThird == NSNotFound)
        {
            loopCount = self.stringNumber - 1;
        }
    }
    
    [[CSProgram sharedProgram] beginNewScopeWithLoopCount:loopCount];
}

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2];
    
    NSUInteger childNodes[2] = {nodeSecond, nodeThird};
    if (nodeSecond == NSNotFound) {
        [self pushNewStackNamed:kCSStackNameMain shouldCollapse:NO];
    }
    if (nodeSecond <= 2) {
        [self _executeSimpleAssigningWithChildNodes:childNodes];
    }
    if (nodeSecond == 3) {
        if (nodeThird == NSNotFound && [[CSProgram sharedProgram] isAtTheLoopBeginning])
            _counterA = -1;
        [self _executePtrAssigningLoopWithChildNodes:childNodes];
    }
    if (nodeSecond == 4) {
        if (nodeThird == NSNotFound && [[CSProgram sharedProgram] isAtTheLoopBeginning])
            _counterA = -1;
        [self _executePrintfLoopWithChildNodes:childNodes];
    }
}

- (BOOL)highlightNextLine
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2];
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning] && !_isBatchExecuting) {
        // means first time approach a loop check.
        if (nodeSecond == 4 && nodeThird == NSNotFound) {
            _isNextStepBatch = YES;
        }
    }
    
    return [super highlightNextLine];
}

@end
