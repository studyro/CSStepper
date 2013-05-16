//
//  CSStringSort.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-15.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStringSortInterface.h"
#import "CSBlockView.h"
#import "CSArrowView.h"
#import "CSClusteredBlockView.h"
#import "NSString+Separator.h"
#import "CSConsoleView.h"

#define BLOCKS_PADDING_Y 55.0
#define BLOCKS_HEIGHT 52.0

#define PTR_LABEL_HEIGHT 30.0

#define T_BLOCK_WIDTH 44.0
#define T_BLOCK_HEIGHT 25.0
#define T_BLOCK_PADDING_X 20.0
#define T_BLOCK_PADDING_Y 15.0

#define I_BLOCK_START_X (445.0 + _unitWidth * 7 + 50)
#define I_BLOCK_START_Y 163.0

@interface CSStringSortInterface ()
{
    NSInteger _countI;
    NSInteger _countJ;
    CGFloat _unitWidth;
    NSString *_tempStr;
    
    BOOL _isBatchExecuting;
    BOOL _isNextStepBatch;
}
@property (assign, nonatomic) NSUInteger number;
@property (strong, nonatomic) NSMutableArray *langArray;

@property (strong, nonatomic) NSMutableArray *ptrBlockViews;
@property (strong, nonatomic) NSMutableArray *ptrLabels;
@property (strong, nonatomic) NSMutableArray *ptrArrows;
@property (strong, nonatomic) NSMutableArray *strBlockViews;

@property (strong, nonatomic) CSBlockView *highlightCircleView;
@property (strong, nonatomic) CSBlockView *tBlockView;
@property (strong, nonatomic) CSArrowView *tArrowView;

@property (strong, nonatomic) CSConsoleView *consoleView;

@property (strong, nonatomic) CSBlockView *iBlock;
@property (strong, nonatomic) CSBlockView *jBlock;

@end

@implementation CSStringSortInterface

- (id)init
{
    if (self = [super init]) {
        self.number = 5;
        _countI = -1;
        _countJ = -1;
        self.langArray = [@[@"pascal", @"basic", @"cobol", @"prolog", @"lisp"] mutableCopy];
        self.ptrBlockViews = [[NSMutableArray alloc] initWithCapacity:5];
        self.ptrLabels = [[NSMutableArray alloc] initWithCapacity:5];
        self.strBlockViews = [[NSMutableArray alloc] initWithCapacity:5];
        self.ptrArrows = [[NSMutableArray alloc] initWithCapacity:5];
        
        _isBatchExecuting = NO;
        _isNextStepBatch = NO;
    }
    return self;
}

- (void)construct
{
    [super construct];
    
    _unitWidth = 35.0;
    
    NSUInteger i;
    for (i = 0; i < self.number; i++) {
        CSBlockView *blockView = [[CSBlockView alloc] initWithFrame:CGRectMake(255.0, 163.0 + (BLOCKS_PADDING_Y + BLOCKS_HEIGHT) * i, 115.0, BLOCKS_HEIGHT)];
        blockView.opaque = NO;
        blockView.alpha = 0.0;
        
        [self.ptrBlockViews addObject:blockView];
        [self.backgroundView addSubview:blockView];
        
        [self recoverPtrToStrArrowAtIndex:i];
        
        UILabel *label = [[UILabel alloc] init];
        label.center = CGPointMake(blockView.center.x, blockView.frame.origin.y + blockView.frame.size.height + 0.5 * PTR_LABEL_HEIGHT + 10.0);
        label.bounds = CGRectMake(0.0, 0.0, blockView.bounds.size.width, PTR_LABEL_HEIGHT);
        label.font = [UIFont systemFontOfSize:16.0];
        label.text = [NSString stringWithFormat:@"pstr[%u]", i];
        label.opaque = NO, label.alpha = 0.0;
        label.backgroundColor = [UIColor clearColor];
        
        [self.ptrLabels addObject:label];
        [self.backgroundView addSubview:label];
    }
    
    for (i = 0; i < self.number; i++) {
        NSUInteger count = [self.langArray[i] length] + 1;
        CSClusteredBlockView *clusteredBlockView = [[CSClusteredBlockView alloc] initWithPartition:count andFrame:CGRectMake(445.0, 164.0 + (BLOCKS_PADDING_Y + BLOCKS_HEIGHT) * i, count * _unitWidth, BLOCKS_HEIGHT)];
        clusteredBlockView.opaque = NO;
        clusteredBlockView.alpha = 0.0;
        clusteredBlockView.textArray = [self.langArray[i] separatedCharStringArrayWithTail:YES];
        
        [self.strBlockViews addObject:clusteredBlockView];
        [self.backgroundView addSubview:clusteredBlockView];
    }
    
    self.highlightCircleView = [[CSBlockView alloc] init];
    self.highlightCircleView.opaque = NO;
    self.highlightCircleView.alpha = 0.0;
    [self.backgroundView addSubview:self.highlightCircleView];
    /*
    self.tBlockView = [[CSBlockView alloc] init];
    self.tBlockView.bounds = CGRectMake(0.0, 0.0, T_BLOCK_WIDTH, T_BLOCK_HEIGHT);
    self.tBlockView.opaque = NO;
    self.tBlockView.alpha = 0.0;
    self.tBlockView.text = @"t";
    self.tArrowView = [[CSArrowView alloc] init];
    self.tArrowView.hidden = YES;
    [self.backgroundView addSubview:self.tBlockView];
    [self.backgroundView addSubview:self.tArrowView];
    */
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(310.0, 525.0, 412.0, 183.0)];
    self.consoleView.opaque = NO;
    self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
    
    self.iBlock = [[CSBlockView alloc] initWithFrame:CGRectMake(I_BLOCK_START_X, I_BLOCK_START_Y, 60.0, 40.0)];
    self.iBlock.text = @"i = 0";
    self.iBlock.borderWidth = 2.0;
    self.iBlock.opaque = NO;
    self.iBlock.alpha = 0.0;
    [self.backgroundView addSubview:self.iBlock];
    
    self.jBlock = [[CSBlockView alloc] initWithFrame:CGRectMake(I_BLOCK_START_X, I_BLOCK_START_Y, 60.0, 40.0)];
    self.jBlock.text = @"j = 0";
    self.jBlock.borderWidth = 2.0;
    self.jBlock.opaque = NO;
    self.jBlock.alpha = 0.0;
    [self.backgroundView addSubview:self.jBlock];
}

- (void)highlightCircleStringAtIndex:(NSUInteger)stringIndex
                            andIndex:(NSUInteger)anotherStringIndex
                           charIndex:(NSUInteger)charIndex
{
    if (stringIndex == anotherStringIndex) return;
    
    NSUInteger frontIndex, behindIndex;
    
    if (stringIndex > anotherStringIndex) {
        behindIndex = stringIndex;
        frontIndex = anotherStringIndex;
    }
    else {
        behindIndex = anotherStringIndex;
        frontIndex = stringIndex;
    }
    
    CSClusteredBlockView *fcbv = self.strBlockViews[frontIndex];
    CSClusteredBlockView *bcbv = self.strBlockViews[behindIndex];
    fcbv.backgroundColor = [UIColor whiteColor];
    bcbv.backgroundColor = [UIColor whiteColor];
    CGFloat startX = fcbv.frame.origin.x;
    CGFloat endY = bcbv.frame.origin.y + bcbv.frame.size.height;
    
    CGFloat x = startX + charIndex * _unitWidth;
    CGFloat y = fcbv.frame.origin.y;
    CGFloat w = _unitWidth;
    CGFloat h = endY - y;
    
    CGRect frame = CGRectInset(CGRectMake(x, y, w, h), -10.0, -10.0);
    
    if (self.highlightCircleView.alpha == 0.0)
        self.highlightCircleView.frame = frame;
    [UIView animateWithDuration:0.5 animations:^{
        if (self.highlightCircleView.alpha == 0.0)
            self.highlightCircleView.alpha = 0.5;
        else
            self.highlightCircleView.frame = frame;
        
        self.highlightCircleView.backgroundColor = [UIColor blueColor];
    }];
}

- (void)fadeStringBlockViewExceptForIndex:(NSUInteger)index
                                 andIndex:(NSUInteger)anotherIndex
{
    if (index >= self.number || anotherIndex >= self.number) return;
    
    [UIView animateWithDuration:0.5 animations:^{
        for (NSUInteger i = 0; i < self.number; i++) {
            CSClusteredBlockView *cv = self.strBlockViews[i];
            if (i != index && i != anotherIndex) {
                cv.alpha = 0.1;
            }
        }
    }];
}

- (void)recoverStringBlockViewsAlpha
{
    [UIView animateWithDuration:0.5 animations:^{
        for (CSClusteredBlockView *cbv in self.strBlockViews) {
            cbv.alpha = 1.0;
            cbv.backgroundColor = [UIColor clearColor];
        }
        self.highlightCircleView.alpha = 0.0;
    }];
}

- (void)recoverPtrToStrArrowAtIndex:(NSUInteger)index
{
    if (index >= self.number) return;
    
    CSBlockView *bv = self.ptrBlockViews[index];
    CGPoint fromPoint = CGPointMake(bv.frame.origin.x + bv.frame.size.width - 12.0, bv.center.y);
    CGPoint toPoint = CGPointMake(fromPoint.x + 72.0, fromPoint.y);
    
    CSArrowView *av = nil;
    if (index >= [self.ptrArrows count]) {
        // means this av hasn't been inited yet.
        CSArrowView *arrowView = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        arrowView.hidden = YES;
        
        [self.ptrArrows addObject:arrowView];
        [self.backgroundView addSubview:arrowView];
    }
    else {
        av = self.ptrArrows[index];
        [av setFromPoint:fromPoint toPoint:toPoint animated:YES];
    }
}

- (void)switchStringBlockViewAtIndex:(NSUInteger)index
                            andIndex:(NSUInteger)anotherIndex
{
    if (index >= self.number || anotherIndex >= self.number) return;
    
    CSClusteredBlockView *cbv = self.strBlockViews[index];
    CSClusteredBlockView *anotherCbv = self.strBlockViews[anotherIndex];
    CGPoint tOrigin = cbv.frame.origin;
    
    [UIView animateWithDuration:1.0 animations:^{
        [self recoverPtrToStrArrowAtIndex:index];
        [self recoverPtrToStrArrowAtIndex:anotherIndex];
        
        cbv.frame = CGRectMake(anotherCbv.frame.origin.x, anotherCbv.frame.origin.y, cbv.frame.size.width, cbv.frame.size.height);
        anotherCbv.frame = CGRectMake(tOrigin.x, tOrigin.y, anotherCbv.frame.size.width, anotherCbv.frame.size.height);
    } completion:^(BOOL finished){
        [self.strBlockViews exchangeObjectAtIndex:index withObjectAtIndex:anotherIndex];
    }];
}

- (void)showTBlockPointingToIndex:(NSUInteger)index
{
    if (index >= self.number) return;
    /*
    CSBlockView *bv = self.ptrBlockViews[index];
    CSClusteredBlockView *cbv = self.strBlockViews[index];
    self.tBlockView.frame = bv.frame;
    self.tBlockView.alpha = 1.0;
    
    CGRect newFrame = CGRectMake(bv.frame.origin.x + bv.frame.size.width + T_BLOCK_PADDING_X, bv.frame.origin.y - T_BLOCK_HEIGHT - T_BLOCK_PADDING_Y, T_BLOCK_WIDTH, T_BLOCK_HEIGHT);
    
    [UIView animateWithDuration:0.8 animations:^{
        self.tBlockView.frame = newFrame;
    } completion:^(BOOL finished){
        self.tArrowView.hidden = NO;
        CGPoint fromPoint = self.tBlockView.center;
        CGPoint toPoint = cbv.frame.origin;
        [self.tArrowView setFromPoint:fromPoint toPoint:toPoint animated:NO];
    }];*/
}

- (void)showIorJBlock:(CSBlockView *)blockView toIndex:(NSUInteger)index
{
    if (index >= self.number || (blockView != self.iBlock && blockView != self.jBlock)) return;
    
    NSString *text = [NSString stringWithFormat:@"%@ = %d", blockView==self.iBlock?@"i":@"j", index];
    CSClusteredBlockView *cvb = self.strBlockViews[index];
    
    [UIView animateWithDuration:0.5 animations:^{
        blockView.alpha = 1.0;
        blockView.frame = CGRectMake(I_BLOCK_START_X, cvb.frame.origin.y, CGRectGetWidth(blockView.frame), CGRectGetHeight(blockView.frame));
    } completion:^(BOOL finished){
        blockView.text = text;
    }];
}

- (void)dismissTBlock
{
    if (self.tBlockView.alpha == 0.0) return;
    
    [UIView animateWithDuration:0.5 animations:^ {
        self.tBlockView.alpha = 0.0;
        self.tArrowView.hidden = YES;
    }];
}

- (NSArray *)langStackValuesWithPrefix:(NSString *)prefix
{
    return @[@{[NSString stringWithFormat:@"%@[0]", prefix]: self.langArray[0]},
             @{[NSString stringWithFormat:@"%@[1]", prefix]: self.langArray[1]},
             @{[NSString stringWithFormat:@"%@[2]", prefix]: self.langArray[2]},
             @{[NSString stringWithFormat:@"%@[3]", prefix]: self.langArray[3]},
             @{[NSString stringWithFormat:@"%@[4]", prefix]: self.langArray[4]}];
}

- (NSUInteger)stepCountOfString:(NSString *)aString comparingToString:(NSString *)bString
{
    NSArray *aChars = [aString separatedCharStringArrayWithTail:NO];
    NSArray *bChars = [bString separatedCharStringArrayWithTail:NO];
    
    __block NSUInteger stepCount = 0;
    
    [aChars enumerateObjectsUsingBlock:^(NSString *a, NSUInteger idx, BOOL *stop){
        stepCount++;
        NSString *b = bChars[idx];
        NSComparisonResult comparisionResult = [a compare:b];
        
        if (comparisionResult != NSOrderedSame)
            *stop = YES;
    }];
    
    return stepCount;
}

#pragma mark - Private Execution Methods In main()

- (void)_executeSimpleAssignInMainWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeSecond = childNodes[1];
    
    if (nodeSecond == 0) {
        [[CSMemModel sharedMemModel] pushValue:[self langStackValuesWithPrefix:@"proname"]
                                         named:@"proname"];
        
        [UIView animateWithDuration:1.0 animations:^{
            for (NSUInteger i = 0; i < self.number; i++) {
                CSBlockView *blockView = self.ptrBlockViews[i];
                UILabel *ptrLabel = self.ptrLabels[i];
                CSClusteredBlockView *clusteredBlockView = self.strBlockViews[i];
                
                blockView.alpha = 1.0;
                ptrLabel.alpha = 1.0;
                clusteredBlockView.alpha = 1.0;
            }
        } completion:^(BOOL finished){
            for (NSUInteger i = 0; i < self.number; i++) {
                CSArrowView *arrowView = self.ptrArrows[i];
                arrowView.hidden = NO;
            }
        }];
    }
    else if (nodeSecond == 1) {
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
    }
}

- (void)_executePrintfWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeThird = childNodes[2];
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.consoleView.alpha = 1.0;
        }];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self nextBatchStepsOfCount:self.number * 2 - 1 timeInterval:1.5 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = -1;
        
        _countI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%u", _countI] named:@"a"];
    }
    else {
        [self.consoleView appendSring:[NSString stringWithFormat:@"%@\n", self.langArray[_countI]]];
    }
}

#pragma mark - Private Execution Methods In sortstr()

- (void)_executeStepInSortStrWithChildNodes:(NSUInteger *)childNodes
{
    [[CSMemModel sharedMemModel] beginTransaction];
    [[CSMemModel sharedMemModel] openStackWithName:@"SortStr" collapseFormerVariables:YES];
    [[CSMemModel sharedMemModel] pushValue:[self langStackValuesWithPrefix:@"v"]
                                     named:@"v"];
    
    [[CSMemModel sharedMemModel] pushValue:@"5"
                                     named:@"n"];
    [[CSMemModel sharedMemModel] commitTransaction];
}

- (void)_executeSimpleAssignInSortstrWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeSecond = childNodes[1];
    
    if (nodeSecond == 0) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"j"];
        [[CSMemModel sharedMemModel] commitTransaction];
    }
    else if (nodeSecond == 1) {
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"temp"];
    }
}

- (void)_executeStringComparing
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [self fadeStringBlockViewExceptForIndex:_countI andIndex:_countJ];
    self.backgroundView.backgroundColor = [UIColor lightGrayColor];
    [self nextBatchStepsOfCount:[self stepCountOfString:self.langArray[_countI]
                                      comparingToString:self.langArray[_countJ]]
                   timeInterval:2.0
                      stepBlock:^(NSUInteger currentStep){
                          [self highlightCircleStringAtIndex:_countI
                                                    andIndex:_countJ
                                                   charIndex:currentStep - 1];
                          // TODO: explicitly show the compare result?
                      }
                completionBlock:^{
                    [self recoverStringBlockViewsAlpha];
                    self.backgroundView.backgroundColor = [UIColor whiteColor];
                    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                }];
}

- (void)_executeIJSwitchWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeFifth = childNodes[4];
    
    if (nodeFifth == NSNotFound) {
        [self _executeStringComparing];
    }
    else {
        if (nodeFifth == 0) {
            [self showTBlockPointingToIndex:_countI];
            
            _tempStr = self.langArray[_countI];
            [[CSMemModel sharedMemModel] setValueInStack:_tempStr named:@"temp"];
        }
        else if (nodeFifth == 1) {
            CSArrowView *arrowI = self.ptrArrows[_countI];
            CSClusteredBlockView *jStrView = self.strBlockViews[_countJ];
            [arrowI setFromPoint:arrowI.fromPoint toPoint:CGPointMake(jStrView.frame.origin.x, jStrView.frame.origin.y + 0.5 * jStrView.frame.size.height) animated:YES];
            
            self.langArray[_countI] = self.langArray[_countJ];
            
            [[CSMemModel sharedMemModel] setValueInStack:[self langStackValuesWithPrefix:@"v"]
                                                   named:@"v"];
        }
        else if (nodeFifth == 2) {
            CSArrowView *arrowJ = self.ptrArrows[_countJ];
            CSClusteredBlockView *tStrView = self.strBlockViews[_countI];
            // TODO: hide and reorder arrows?
            [arrowJ setFromPoint:arrowJ.fromPoint toPoint:CGPointMake(tStrView.frame.origin.x, tStrView.frame.origin.y + 0.5 * tStrView.frame.size.height) animated:YES];
            
            self.langArray[_countJ] = _tempStr;
            
            [[CSMemModel sharedMemModel] setValueInStack:[self langStackValuesWithPrefix:@"v"]
                                                   named:@"v"];
        }
    }
}

- (void)_executeJLoopWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeForth = childNodes[3];
    
    if (nodeForth == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countJ = _countI;
        _countJ++;
        [self showIorJBlock:self.jBlock toIndex:_countJ];
        
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countJ] named:@"j"];
    }
    else if (nodeForth == 0) {
        [self _executeIJSwitchWithChildNodes:childNodes];
    }
}

- (void)_executeILoopWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeThird = childNodes[2];
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = -1;
        _countI++;
        [self showIorJBlock:self.iBlock toIndex:_countI];
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
    }
    else if (nodeThird == 0) {
        [self _executeJLoopWithChildNodes:childNodes];
    }
}

#pragma mark - Public Interfaces

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
    nodeSecond = [currentIndexPath indexAtPosition:1],
    nodeThird = [currentIndexPath indexAtPosition:2],
    nodeForth = [currentIndexPath indexAtPosition:3],
    nodeFifth = [currentIndexPath indexAtPosition:4];
    
    NSUInteger childNodes[] = {nodeFirst, nodeSecond, nodeThird, nodeForth, nodeFifth};
    
    if (nodeFirst == 1) {
        if (nodeSecond <= 1) {
            [self _executeSimpleAssignInMainWithChildNodes:childNodes];
        }
        else if (nodeSecond == 2) {
            if ([[CSProgram sharedProgram] isAtTheLoopBeginning] == NO) {
                [[CSMemModel sharedMemModel] recycleStackActivatingLevel:1];
                self.iBlock.hidden = YES;
                self.jBlock.hidden = YES;
            }
        }
        else if (nodeSecond == 3) {
            [self _executePrintfWithChildNodes:childNodes];
        }
    }
    else if (nodeFirst == 2) {
        if (nodeSecond == NSNotFound) {
            [self _executeStepInSortStrWithChildNodes:childNodes];
        }
        else if (nodeSecond <= 1) {
            [self _executeSimpleAssignInSortstrWithChildNodes:childNodes];
        }
        else if (nodeSecond == 2) {
            [self _executeILoopWithChildNodes:childNodes];
        }
    }
}

- (void)tryToBeginNewScope
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2],
               nodeForth = [currentIndexPath indexAtPosition:3],
               nodeFifth = [currentIndexPath indexAtPosition:4];
    
    NSInteger loopCount = -1;
    NSIndexPath *nextIndexPath = nil;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 1) {
            if (nodeSecond == NSNotFound) {
                // main
                [[CSMemModel sharedMemModel] openStackWithName:kCSStackNameMain collapseFormerVariables:NO];
                loopCount = 0;
            }
            else if (nodeSecond == 2) {
                // `sortstr` function call
                nextIndexPath = [NSIndexPath indexPathWithIndex:2];
            }
            else if (nodeSecond == 3) {
                // printf
                loopCount = self.number;
            }
        }
        else if (nodeFirst == 2) {
            if (nodeSecond == NSNotFound) {
                // sortstr
                loopCount = 0;
            }
            else if (nodeSecond == 2) {
                if (nodeThird == NSNotFound) {
                    // i loop
                    loopCount = self.number - 1;
                }
                else if (nodeThird == 0) {
                    if (nodeForth == NSNotFound) {
                        // j loop
                        loopCount = self.number - _countI - 1;
                    }
                    else if (nodeForth == 0) {
                        if (nodeFifth == NSNotFound) {
                            // if
                            NSString *iString = self.langArray[_countI];
                            NSString *jString = self.langArray[_countJ];
                            if ([iString compare:jString] == NSOrderedDescending) {
                                loopCount = 0;
                            }
                        }
                        else if (nodeFifth == 2) {
                            [self switchStringBlockViewAtIndex:_countI andIndex:_countJ];
                        }
                    }
                }
            }
        }
    }
    
    if (nextIndexPath) {
        [[CSProgram sharedProgram] beginNewScopeAtIndexPath:nextIndexPath];
    }
    else {
        [[CSProgram sharedProgram] beginNewScopeWithLoopCount:loopCount];
    }
}

- (BOOL)highlightNextLine
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2];
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning] && !_isBatchExecuting) {
        // means first time approach a loop check.
        if (nodeSecond == 3 && nodeThird == NSNotFound) {
            _isNextStepBatch = YES;
        }
    }
    
    return [super highlightNextLine];
}

@end
