//
//  CSMinValueFirstInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-27.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSMinValueFirstInterface.h"
#import "CSTipView.h"
#import "CSConsoleView.h"

#define BLOCKS_START_X 269.0
#define BLOCKS_START_Y 277.0
#define BLOCKS_LENGTH 50.0

@interface CSMinValueFirstInterface ()
{
    NSInteger _pointJ;
    NSInteger _countI;
    
    BOOL _isBatchExecuting;
    BOOL _isNextStepBatch;
}
@property (nonatomic, strong) NSMutableArray *dataBlocksArray;
@property (nonatomic, assign) NSUInteger number;

@property (nonatomic, strong) CSArrowView *arrowI;
@property (nonatomic, strong) UILabel *labelI;
@property (nonatomic, strong) CSArrowView *arrowJ;
@property (nonatomic, strong) UILabel *labelJ;
@property (nonatomic, strong) CSTipView *tipView;

@property (nonatomic, strong) CSConsoleView *consoleView;

@end

@implementation CSMinValueFirstInterface

- (id)init
{
    if (self = [super init]) {
        self.dataBlocksArray = [[NSMutableArray alloc] init];
        self.number = 10;
        _pointJ = -1;
    }
    return self;
}

- (void)construct
{
    [super construct];
    
    for (NSUInteger i = 0; i < self.number; i++) {
        CSBlockView *blockView = [[CSBlockView alloc] initWithFrame:CGRectMake(BLOCKS_START_X + i * BLOCKS_LENGTH, BLOCKS_START_Y, BLOCKS_LENGTH, BLOCKS_LENGTH)];
        blockView.opaque = NO, blockView.alpha = 0.0;
        blockView.borderWidth = 2.0;
        blockView.text = @"残值";
        [self.dataBlocksArray addObject:blockView];
        [self.backgroundView addSubview:blockView];
    }
    
    CGPoint firstBlockTopCenter = CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH, BLOCKS_START_Y);
    CGPoint firstBlockBottomCenter = CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH, BLOCKS_START_Y + BLOCKS_LENGTH);
    self.arrowI = [[CSArrowView alloc] initFromPoint:CGPointMake(firstBlockBottomCenter.x, firstBlockBottomCenter.y + 30.0) toPoint:firstBlockBottomCenter];
    self.arrowI.opaque = NO, self.arrowI.alpha = 0.0;
    [self.backgroundView addSubview:self.arrowI];
    
    self.labelI = [[UILabel alloc] init];
    self.labelI.bounds = CGRectMake(0.0, 0.0, BLOCKS_LENGTH, 30.0);
    self.labelI.center = CGPointMake(firstBlockBottomCenter.x, self.arrowI.fromPoint.y + 15.0);
    self.labelI.textAlignment = NSTextAlignmentCenter;
    self.labelI.opaque = NO, self.labelI.alpha = 0.0;
    self.labelI.text = @"i";
    self.labelI.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.labelI];
    
    self.arrowJ = [[CSArrowView alloc] initFromPoint:CGPointMake(firstBlockBottomCenter.x, firstBlockTopCenter.y - 30.0) toPoint:firstBlockTopCenter];
    self.arrowJ.opaque = NO, self.arrowJ.alpha = 0.0;
    [self.backgroundView addSubview:self.arrowJ];
    
    self.labelJ = [[UILabel alloc] init];
    self.labelJ.bounds = CGRectMake(0.0, 0.0, BLOCKS_LENGTH, 30.0);
    self.labelJ.center = CGPointMake(firstBlockBottomCenter.x, self.arrowJ.fromPoint.y - 15.0);
    self.labelJ.textAlignment = NSTextAlignmentCenter;
    self.labelJ.opaque = NO, self.labelJ.alpha = 0.0;
    self.labelJ.text = @"j";
    self.labelJ.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.labelJ];
    
    self.tipView = [[CSTipView alloc] init];
    self.tipView.textLabel.font = [UIFont systemFontOfSize:22.0];
    [self.tipView hideAnimted:NO];
    self.tipView.maxWidth = 200.0;
    [self.backgroundView addSubview:self.tipView];
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(322.0, 496.0, 355.0, 133.0)];
    self.consoleView.opaque = NO, self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
}

- (NSArray *)blockTextArray
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < self.number; i++) {
        CSBlockView *b = self.dataBlocksArray[i];
        [arr addObject:b.text];
    }
    
    return arr;
}

- (void)showBlocks
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.dataBlocksArray enumerateObjectsUsingBlock:^(CSBlockView *b, NSUInteger idx, BOOL *stop){
            b.alpha = 1.0;
        }];
    }];
}

- (NSUInteger)_randomNumber
{
    // to generate random number between 1~self.number
    return arc4random() % (self.number + 1);
}

- (NSUInteger)numberInBlockViewAtIndex:(NSUInteger)index
{
    CSBlockView *blockView = (CSBlockView *)self.dataBlocksArray[index];
    
    return [blockView.text integerValue];
}

- (void)setBlockViewAtIndex:(NSUInteger)index withNumber:(NSUInteger)number
{
    CSBlockView *blockView = (CSBlockView *)self.dataBlocksArray[index];
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

- (void)setPointer:(CSArrowView *)arrowView toIndex:(NSUInteger)idx
{
    if (idx >= self.number) return;
    
    UILabel *label = self.labelI;
    if (arrowView == self.arrowJ) label = self.labelJ;
    
    [UIView animateWithDuration:0.5 animations:^{
        [arrowView setFromPoint:CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH + idx * BLOCKS_LENGTH, arrowView.fromPoint.y) toPoint:CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH + idx * BLOCKS_LENGTH, arrowView.toPoint.y) animated:NO];
        label.center = CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH + idx * BLOCKS_LENGTH, label.center.y);
    }];
}

- (void)setStatus:(BVStatus)status forBlockViewAtIndex:(NSUInteger)idx
{
    if (idx >= self.number) return;
    
    CSBlockView *blockView = self.dataBlocksArray[idx];
    blockView.status = status;
}

- (void)showTipView
{
    NSUInteger dataI = [[self.dataBlocksArray[_countI] text] integerValue];
    NSUInteger dataJ = [[self.dataBlocksArray[_pointJ] text] integerValue];
    
    NSString *symbol = nil;
    if (dataI > dataJ) {
        symbol = @">";
    }
    else if (dataI == dataJ) {
        symbol = @"=";
    }
    else {
        symbol = @"<";
    }
    
    NSString *text = [NSString stringWithFormat:@"%d %@ %d\ndata[i] data[j]", dataI, symbol, dataJ];
    
    [self.tipView showWithText:text
                      atCenter:CGPointMake(512.0, 578.0)
                      animated:YES];
}

- (void)moveBlockViewAtIndex:(NSUInteger)idx toPoint:(CGPoint)toCenter
{
    if (idx >= self.number) return;
    
    CSBlockView *bv = self.dataBlocksArray[idx];
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        bv.center = toCenter;
    } completion:nil];
}

- (void)showIArrowsAndLabels
{
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowI.alpha = 1.0;
        self.labelI.alpha = 1.0;
    }];
}

- (void)showJArrowsAndLabels
{
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowJ.alpha = 1.0;
        self.labelJ.alpha = 1.0;
    }];
}

#pragma mark - Private Methods

- (void)_executeSimpleAssignmentWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == 0) {
        [self showBlocks];
    }
}

- (void)_executeScanfLoopWithNodes:(NSUInteger [])nodes
{
    if (nodes[2] == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = -1;
        _countI++;
        
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
    }
    else {
        [self setRandomizedNumberToBlockViewAtIndex:_countI];
    }
}

- (void)_executeILoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2],
               nodeForth = nodes[3];
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
            _countI = -1;
            [self showIArrowsAndLabels];
        }
        _countI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
        
        [self setPointer:self.arrowI toIndex:_countI];
        [self.tipView hideAnimted:YES];
    }
    else if (nodeThird == 0) {
        if (nodeForth == NSNotFound) {
            [self showTipView];
        }
        else if (nodeForth == 0) {
            [self setPointer:self.arrowJ toIndex:_countI];
            [self setStatus:BVStatusNormal forBlockViewAtIndex:_pointJ];
            _pointJ = _countI;
            [self setStatus:BVStatusActive forBlockViewAtIndex:_pointJ];
            
            [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"j"];
        }
    }
}

- (void)_executeSwitchWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2];
    
    CGPoint leftCenter = ((CSBlockView *)(self.dataBlocksArray[0])).center;
    CGPoint jCenter = ((CSBlockView *)(self.dataBlocksArray[_pointJ])).center;
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        [self.tipView hideAnimted:YES];
        
        [self setBackgroundViewGesturesEnable:NO];
        [self nextBatchStepsOfCount:3 timeInterval:1.5 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [self setBackgroundViewGesturesEnable:YES];
        }];
    }
    
    if (nodeThird == 0) {
        CGPoint toCenter = CGPointMake(0.5 * (leftCenter.x + jCenter.x), BLOCKS_START_Y - 40);
        [self moveBlockViewAtIndex:0 toPoint:toCenter];
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", [self numberInBlockViewAtIndex:0]] named:@"k"];
    }
    else if (nodeThird == 1) {
        [self moveBlockViewAtIndex:_pointJ toPoint:CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH, BLOCKS_START_Y + 0.5 * BLOCKS_LENGTH)];
    }
    else if (nodeThird == 2) {
        [self moveBlockViewAtIndex:0 toPoint:CGPointMake(BLOCKS_START_X + 0.5 * BLOCKS_LENGTH + _pointJ * BLOCKS_LENGTH, BLOCKS_START_Y + 0.5 * BLOCKS_LENGTH)];
        [self.dataBlocksArray exchangeObjectAtIndex:0 withObjectAtIndex:_pointJ];
        [[CSMemModel sharedMemModel] setValueInStack:[self stackVariableArrayWithArray:[self blockTextArray] name:@"data" count:self.number] named:@"data"];
    }
}

- (void)_executePrintfWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2];
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        [self.tipView hideAnimted:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            self.consoleView.alpha = 1.0;
        }];
        
        [self setBackgroundViewGesturesEnable:NO];
        [self nextBatchStepsOfCount:self.number * 2 - 1 timeInterval:1.0 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [self setBackgroundViewGesturesEnable:YES];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = -1;
        
        _countI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"m"];
    }
    else if (nodeThird == 0) {
        [self.consoleView appendSring:[NSString stringWithFormat:@"%d\t", [self numberInBlockViewAtIndex:_countI]]];
    }
}

#pragma mark - Public Methods

- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse
{
    [[CSMemModel sharedMemModel] openStackWithName:stackName collapseFormerVariables:shouldCollapse];
    if ([stackName isEqualToString:kCSStackNameMain]) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"m"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"k"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"j"];
        [[CSMemModel sharedMemModel] pushValue:[self stackVariableArrayWithArray:nil name:@"data" count:self.number] named:@"data"];
        [[CSMemModel sharedMemModel] commitTransaction];
    }
}

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2],
               nodeForth = [currentIndexPath indexAtPosition:3];
    
    NSUInteger nodes[4] = {nodeFirst, nodeSecond, nodeThird, nodeForth};
    
    if (nodeFirst == 0) {
        if (nodeSecond == NSNotFound) {
            [self pushNewStackNamed:kCSStackNameMain shouldCollapse:YES];
        }
        else if (nodeSecond < 4) {
            [self _executeSimpleAssignmentWithNodes:nodes];
        }
        else if (nodeSecond == 4) {
            [self _executeScanfLoopWithNodes:nodes];
        }
        else if (nodeSecond == 5) {
            _pointJ = 0;
            [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", [self numberInBlockViewAtIndex:_pointJ]] named:@"j"];
            [self showJArrowsAndLabels];
        }
        else if (nodeSecond == 6) {
            [self _executeILoopWithNodes:nodes];
        }
        else if (nodeSecond == 7) {
            [self _executeSwitchWithNodes:nodes];
        }
        else if (nodeSecond == 9) {
            [self _executePrintfWithNodes:nodes];
        }
    }
}

- (void)tryToBeginNewScope
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2],
               nodeForth = [currentIndexPath indexAtPosition:3];
    
    NSInteger loopCount = -1;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 0) {
            if (nodeSecond == NSNotFound) {
                loopCount = 0;
            }
            else if (nodeSecond == 4 && nodeThird == NSNotFound) {
                loopCount = self.number;
            }
            else if (nodeSecond == 6) {
                if (nodeThird == NSNotFound) {
                    loopCount = self.number;
                }
                else if (nodeThird == 0 && nodeForth == NSNotFound) {
                    if ([self numberInBlockViewAtIndex:_countI] < [self numberInBlockViewAtIndex:_pointJ]) {
                        loopCount = 0;
                    }
                }
            }
            else if (nodeSecond == 7 && nodeThird == NSNotFound) {
                if (_pointJ > 0) {
                    loopCount = 0;
                }
            }
            else if (nodeSecond == 9 && nodeThird == NSNotFound) {
                loopCount = self.number;
            }
        }
    }
    
    [[CSProgram sharedProgram] beginNewScopeWithLoopCount:loopCount];
}

- (BOOL)highlightNextLine
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    
    NSUInteger nodeSecond = [currentIndexPath indexAtPosition:1], nodeThird = [currentIndexPath indexAtPosition:2];
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeSecond == 7 && nodeThird == NSNotFound) {
            _isNextStepBatch = YES;
        }
        else if (nodeSecond == 9 && nodeThird == NSNotFound) {
            _isNextStepBatch = YES;
        }
    }
    
    return [super highlightNextLine];
}

@end
