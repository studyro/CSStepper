//
//  CSDeleteNumberStringInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-17.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSDeleteNumberStringInterface.h"
#import "NSString+Separator.h"
#import "CSAnphasizeHUD.h"
#import "CSTipView.h"
#import <QuartzCore/QuartzCore.h>

#define STRBLOCK_START_X 192.0
#define STRBLOCK_START_Y 262.0
#define STRBLOCK_LENGTH 46.0

@interface CSDeleteNumberStringInterface ()
{
    NSUInteger _countI;
}
@property (nonatomic, assign) NSUInteger number;
@property (nonatomic, strong) NSMutableArray *strBlockViews;

@property (nonatomic, strong) UILabel *strLabel;
@property (nonatomic, strong) CSArrowView *strArrowView;

@property (nonatomic, strong) CSArrowView *sArrowView;
@property (nonatomic, strong) UILabel *sLabel;

@property (nonatomic, strong) CSArrowView *tempArrowView;
@property (nonatomic, strong) UILabel *tempLabel;

@property (nonatomic, strong) CSTipView *tipView;

@property (nonatomic, strong) NSMutableArray *lettersArray;

@end

@implementation CSDeleteNumberStringInterface

+ (NSString *)stringToHandle
{
    return @"I'm 23 now.";
}

- (id)init
{
    if (self = [super init]) {
        self.number = [[self class] stringToHandle].length + 1;
        self.strBlockViews = [[NSMutableArray alloc] init];
        self.lettersArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)construct
{
    [super construct];
    
    self.lettersArray = [[[[self class] stringToHandle] separatedCharStringArrayWithTail:YES] mutableCopy];
    for (NSUInteger i = 0; i < 15; i++) {
        CSBlockView *strBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(STRBLOCK_START_X + i * (STRBLOCK_LENGTH), STRBLOCK_START_Y, STRBLOCK_LENGTH, STRBLOCK_LENGTH)];
        strBlockView.borderWidth = 4.0;
        strBlockView.opaque = NO, strBlockView.alpha = 0.0;
        
        [self.strBlockViews addObject:strBlockView];
        [self.backgroundView addSubview:strBlockView];
    }
    
    self.strLabel = [[UILabel alloc] initWithFrame:CGRectMake(STRBLOCK_START_X - 15.0, STRBLOCK_START_Y - 60.0, 70.0, 30.0)];
    self.strLabel.font = [UIFont systemFontOfSize:18.0];
    self.strLabel.text = @"string";
    self.strLabel.textAlignment = NSTextAlignmentCenter;
    self.strLabel.opaque = NO, self.strLabel.alpha = 0.0;
    [self.backgroundView addSubview:self.strLabel];
    
    self.strArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(self.strLabel.center.x, self.strLabel.frame.origin.y + self.strLabel.frame.size.height) toPoint:CGPointMake(self.strLabel.center.x, STRBLOCK_START_Y)];
    self.strArrowView.opaque = NO, self.strArrowView.alpha = 0.0;
    [self.backgroundView addSubview:self.strArrowView];
    
    self.tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(STRBLOCK_START_X - 15.0, STRBLOCK_START_Y + STRBLOCK_LENGTH + 30.0, 70.0, 30.0)];
    self.tempLabel.font = [UIFont systemFontOfSize:18.0];
    self.tempLabel.text = @"temp";
    self.tempLabel.textAlignment = NSTextAlignmentCenter;
    self.tempLabel.backgroundColor = [UIColor clearColor];
    self.tempLabel.opaque = NO, self.tempLabel.alpha = 0.0;
    [self.backgroundView addSubview:self.tempLabel];
    
    self.tempArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(self.tempLabel.center.x, self.tempLabel.frame.origin.y) toPoint:CGPointMake(self.tempLabel.center.x, STRBLOCK_START_Y + STRBLOCK_LENGTH)];
    self.tempArrowView.opaque = NO, self.tempArrowView.alpha = 0.0;
    [self.backgroundView addSubview:self.tempArrowView];
    
    self.sLabel = [[UILabel alloc] init];
    self.sLabel.bounds = CGRectMake(0.0, 0.0, 20.0, 30.0);
    self.sLabel.center = CGPointMake(STRBLOCK_START_X + 0.5 * STRBLOCK_LENGTH, STRBLOCK_START_Y + STRBLOCK_LENGTH + 50.0);
    self.sLabel.font = [UIFont systemFontOfSize:18.0];
    self.sLabel.text = @"s";
    self.sLabel.textAlignment = NSTextAlignmentCenter;
    self.sLabel.backgroundColor = [UIColor clearColor];
    self.sLabel.opaque = NO, self.sLabel.alpha = 0.0;
    [self.backgroundView addSubview:self.sLabel];
    
    self.sArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(self.sLabel.center.x, self.sLabel.frame.origin.y) toPoint:CGPointMake(self.sLabel.center.x, STRBLOCK_START_Y + STRBLOCK_LENGTH)];
    self.sArrowView.opaque = NO, self.sArrowView.alpha = 0.0;
    self.sArrowView.lineColor = [UIColor redColor];
    [self.backgroundView addSubview:self.sArrowView];
    
    self.tipView = [[CSTipView alloc] init];
    [self.tipView hideAnimted:NO];
    [self.backgroundView addSubview:self.tipView];
}

- (NSRange)currentRange
{
    NSRange range;
    range.location = _countI;
    range.length = 1;
    
    return range;
}

- (void)showTempArrowView:(BOOL)show
{
    CGFloat alpha = show ? 1.0 : 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.tempArrowView.alpha = alpha;
        self.tempLabel.alpha = alpha;
    }];
}

- (void)showSArrowView:(BOOL)show
{
    CGFloat alpha = show ? 1.0 : 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.sArrowView.alpha = alpha;
        self.sLabel.alpha = alpha;
    }];
}

- (void)showStrBlockViews
{
    [UIView animateWithDuration:0.4 animations:^{
        for (NSUInteger i = 0; i < 15; i++) {
            CSBlockView *bv = self.strBlockViews[i];
            bv.alpha = 1.0;
        }
        self.strLabel.alpha = 1.0;
        self.strArrowView.alpha = 1.0;
    }];
}

- (void)showAnphasizeHudWithString:(NSString *)text
{
    CSAnphasizeHUD *aHud = [[CSAnphasizeHUD alloc] init];
    
    [aHud showWithDuration:4.0
                      text:text
                    inView:self.backgroundView
               centerPoint:CGPointMake(512.0, 384.0)];
}

- (void)fillStrBlockViewsWithString
{
    NSArray *charArray = [[[self class] stringToHandle] separatedCharStringArrayWithTail:YES];
    for (NSUInteger i = 0; i < 15; i++) {
        CSBlockView *strBlockView = self.strBlockViews[i];
        if (i < charArray.count) {
            strBlockView.text = charArray[i];
        }
    }
}

- (void)highlightBlocksStartFromIndex:(NSUInteger)idx
{
    for (NSUInteger i = idx; i < 15; i++) {
        CSBlockView *blockView = self.strBlockViews[i];
        [blockView setStatus:BVStatusActive];
    }
}

- (void)dehighlightBlocksStartFromIndex:(NSUInteger)idx
{
    for (NSUInteger i = idx; i < 15; i++) {
        CSBlockView *blockView = self.strBlockViews[i];
        [blockView setStatus:BVStatusNormal];
    }
}

- (void)bringToLastPlaceForBlockViewAtIndex:(NSUInteger)index
{
    if (index >= self.number) return;
    
    // just for change the order of blockView in backgroundView.subviews and self.strBlockViews
    CSBlockView *blockView = self.strBlockViews[index]; // a __strong reference
    
    [self.strBlockViews removeObjectAtIndex:index];
    [self.strBlockViews addObject:blockView];
    
    [blockView removeFromSuperview];
    blockView.text = @"";
    [self.backgroundView addSubview:blockView];
    
    [self.lettersArray removeObjectAtIndex:index];
}

- (void)moveSPointerToIndex:(NSUInteger)idx
{
    if (idx >= self.number) return;
    
    CSBlockView *strBlockView = self.strBlockViews[idx];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.sLabel.center = CGPointMake(strBlockView.center.x, self.sLabel.center.y);
        [self.sArrowView setFromPoint:CGPointMake(self.sLabel.center.x, self.sLabel.frame.origin.y) toPoint:CGPointMake(strBlockView.center.x, STRBLOCK_START_Y + STRBLOCK_LENGTH) animated:NO];
    }];
}

- (void)moveStringStartFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex >= self.number || toIndex >= self.number || fromIndex == 0) return;
    
    [self highlightBlocksStartFromIndex:fromIndex];
    [self setBackgroundViewGesturesEnable:NO];
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        // move up blocks
        for (NSUInteger i = fromIndex; i < 15.0; i++) {
            CSBlockView *blockView = self.strBlockViews[i];
            blockView.center = CGPointMake(blockView.frame.origin.x, blockView.frame.origin.y - blockView.frame.size.height);
        }
    } completion:^(BOOL finished){
        // move down back blocks
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            for (NSUInteger i = fromIndex; i < 15.0; i++) {
                CSBlockView *blockView = self.strBlockViews[i];
                blockView.center = CGPointMake(blockView.frame.origin.x, STRBLOCK_START_Y + 0.5 * STRBLOCK_LENGTH);
            }
        } completion:^(BOOL finished){
            // move the blockViewBefore to last place
            [UIView animateWithDuration:0.3 animations:^{
                CSBlockView *blockViewBefore = self.strBlockViews[fromIndex - 1];
                blockViewBefore.center = CGPointMake(STRBLOCK_START_X + 14.5 * STRBLOCK_LENGTH, blockViewBefore.center.y);
            } completion:^(BOOL finished){
                [self bringToLastPlaceForBlockViewAtIndex:fromIndex - 1];
                [self dehighlightBlocksStartFromIndex:fromIndex - 1];
                [self setBackgroundViewGesturesEnable:YES];
            }];
        }];
    }];
}

#pragma mark - Private Execution Methods

- (void)_executeMainFuncWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == NSNotFound) {
        [self pushNewStackNamed:kCSStackNameMain shouldCollapse:NO];
    }
    else if (nodeSecond == 0) {
        [[CSMemModel sharedMemModel] setValueInStack:[self stackVariableArrayWithArray:self.lettersArray name:@"string" count:self.number] named:@"string[]"];
        
        [self showStrBlockViews];
        [self fillStrBlockViewsWithString];
    }
}

- (void)_executeLoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2],
               nodeForth = nodes[3];
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = 0;
        
        [self.tipView hideAnimted:YES];
    }
    else if (nodeThird == 0) {
        if (nodeForth == NSNotFound) {
            NSString *letter = self.lettersArray[_countI];
            NSString *tipText = nil;
            if ([letter isNumbers]) {
                tipText = [NSString stringWithFormat:@"s指针指向的char型变量是数字"];
            }
            else {
                tipText = [NSString stringWithFormat:@"s指针指向的char型变量不是数字"];
            }
            
            [self.tipView showWithText:tipText
                              atCenter:CGPointMake(512.0, 608.0)
                              animated:YES];
        }
        else if (nodeForth == 0) {
            [self moveStringStartFromIndex:_countI + 1 toIndex:_countI];
        }
    }
    else if (nodeThird == 1) {
        if (nodeForth == 0) {
            [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"string+%d", _countI] named:@"s"];
            
            [self moveSPointerToIndex:++_countI];
        }
    }
}

- (void)_executeProstrFuncWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == NSNotFound) {
        [self pushNewStackNamed:@"pro_str" shouldCollapse:YES];
        [self showSArrowView:YES];
        [self presentPushingNewStackFromVariableName:@"string" toParameterName:@"s"];
    }
    else if (nodeSecond == 0) {
        [[CSMemModel sharedMemModel] setValueInStack:@"s" named:@"temp"];
        
        [self showTempArrowView:YES];
    }
    else if (nodeSecond == 1) {
        [self _executeLoopWithNodes:nodes];
    }
    else if (nodeSecond == 2) {
        // do nothing
    }
}

#pragma mark - Public Methods

- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse
{
    [[CSMemModel sharedMemModel] openStackWithName:stackName collapseFormerVariables:shouldCollapse];
    
    if ([stackName isEqualToString:kCSStackNameMain]) {
        [[CSMemModel sharedMemModel] pushValue:[self stackVariableArrayWithArray:nil name:@"string" count:self.number] named:@"string[]"];
    }
    else if ([stackName isEqualToString:@"pro_str"]) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:@"string" named:@"s"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"temp"];
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
        [self _executeProstrFuncWithNodes:nodes];
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
            else if (nodeSecond == 1) {
                if (nodeThird == NSNotFound) {
                    loopCount = 11;
                }
                else if (nodeThird == 0 && nodeForth == NSNotFound) {
                    if ([self.lettersArray[_countI] isNumbers]) {
                        [[CSProgram sharedProgram] skipNextSeriallyLineOfCode];
                        loopCount = 0;
                    }
                }
                else if (nodeThird == 1 && nodeForth == NSNotFound) {
                    loopCount = 0;
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
