//
//  CSMaxStringInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-27.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSMaxStringInterface.h"
#import "CSTipView.h"
#import "CSConsoleView.h"
#import "NSString+Separator.h"

#define BLOCKS_START_X 292.0
#define BLOCKS_START_Y 128.0
#define UNIT_LENGTH 40.0
#define BLOCKS_PADDING_Y 76.0

@interface CSMaxStringInterface ()
{
    NSInteger _pointMax;
    NSInteger _countI;
}
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, strong) NSMutableArray *strBlocksArray;
@property (nonatomic, strong) NSMutableArray *strLabelsArray;
@property (nonatomic, strong) CSConsoleView *consoleView;
@property (nonatomic, strong) CSTipView *tipView;

@property (nonatomic, strong) CSArrowView *arrowI;
@property (nonatomic, strong) UILabel *labelI;

@property (nonatomic, strong) CSBlockView *blockMax;
@property (nonatomic, strong) CSArrowView *arrowMax;
@property (nonatomic, strong) UILabel *labelMax;

@end

@implementation CSMaxStringInterface

+ (NSArray *)stringArray
{
    return @[@"abstract", @"professor", @"awesome", @"program"];
}

- (id)init
{
    if (self = [super init]) {
        self.number = 4;
        self.strBlocksArray = [[NSMutableArray alloc] init];
        self.strLabelsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)construct
{
    [super construct];
    
    NSArray *stringArray = [[self class] stringArray];
    
    for (NSUInteger i = 0; i < self.number; i++) {
        CSClusteredBlockView *cbv = [[CSClusteredBlockView alloc] initWithPartition:11 andFrame:CGRectMake(BLOCKS_START_X, BLOCKS_START_Y + i * BLOCKS_PADDING_Y, UNIT_LENGTH * 11.0, UNIT_LENGTH)];
        cbv.opaque = NO, cbv.alpha = 0.0;
        cbv.textArray = [(NSString *)stringArray[i] separatedCharStringArrayWithTail:YES];
        [self.strBlocksArray addObject:cbv];
        [self.backgroundView addSubview:cbv];
        
        UILabel *strLabel = [[UILabel alloc] initWithFrame:CGRectMake(cbv.frame.origin.x, cbv.frame.origin.y + cbv.frame.size.height + 2.0, 50.0, 20.0)];
        strLabel.backgroundColor = [UIColor clearColor];
        strLabel.text = [NSString stringWithFormat:@"str[%d]", i];
        strLabel.opaque = NO, strLabel.alpha = 0.0;
        [self.strLabelsArray addObject:strLabel];
        [self.backgroundView addSubview:strLabel];
    }
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(310.0, 611.0, 347.0, 50.0)];
    self.consoleView.opaque = NO, self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
    
    self.tipView = [[CSTipView alloc] init];
    self.tipView.opaque = NO, self.tipView.alpha = 0.0;
    self.tipView.textLabel.font = [UIFont systemFontOfSize:19.0];
    self.tipView.maxWidth = 260.0;
    [self.backgroundView addSubview:self.tipView];
    
    self.arrowI = [[CSArrowView alloc] initFromPoint:CGPointMake(BLOCKS_START_X + UNIT_LENGTH * 11 + 30.0, BLOCKS_START_Y + 0.5 * UNIT_LENGTH) toPoint:CGPointMake(BLOCKS_START_X + UNIT_LENGTH * 11, BLOCKS_START_Y + 0.5 * UNIT_LENGTH)];
    self.arrowI.opaque = NO, self.arrowI.alpha = 0.0;
    [self.backgroundView addSubview:self.arrowI];
    
    self.labelI = [[UILabel alloc] init];
    self.labelI.bounds = CGRectMake(0.0, 0.0, 20.0, 30.0);
    self.labelI.center = CGPointMake(self.arrowI.fromPoint.x + 10.0, self.arrowI.fromPoint.y);
    self.labelI.opaque = NO, self.labelI.alpha = 0.0;
    self.labelI.text = @"i";
    self.labelI.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.labelI];
    
    self.arrowMax = [[CSArrowView alloc] initFromPoint:CGPointMake(BLOCKS_START_X - 30.0, BLOCKS_START_Y + 0.5 * UNIT_LENGTH) toPoint:CGPointMake(BLOCKS_START_X, BLOCKS_START_Y + 0.5 * UNIT_LENGTH)];
    self.arrowMax.opaque = NO, self.arrowMax.alpha = 0.0;
    [self.backgroundView addSubview:self.arrowMax];
    
    self.blockMax = [[CSBlockView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    self.blockMax.bounds = CGRectMake(0.0, 0.0, 40.0, 30.0);
    self.blockMax.center = CGPointMake(self.arrowMax.fromPoint.x - 20.0, self.arrowMax.fromPoint.y);
    self.blockMax.backgroundColor = [UIColor clearColor];
    self.blockMax.opaque = NO, self.blockMax.alpha = 0.0;
    [self.backgroundView addSubview:self.blockMax];
    
    self.labelMax = [[UILabel alloc] initWithFrame:CGRectMake(self.blockMax.frame.origin.x, self.blockMax.frame.origin.y + self.blockMax.frame.size.height + 2.0, 40.0, 30.0)];
    self.labelMax.opaque = NO, self.labelMax.alpha = 0.0;
    self.labelMax.text = @"pmax";
    self.labelMax.backgroundColor = [UIColor clearColor];
    self.labelMax.font = [UIFont systemFontOfSize:13.0];
    [self.backgroundView addSubview:self.labelMax];
}

- (void)showStrBlocks
{
    [UIView animateWithDuration:0.5 animations:^{
        [self.strBlocksArray enumerateObjectsUsingBlock:^(CSClusteredBlockView *cbv, NSUInteger idx, BOOL *stop){
            cbv.alpha = 1.0;
        }];
        [self.strLabelsArray enumerateObjectsUsingBlock:^(UILabel *l, NSUInteger idx, BOOL *stop){
            l.alpha = 1.0;
        }];
    }];
}

- (void)showIArrowAndLabel
{
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowI.alpha = 1.0;
        self.labelI.alpha = 1.0;
    }];
}

- (void)showMaxArrowAndLabel
{
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowMax.alpha = 1.0;
        self.blockMax.alpha = 1.0;
        self.labelMax.alpha = 1.0;
    }];
}

- (void)showTopTipViewComparingIndex:(NSUInteger)idx andAnotherIndex:(NSUInteger)aIdx
{
    if (idx >= self.number || aIdx >= self.number) return;
    
    NSArray *strArray = [[self class] stringArray];
    NSString *string = strArray[idx];
    NSString *aString = strArray[aIdx];
    NSComparisonResult result = [string compare:aString];
    
    NSString *symbol = nil;
    
    if (result == NSOrderedAscending) symbol = @"<";
    else if (result == NSOrderedDescending) symbol = @">";
    else symbol = @"=";
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@\n(字符串比较请看7.19)", string, symbol, aString];
    
    [self.tipView showWithText:text
                      atCenter:CGPointMake(512.0, 65.0)
                      animated:YES];
}

- (void)moveArrow:(CSArrowView *)arrowView toIndex:(NSUInteger)idx
{
    if (idx >= self.number) return;
    
    UILabel *label = self.labelI;
    CSBlockView *blockView = nil;
    if (arrowView == self.arrowMax) {
        label = self.labelMax;
        blockView = self.blockMax;
    };
    
    CSClusteredBlockView *cbv = self.strBlocksArray[idx];
    [UIView animateWithDuration:0.5 animations:^{
        arrowView.center = CGPointMake(arrowView.center.x, cbv.center.y);
        if (blockView) {
            blockView.center = CGPointMake(blockView.center.x, cbv.center.y);
            label.center = CGPointMake(blockView.center.x, blockView.center.y + blockView.frame.size.height * 0.5 + 6.0);
        }
        else {
            label.center = CGPointMake(label.center.x, cbv.center.y);
        }
    }];
}

#pragma mark - Private Methods

- (void)_executeMainFuncWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == NSNotFound) {
        [self pushNewStackNamed:kCSStackNameMain shouldCollapse:NO];
    }
    else if (nodeSecond == 0) {
        [self showStrBlocks];
        [[CSMemModel sharedMemModel] setValueInStack:[self stackVariableArrayWithArray:[[self class] stringArray] name:@"strs" count:4] named:@"strs"];
    }
    else if (nodeSecond == 1) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning] == NO) {
            [[CSMemModel sharedMemModel] recycleStackActivatingLevel:1];
            [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"strs[%d]", _pointMax] named:@"pmax"];
        }
    }
    else if (nodeSecond == 2) {
        [UIView animateWithDuration:0.5 animations:^{self.consoleView.alpha = 1.0;}];
        
        [self.consoleView appendSring:[NSString stringWithFormat:@"max:%@", [[self class] stringArray][_pointMax]]];
    }
}

- (void)_executeILoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2],
               nodeForth = nodes[3];
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
            _countI = 0;
            [self showIArrowAndLabel];
            [self showMaxArrowAndLabel];
        }
        
        _countI ++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
        [self moveArrow:self.arrowI toIndex:_countI];
    }
    else if (nodeThird == 0) {
        if (nodeForth == NSNotFound) {
            [self showTopTipViewComparingIndex:_pointMax andAnotherIndex:_countI];
        }
        else if (nodeForth == 0) {
            _pointMax = _countI;
            [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"p[%d]", _pointMax] named:@"pmax"];
            [self moveArrow:self.arrowMax toIndex:_pointMax];
        }
    }
}

- (void)_executeMaxStrFuncWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == NSNotFound) {
        [self pushNewStackNamed:@"max_str" shouldCollapse:YES];
        [self presentPushingNewStackFromVariableName:@"strs" toParameterName:@"p"];
    }
    else if (nodeSecond == 2) {
        [self _executeILoopWithNodes:nodes];
    }
}

#pragma mark - Public Methods

- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse
{
    [[CSMemModel sharedMemModel] openStackWithName:kCSStackNameMain collapseFormerVariables:shouldCollapse];
    if ([stackName isEqualToString:kCSStackNameMain]) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:@[kCSVariableValueUnassigned, kCSVariableValueUnassigned, kCSVariableValueUnassigned, kCSVariableValueUnassigned] named:@"strs"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"pmax"];
        [[CSMemModel sharedMemModel] commitTransaction];
    }
    else if ([stackName isEqualToString:@"max_str"]) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:[self stackVariableArrayWithArray:[[self class] stringArray] name:@"strs" count:4] named:@"p"];
        [[CSMemModel sharedMemModel] pushValue:@"4" named:@"n"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"pmax"];
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
    
    if (nodeFirst == 1) {
        
        [self _executeMainFuncWithNodes:nodes];
    }
    else if (nodeFirst == 2) {
        [self _executeMaxStrFuncWithNodes:nodes];
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
    NSIndexPath *nextIndexPath = nil;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 1) {
            if (nodeSecond == NSNotFound) {
                loopCount = 0;
            }
            else if (nodeSecond == 1) {
                nextIndexPath = [NSIndexPath indexPathWithIndex:2];
            }
        }
        else if (nodeFirst == 2) {
            if (nodeSecond == NSNotFound) {
                loopCount = 0;
            }
            else if (nodeSecond == 2) {
                if (nodeThird == NSNotFound) {
                    loopCount = self.number - 1;
                }
                else if (nodeThird == 0 && nodeForth == NSNotFound) {
                    NSArray *stringArray = [[self class] stringArray];
                    if ([stringArray[_pointMax] compare:stringArray[_countI]] == NSOrderedAscending) {
                        loopCount = 0;
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
    return [super highlightNextLine];
}

@end