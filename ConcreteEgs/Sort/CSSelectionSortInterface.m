//
//  CSSelectionSortInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-1.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSSelectionSortInterface.h"

#define ARROW_BLOCKS_Y_PADDING 22.0
#define ARROW_HEIGHT 30.0

@interface CSSelectionSortInterface ()
{
    NSInteger _counterI;
    NSInteger _counterK;
    NSUInteger _varJ;
    
    __block BOOL _isBatchExecuting;
    // a flag to state if the next step should be executed in a batch.
    __block BOOL _isNextStepBatch;
}

@property (strong, nonatomic) UILabel *aKLabel;
@property (strong, nonatomic) UILabel *aJLabel;

@end

@implementation CSSelectionSortInterface

- (id)init
{
    if (self = [super init]) {
        _isBatchExecuting = NO;
        _varJ = -1;
        _counterI = -1;
        _counterK = -1;
        
        _isNextStepBatch = NO;
    }
    
    return self;
}

- (void)construct
{
    [super construct];
    
    CSBlockView *b = self.numberBlockViews[0];
    [b setStatus:BVStatusToBeActive animated:YES];
    
    self.aKLabel = [[UILabel alloc] init];
    self.aKLabel.center = CGPointMake(self.leftComparisonBlockView.center.x, self.leftComparisonBlockView.center.y + self.leftComparisonBlockView.bounds.size.height * 0.5 + 20.0);
    self.aKLabel.bounds = CGRectMake(0.0, 0.0, 40.0, 30.0);
    self.aJLabel = [[UILabel alloc] init];
    self.aJLabel.center = CGPointMake(self.rightComparisonBlockView.center.x, self.rightComparisonBlockView.center.y + self.rightComparisonBlockView.bounds.size.height * 0.5 + 20.0);
    self.aJLabel.bounds = CGRectMake(0.0, 0.0, 40.0, 30.0);
    
    self.aKLabel.text = @"a[k]", self.aKLabel.hidden = YES;
    self.aJLabel.text = @"a[j]", self.aJLabel.hidden = YES;
    
    [self.backgroundView addSubview:self.aKLabel];
    [self.backgroundView addSubview:self.aJLabel];
}

#pragma mark - Views Modifier
- (void)_toBeActiveBlockViewsBeginWithIndex:(NSUInteger)index
{
    for (NSUInteger i = index; i < self.number; i++) {
        [self setBlockViewStatus:BVStatusToBeActive atIndex:i];
    }
}

- (void)_inactiveBlockViewsBeforeIndex:(NSInteger)index
{
    for (NSInteger i = index; i >= 0; i--) {
        [self setBlockViewStatus:BVStatusInactive atIndex:i];
    }
}

- (void)pointArrowJToIndex:(NSUInteger)index
{
    CSBlockView *blockView = (CSBlockView *)self.numberBlockViews[index];
    CGPoint fromPoint = CGPointMake(blockView.center.x, blockView.frame.origin.y - ARROW_BLOCKS_Y_PADDING - ARROW_HEIGHT);
    CGPoint toPoint = CGPointMake(blockView.center.x, blockView.frame.origin.y - ARROW_BLOCKS_Y_PADDING);
    
    if (!self.arrowJ) {
        self.arrowJ = [[CSArrowView alloc] initFromPoint:fromPoint toPoint:toPoint];
        
        [self.backgroundView addSubview:self.arrowJ];
    }
    else {
        [self.arrowJ moveParallelyPointingToPoint:toPoint animated:YES];
    }
    self.arrowJ.arrowName = [NSString stringWithFormat:@"j=%d", index];
}

- (NSArray *)_arrayAValue
{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.number; i++) {
        CSBlockView *blockView = (CSBlockView *)self.numberBlockViews[i];
        
        if (blockView.text.length == 0)
            [mutableArray addObject:@{[NSString stringWithFormat:@"a[%d]", i]: kCSVariableValueUnassigned}];
        else
            [mutableArray addObject:@{[NSString stringWithFormat:@"a[%d]", i]: blockView.text}];
    }
    
    return [mutableArray copy];
}

#pragma mark - Concrete Execution Implementation

- (void)_executeMain
{
    // do no thing
}

- (void)_executeSimpleAssigningUnderMainWithNodeSecond:(NSUInteger)nodeSecond
{
    if (nodeSecond == 0) {
        
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"j"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"k"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"t"];
        [[CSMemModel sharedMemModel] commitTransaction];
    }
    else if (nodeSecond == 1) {
        NSArray *arrayA = @[@{@"a[0]": kCSVariableValueUnassigned}, @{@"a[1]": kCSVariableValueUnassigned}, @{@"a[2]": kCSVariableValueUnassigned}, @{@"a[3]": kCSVariableValueUnassigned}, @{@"a[4]": kCSVariableValueUnassigned}];
        
        [[CSMemModel sharedMemModel] pushValue:arrayA named:@"a[5]"];
    }
}

- (void)_executeScanfWithChildNodes:(NSUInteger *)childNodes
{
    // set _autoExecuting to yes to avoid duplicatedly fire the timer.
    NSUInteger nodeThird = childNodes[1];
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self nextBatchStepsOfCount:self.number * 2 - 1 timeInterval:0.5 stepBlock:^(NSUInteger stepCount){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        _counterI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _counterI] named:@"i"];
    }
    else {
        [self setRandomizedNumberToBlockViewAtIndex:_counterI];
        [[CSMemModel sharedMemModel] setValueInStack:[self _arrayAValue] named:@"a[5]"];
    }
}

- (void)_executeILoopWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeThird = childNodes[1];
    NSUInteger nodeFourth = childNodes[2];
    if (nodeThird == NSNotFound) {
        // i Loop is going to begin.
        _counterI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _counterI] named:@"i"];
        
        if (_counterI < self.number)
            [self pointArrowIToIndex:_counterI];
    }
    else if (nodeThird == 0) {
        // begin a new i loop, so i was changed
        [self _toBeActiveBlockViewsBeginWithIndex:_counterI];
        [self _inactiveBlockViewsBeforeIndex:(NSInteger)_counterI - 1];
        _varJ = _counterI;
        [self pointArrowJToIndex:_counterI];
        
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _varJ] named:@"j"];
    }
    else if (nodeThird == 1) {
        if (nodeFourth == NSNotFound && [[CSProgram sharedProgram] isAtTheLoopBeginning])
            _counterK = _counterI;
        [self _executeKLoopWithChildNodes:childNodes];
    }
    else if (nodeThird == 2) {
        if (nodeFourth == NSNotFound) [self _endKLoop];
        [self _executeIandJComparingScopeWithChildNodes:childNodes];
    }
}

- (void)_prepareForKLoop
{
    self.leftComparisonBlockView.hidden = NO;
    self.rightComparisonBlockView.hidden = NO;
    self.comparisonResultLabel.hidden = NO;
    self.aKLabel.hidden = NO;
    self.aJLabel.hidden = NO;
}

- (void)_endKLoop
{
    self.leftComparisonBlockView.text = @"", self.leftComparisonBlockView.hidden = YES;
    self.rightComparisonBlockView.text = @"", self.rightComparisonBlockView.hidden = YES;
    self.comparisonResultLabel.text = @"", self.comparisonResultLabel.hidden = YES;
    
    self.aKLabel.hidden = YES, self.aJLabel.hidden = YES;
    
    [self.arrowK removeFromSuperview];
    self.arrowK = nil;
}

- (void)_executeKLoopWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeFourth = childNodes[2];
    NSUInteger nodeFifth = childNodes[3];
    if (nodeFourth == NSNotFound) {
        [self _prepareForKLoop];
        _counterK++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _counterK] named:@"k"];
        
        if (_counterK < self.number)
            [self pointArrowKToIndex:_counterK];
    }
    else if (nodeFourth == 0) {
        if (nodeFifth == NSNotFound) {
            NSUInteger ak = [self numberInBlockViewAtIndex:_counterK];
            NSUInteger aj = [self numberInBlockViewAtIndex:_varJ];
            
            self.leftComparisonBlockView.text = [NSString stringWithFormat:@"%u", ak];
            self.rightComparisonBlockView.text = [NSString stringWithFormat:@"%u", aj];
            self.comparisonResultLabel.text = ak < aj ? @"<" : @">";
        }
        else if (nodeFifth == 0) {
            _varJ = _counterK;
            [self pointArrowJToIndex:_varJ];
            
            [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _varJ] named:@"j"];
        }
    }
}

- (void)_executeIandJComparingScopeWithChildNodes:(NSUInteger *)childNodes
{
    NSUInteger nodeFourth = childNodes[2];
    static NSUInteger temp = 0;
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        
        [self setBlockViewStatus:BVStatusToBeActive atIndex:_varJ];
        [self setBlockViewStatus:BVStatusToBeActive atIndex:_counterI];
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [self nextBatchStepsOfCount:2 timeInterval:1.0 stepBlock:^(NSUInteger stepCount){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            
            [self setBlockViewStatus:BVStatusInactive atIndex:_varJ];
            [self setBlockViewStatus:BVStatusInactive atIndex:_counterI];
            
            [self.arrowK removeFromSuperview];
            self.arrowK = nil;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    
    if (nodeFourth == NSNotFound) {
        // compare i, j
    }
    else if (nodeFourth == 0) {
        // t = ai
        temp = [self numberInBlockViewAtIndex:_counterI];
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", [self numberInBlockViewAtIndex:_counterI]] named:@"t"];
    }
    else if (nodeFourth == 1) {
        // ai = aj
        [self setBlockViewStatus:BVStatusActive atIndex:_counterI];
        NSMutableArray *mutableArray = [[self _arrayAValue] mutableCopy];
        mutableArray[_counterI] = mutableArray[_varJ];
        [[CSMemModel sharedMemModel] setValueInStack:mutableArray named:@"a[5]"];
        
        [self setBlockViewAtIndex:_counterI withNumber:[self numberInBlockViewAtIndex:_varJ]];
    }
    else if (nodeFourth == 2) {
        // aj = t
        [self setBlockViewStatus:BVStatusActive atIndex:_varJ];
        NSMutableArray *mutableArray = [[self _arrayAValue] mutableCopy];
        mutableArray[_varJ] = [NSString stringWithFormat:@"%d", temp];
        [[CSMemModel sharedMemModel] setValueInStack:mutableArray named:@"a[5]"];
        
        [self setBlockViewAtIndex:_varJ withNumber:temp];
    }
    
    // if j == i, then it will not begin any new scope, so prepare for next loop.
    if (_varJ == _counterI) {
        [self.arrowJ removeFromSuperview];
        self.arrowJ = nil;
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
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        
        [self nextBatchStepsOfCount:(self.number) * 2 - 1 timeInterval:1.5 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        _counterI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _counterI] named:@"i"];
    }
    else if (nodeThird == 0) {
        // TODO : refresh console view.
        [self.consoleView appendSring:[NSString stringWithFormat:@"%d\n", [self numberInBlockViewAtIndex:_counterI]]];
    }
}

#pragma mark - Public Interface

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2], nodeFourth = [currentIndexPath indexAtPosition:3], nodeFifth = [currentIndexPath indexAtPosition:4];;
    
    NSUInteger childNodes[4] = {nodeSecond, nodeThird, nodeFourth, nodeFifth};
    
    if (nodeSecond == NSNotFound) {
        // do nothing
    }
    else if (nodeSecond == 0 || nodeSecond == 1) {
        [self _executeSimpleAssigningUnderMainWithNodeSecond:nodeSecond];
    }
    else if (nodeSecond == 2) {
        if (nodeThird == NSNotFound && [[CSProgram sharedProgram] isAtTheLoopBeginning] /*&& !_isNextStepBatch*/)
            _counterI = -1;
        [self _executeScanfWithChildNodes:childNodes];
    }
    else if (nodeSecond == 3) {
        if (nodeThird == NSNotFound && [[CSProgram sharedProgram] isAtTheLoopBeginning])
            _counterI = -1;
        [self _executeILoopWithChildNodes:childNodes];
    }
    else if (nodeSecond == 4) {
        if (nodeThird == NSNotFound && [[CSProgram sharedProgram] isAtTheLoopBeginning])
            _counterI = -1;
        [self _executePrintfLoopWithChildNodes:childNodes];
    }
}

- (void)tryToBeginNewScope
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2], nodeFourth = [currentIndexPath indexAtPosition:3];
    
    NSUInteger loopCount = -1;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeSecond == NSNotFound) {
            [[CSMemModel sharedMemModel] openStackWithName:kCSStackNameMain collapseFormerVariables:YES];
            loopCount = 0;
        }
        else if (nodeSecond == 2 && nodeThird == NSNotFound) {
            // scanf loop
            loopCount = self.number;
        }
        else if (nodeSecond == 3) {
            if (nodeThird == NSNotFound) {
                loopCount = self.number - 1;
            }
            else if (nodeThird == 1) {
                if (nodeFourth == NSNotFound) {
                    loopCount = self.number - _counterI - 1;
                }
                else if (nodeFourth == 0) {
                    NSUInteger ak = [self numberInBlockViewAtIndex:_counterK];
                    NSUInteger aj = [self numberInBlockViewAtIndex:_varJ];
                    
                    if (ak < aj) loopCount = 0;
                }
            }
            else if (nodeThird == 2) {
                if (_varJ != _counterI) loopCount = 0;
            }
        }
        else if (nodeSecond == 4) {
            loopCount = self.number;
        }
    }
    
    [[CSProgram sharedProgram] beginNewScopeWithLoopCount:loopCount];
}

- (BOOL)highlightNextLine
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2], nodeFourth = [currentIndexPath indexAtPosition:3];
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning] && !_isBatchExecuting) {
        if (nodeSecond == 2) {
            _isNextStepBatch = YES;
        }
        else if (nodeSecond == 3 && nodeThird == 2 && nodeFourth == NSNotFound) {
            if (_varJ != _counterI) {
                // when doing i,j comparing, if we need to swtich them. Don't manually execute next.
                _isNextStepBatch = YES;
            }
        }
        else if (nodeSecond == 4 && nodeFourth == NSNotFound) {
            _isNextStepBatch = YES;
        }
    }
    
    return [super highlightNextLine];
}
@end