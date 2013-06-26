//
//  CSStructElectionInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-19.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStructElectionInterface.h"
#import "NSString+Separator.h"
#import "CSInputView.h"
#import "CSConsoleView.h"
#import "CSTipView.h"

#define BLOCKS_START_Y 214.0
#define BLOCKS_START_X 203.0
#define BLOCKS_PADDING_X 241.0
#define BLOCKS_PADDING_Y 164.0
#define BLOCKS_WIDTH 175.0
#define BLOCKS_HEIGHT 40.0

@interface CSStructElectionInterface ()
{
    NSInteger _countI;
    NSInteger _countJ;
    
    BOOL _isBatchExecuting;
    BOOL _isNextStepBatch;
}
@property (nonatomic, assign) NSUInteger numberI;
@property (nonatomic, assign) NSUInteger numberJ;
@property (nonatomic, strong) NSMutableArray *leaderArray;
@property (nonatomic, copy) NSString *recentInputedString;
@property (nonatomic, strong) CSConsoleView *consoleView;

@property (nonatomic, strong) NSMutableArray *nameBlocksArray;
@property (nonatomic, strong) NSMutableArray *countBlocksArray;

@property (nonatomic, strong) CSTipView *centerTipView;
@property (nonatomic, strong) CSTipView *bottomTipView;

@end

@implementation CSStructElectionInterface

+ (NSArray *)namesToElected
{
    return @[@"wang", @"zhang", @"zhou", @"gao"];
}

- (id)init
{
    if (self = [super init]) {
        self.numberI = 10;
        self.numberJ = 4;
        
        self.nameBlocksArray = [[NSMutableArray alloc] init];
        self.countBlocksArray = [[NSMutableArray alloc] init];
        self.leaderArray = [[NSMutableArray alloc] init];
        NSArray *nameArray = [[self class] namesToElected];
        for (NSUInteger i = 0; i < self.numberJ; i++) {
            NSMutableDictionary *info = [@{@"name": nameArray[i], @"count": [NSNumber numberWithInteger:0]} mutableCopy];
            [self.leaderArray addObject:info];
        }
    }
    
    return self;
}

- (void)construct
{
    [super construct];
    
    for (NSInteger i = 0; i < self.numberJ; i++) {
        CGFloat offsetX = (i % 2 == 0) ? 0 : (BLOCKS_PADDING_X + BLOCKS_WIDTH);
        CGFloat offsetY = (i - 2 < 0) ? 0 : BLOCKS_PADDING_Y;
        
        CSBlockView *nameBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(BLOCKS_START_X + offsetX, BLOCKS_START_Y + offsetY, BLOCKS_WIDTH, BLOCKS_HEIGHT)];
        nameBlockView.opaque = NO, nameBlockView.alpha = 0.0;
        nameBlockView.borderWidth = 4.0;
        nameBlockView.text = self.leaderArray[i][@"name"];
        [self.nameBlocksArray addObject:nameBlockView];
        [self.backgroundView addSubview:nameBlockView];
        
        CSBlockView *countBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(BLOCKS_START_X + offsetX, BLOCKS_START_Y + BLOCKS_HEIGHT + offsetY - 4.0, BLOCKS_WIDTH, BLOCKS_HEIGHT)];
        countBlockView.opaque = NO, countBlockView.alpha = 0.0;
        countBlockView.borderWidth = 4.0;
        countBlockView.text = @"0";
        [self.countBlocksArray addObject:countBlockView];
        [self.backgroundView addSubview:countBlockView];
    }
    
    self.centerTipView = [[CSTipView alloc] init];
    [self.backgroundView addSubview:self.centerTipView];
    self.bottomTipView = [[CSTipView alloc] init];
    [self.backgroundView addSubview:self.bottomTipView];
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(310.0, 525.0, 412.0, 183.0)];
    self.consoleView.opaque = NO;
    self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
}

- (NSArray *)personStructArrayStackVariable
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < self.numberJ; i++) {
        NSArray *leader1 = @[@{@"name": [self stackVariableArrayWithArray:[self.leaderArray[0][@"name"] separatedCharStringArrayWithTail:YES] name:@"name" count:20]}, @{@"count": self.leaderArray[0][@"count"]}];
        [result addObject:@{[NSString stringWithFormat:@"leader[%d]", i]: leader1}];
    }
    
    return result;
}

- (void)showAllBlocks
{
    [UIView animateWithDuration:0.5 animations:^{
        for (NSUInteger i = 0; i < self.numberJ; i++) {
            CSBlockView *nb = self.nameBlocksArray[i];
            CSBlockView *cb = self.countBlocksArray[i];
            
            nb.alpha = 1.0;
            cb.alpha = 1.0;
        }
    }];
}

- (void)setBlocksComparing:(BOOL)comparing atIndex:(NSUInteger)index
{
    if (index >= self.numberJ) return;
    
    UIColor *color = comparing ? [UIColor blueColor] : [UIColor blackColor];
    
    CSBlockView *nb = self.nameBlocksArray[index];
    CSBlockView *cb = self.countBlocksArray[index];
    
    nb.borderColor = color;
    cb.borderColor = color;
}

- (void)decomparingAllBlocks
{
    for (NSUInteger i = 0; i < self.numberJ; i++) {
        [self setBlocksComparing:NO atIndex:i];
    }
}

- (void)setActive:(BOOL)active forCountBlockAtIndex:(NSUInteger)index
{
    if (index >= self.numberJ) return;
    
    CSBlockView *cb = self.countBlocksArray[index];
    BVStatus status = active ? BVStatusActive : BVStatusNormal;
    
    cb.status = status;
}

- (void)inactiveAllBlocks
{
    for (NSUInteger i = 0; i < self.numberJ; i++) {
        [self setActive:NO forCountBlockAtIndex:i];
    }
}

- (void)setCountBlockAtIndex:(NSUInteger)index withCount:(NSUInteger)count
{
    if (index >= self.numberJ) return;
    
    CSBlockView *cb = self.countBlocksArray[index];
    cb.text = [NSString stringWithFormat:@"%d", count];
}

- (void)showComparisionResulViewComparingToText:(NSString *)text
{
    if (self.recentInputedString) {
        NSString *showText = [self.recentInputedString isEqualToString:text] ?
                             [NSString stringWithFormat:@"%@字符串相等于%@", self.recentInputedString, text] :
                             [NSString stringWithFormat:@"%@字符串不等于%@", self.recentInputedString, text];
        [self.centerTipView showWithText:showText
                                atCenter:CGPointMake(512.0, 384.0)
                                animated:YES];
        
//        self.recentInputedString = nil;
    }
}

- (void)dismissComparisionResult
{
    [self.centerTipView hideAnimted:YES];
}

- (void)showBottomTipViewWithText:(NSString *)text
{
    [self.bottomTipView showWithText:text atCenter:CGPointMake(512.0, 618.0) animated:YES];
}

- (void)dismissBottomTipView
{
    [self.bottomTipView hideAnimted:YES];
}

#pragma mark - Private Execution Methods

- (void)_executeSimpleAssigningWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == 0) {
        [[CSMemModel sharedMemModel] pushValue:[self personStructArrayStackVariable] named:@"leader"];
        
        [self showAllBlocks];
    }
    else if (nodeSecond == 1) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:[self stackVariableArrayWithArray:nil name:@"name" count:20] named:@"name"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"j"];
        [[CSMemModel sharedMemModel] commitTransaction];
    }
}

- (void)_executeJLoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeForth = nodes[3], nodeFifth = nodes[4];
    
    if (nodeForth == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countJ = -1;
        
        [self decomparingAllBlocks];
        [self inactiveAllBlocks];
        
        _countJ++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countJ] named:@"j"];
        
        [self setActive:YES forCountBlockAtIndex:_countJ];
    }
    else if (nodeForth == 0) {
        if (nodeFifth == NSNotFound) {
            [self showComparisionResulViewComparingToText:self.leaderArray[_countJ][@"name"]];
        }
        else if (nodeFifth == 0) {
            NSMutableDictionary *leaderInfo = self.leaderArray[_countJ];
            NSInteger voteCount = [leaderInfo[@"count"] integerValue];
            voteCount++;
            leaderInfo[@"count"] = [NSNumber numberWithInteger:voteCount];
            [[CSMemModel sharedMemModel] setValueInStack:[self personStructArrayStackVariable] named:@"leader"];
            
            [self setActive:YES forCountBlockAtIndex:_countJ];
            [self setCountBlockAtIndex:_countJ withCount:voteCount];
        }
        else if (nodeFifth == 1) {
            // at the line of  'break;'
            [self inactiveAllBlocks];
            [self dismissComparisionResult];
        }
    }
}

- (void)_executeILoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2];
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = -1;
        _countI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
    }
    else if (nodeThird == 0) {
        // gets(name)
        CSInputView *inputView = [[CSInputView alloc] initWithName:@"name :"];
        
        __weak typeof(self) weakSelf = self;
        [inputView setDoneBlock:^(NSString *text){
            weakSelf.recentInputedString = text;
            [self dismissMaskView];
        }];
        
        [self showMaskView]; // must show before tip view
        [inputView showInView:self.backgroundView
                     centerAt:CGPointMake(512.0, 300.0)
                      animted:YES];
    }
    else if (nodeThird == 1) {
        [self _executeJLoopWithNodes:nodes];
    }
}

- (void)_executePrintfLoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2];
    
    if (_isNextStepBatch) {
        _isNextStepBatch = NO;
        _isBatchExecuting = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.consoleView.alpha = 1.0;
        }];
        
        [self setBackgroundViewGesturesEnable:NO];
        [self nextBatchStepsOfCount:self.numberJ * 2 - 1 timeInterval:1.5 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [self setBackgroundViewGesturesEnable:YES];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countJ = -1;
        
        _countJ++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countJ] named:@"j"];
    }
    else {
        [self.consoleView appendSring:[NSString stringWithFormat:@"%@:%d\n", self.leaderArray[_countJ][@"name"], [self.leaderArray[_countJ][@"count"] integerValue]]];
    }
}

#pragma mark - Public Methods

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2],
               nodeForth = [currentIndexPath indexAtPosition:3],
               nodeFifth = [currentIndexPath indexAtPosition:4];
    
    NSUInteger nodes[5] = {nodeFirst, nodeSecond, nodeThird, nodeForth, nodeFifth};
    
    if (nodeFirst == 1) {
        if (nodeSecond <= 1) {
            [self _executeSimpleAssigningWithNodes:nodes];
        }
        else if (nodeSecond == 2) {
            [self _executeILoopWithNodes:nodes];
        }
        else if (nodeSecond == 3) {
            [self decomparingAllBlocks];
            [self inactiveAllBlocks];
        }
        else if (nodeSecond == 4) {
            [self _executePrintfLoopWithNodes:nodes];
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
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 1) {
            if (nodeSecond == NSNotFound) {
                loopCount = 0;
            }
            else if (nodeSecond == 2) {
                if (nodeThird == NSNotFound) {
                    loopCount = self.numberI;
                }
                else if (nodeThird == 1) {
                    if (nodeForth == NSNotFound) {
                        loopCount = self.numberJ;
                    }
                    else if (nodeForth == 0) {
                        if (nodeFifth == NSNotFound) {
                            NSString *handlingName = self.leaderArray[_countJ][@"name"];
                            if ([self.recentInputedString isEqualToString:handlingName]) {
                                loopCount = 0;
                            }
                        }
                        else if (nodeFifth == 1) {
                            [[CSProgram sharedProgram] breakCurrentScopeInverselyAtIndex:1];
                        }
                    }
                }
            }
            else if (nodeSecond == 4) {
                if (nodeThird == NSNotFound) {
                    loopCount = self.numberJ;
                }
            }
        }
    }
    
    [[CSProgram sharedProgram] beginNewScopeWithLoopCount:loopCount];
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
