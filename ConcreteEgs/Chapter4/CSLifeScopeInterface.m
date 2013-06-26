//
//  CSLifeScopeInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-28.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSLifeScopeInterface.h"
#import "CSTipView.h"
#import "CSConsoleView.h"
#import "CSConvenientAnimation.h"

@interface CSLifeScopeInterface ()

@property (nonatomic, assign) NSInteger valueN;
@property (nonatomic, strong) CSBlockView *nBlockView;
@property (nonatomic, strong) CSArrowView *nArrowView;

@property (nonatomic, strong) CSBlockView *mainScopeBlockView;
@property (nonatomic, strong) UILabel *mainScopeNameLabel;
@property (nonatomic, strong) UILabel *mainScopeActionLabel;

@property (nonatomic, strong) CSBlockView *hanshuScopeBlockView;
@property (nonatomic, strong) UILabel *hanshuScopeNameLabel;
@property (nonatomic, strong) UILabel *hanshuScopeActionLabel;

@property (nonatomic, strong) CSTipView *tipView;
@property (nonatomic, strong) CSConsoleView *consoleView;

@end

@implementation CSLifeScopeInterface

- (id)init
{
    if (self = [super init]) {
        self.valueN = 100;
    }
    return self;
}

- (void)construct
{
    [super construct];
    
    self.nBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(374.0, 115.0, 276.0, 55.0)];
    self.nBlockView.text = [NSString stringWithFormat:@"全局变量 n = 100"];
    self.nBlockView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.nBlockView];
    
    self.mainScopeBlockView = [[CSBlockView alloc] init];
    self.mainScopeBlockView.bounds = CGRectMake(0.0, 0.0, 379.0, 192.0);
    self.mainScopeBlockView.center = CGPointMake(512.0, 437.0);
    self.mainScopeBlockView.opaque = NO, self.mainScopeBlockView.alpha = 0.0;
    self.mainScopeBlockView.backgroundColor = [UIColor clearColor];
    [self.backgroundView addSubview:self.mainScopeBlockView];
    
    self.mainScopeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 4.0, 160.0, 25.0)];
    self.mainScopeNameLabel.text = @"main函数作用域";
    self.mainScopeNameLabel.backgroundColor = [UIColor clearColor];
    [self.mainScopeBlockView addSubview:self.mainScopeNameLabel];
    
    self.mainScopeActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.mainScopeNameLabel.frame.origin.x + self.mainScopeNameLabel.frame.size.width + 4.0, 4.0, self.mainScopeBlockView.bounds.size.width - 8.0 - self.mainScopeNameLabel.frame.size.width, 25.0)];
    self.mainScopeActionLabel.text = @"访问 n";
    self.mainScopeActionLabel.textColor = [UIColor tangerineColor];
    self.mainScopeActionLabel.textAlignment = NSTextAlignmentCenter;
    self.mainScopeActionLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.mainScopeActionLabel.opaque = NO, self.mainScopeActionLabel.alpha = 0.0;
    [self.mainScopeBlockView addSubview:self.mainScopeActionLabel];
    
    self.hanshuScopeBlockView = [[CSBlockView alloc] init];
    self.hanshuScopeBlockView.bounds = CGRectMake(0.0, 0.0, 231.0, 93.0);
    self.hanshuScopeBlockView.center = self.mainScopeBlockView.center;
    self.hanshuScopeBlockView.opaque = NO, self.hanshuScopeBlockView.alpha = 0.0;
    self.hanshuScopeBlockView.backgroundColor = [UIColor clearColor];
    self.hanshuScopeBlockView.borderColor = [UIColor redColor];
    [self.backgroundView addSubview:self.hanshuScopeBlockView];
    
    self.hanshuScopeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(4.0, 4.0, 160.0, 25.0)];
    self.hanshuScopeNameLabel.text = @"hanshu函数作用域";
    self.hanshuScopeNameLabel.backgroundColor = [UIColor clearColor];
    [self.hanshuScopeBlockView addSubview:self.hanshuScopeNameLabel];
    
    self.hanshuScopeActionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.hanshuScopeNameLabel.frame.origin.x + self.hanshuScopeNameLabel.frame.size.width + 4.0, 4.0, self.hanshuScopeBlockView.bounds.size.width - 8.0 - self.hanshuScopeNameLabel.frame.size.width, 25.0)];
    self.hanshuScopeActionLabel.text = @"访问 n";
    self.hanshuScopeActionLabel.textColor = [UIColor tangerineColor];
    self.hanshuScopeActionLabel.textAlignment = NSTextAlignmentCenter;
    self.hanshuScopeActionLabel.font = [UIFont boldSystemFontOfSize:17.0];
    self.hanshuScopeActionLabel.opaque = NO, self.hanshuScopeActionLabel.alpha = 0.0;
    [self.hanshuScopeBlockView addSubview:self.hanshuScopeActionLabel];
    
    self.nArrowView = [[CSArrowView alloc] initFromPoint:CGPointZero toPoint:CGPointZero];
    self.nArrowView.opaque = NO, self.nArrowView.alpha = 0.0;
    self.nArrowView.center = CGPointMake(512.0, 255.0);
    self.nArrowView.clipsToBounds = NO;
    [self.backgroundView addSubview:self.nArrowView];
    
    self.tipView = [[CSTipView alloc] init];
    self.tipView.alpha = 0.0;
    self.tipView.maxWidth = 120.0;
    self.tipView.center = CGPointMake(305.0, 255.0);
    [self.backgroundView addSubview:self.tipView];
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(390.0, 595.0, 244.0, 100.0)];
    [self.backgroundView addSubview:self.consoleView];
}

- (void)deactivateScopeBlcokView:(CSBlockView *)scopeBlockView
{
    if (scopeBlockView == self.mainScopeBlockView) {
        self.mainScopeBlockView.borderColor = [UIColor lightGrayColor];
        self.mainScopeNameLabel.textColor = [UIColor lightGrayColor];
    }
    else if (scopeBlockView == self.hanshuScopeBlockView) {
        [UIView animateWithDuration:0.5 animations:^{self.hanshuScopeBlockView.alpha = 0.0;}];
    }
}

- (void)activateScopeBlockView:(CSBlockView *)scopeBlockView
{
    if (scopeBlockView == self.mainScopeBlockView) {
        self.mainScopeBlockView.borderColor = [UIColor blackColor];
        self.mainScopeNameLabel.textColor = [UIColor blackColor];
        
        if (self.mainScopeBlockView.alpha == 0.0) {
            [UIView animateWithDuration:0.5 animations:^{self.mainScopeBlockView.alpha = 1.0;}];
        }
    }
    else if (scopeBlockView == self.hanshuScopeBlockView) {
        [UIView animateWithDuration:0.5 animations:^{self.hanshuScopeBlockView.alpha = 1.0;}];
    }
}

- (void)queryingValue:(BOOL)isQuerying inBlockView:(CSBlockView *)scopeBlockView
{
    UILabel *actionLabel = nil;
    NSString *tipText = nil;
    
    if (scopeBlockView == self.mainScopeBlockView) {
        tipText = @"n 不在main函数作用域中，访问全局声明的静态变量n";
        actionLabel = self.mainScopeActionLabel;
    }
    else if (scopeBlockView == self.hanshuScopeBlockView) {
        tipText = @"n 不在hanshu函数作用域中，访问全局声明的静态变量n";
        actionLabel = self.hanshuScopeActionLabel;
    }
    
    CGFloat alpha = isQuerying ? 1.0 : 0.0;
    
    [UIView animateWithDuration:0.6 animations:^{
        actionLabel.alpha = alpha;
        self.nArrowView.alpha = alpha;
        if (isQuerying) {
            CGPoint cp = [self.backgroundView convertPoint:actionLabel.center fromView:actionLabel.superview];
            CGPoint op = [self.backgroundView convertPoint:actionLabel.frame.origin fromView:actionLabel.superview];
            CGPoint topCenterPoint = CGPointMake(cp.x, op.y);
            CGPoint bottomCenterPoint = CGPointMake(self.nBlockView.center.x, self.nBlockView.frame.origin.y + self.nBlockView.frame.size.height);
            [self.nArrowView setFromPoint:topCenterPoint toPoint:bottomCenterPoint animated:NO];
            
            [self.tipView showWithText:tipText
                              atCenter:CGPointMake(305.0, 255.0)
                              animated:NO];
        }
        else {
            [self.tipView hideAnimted:NO];
        }
    }];
}

- (void)makeOperationOnValue
{
    self.valueN -= 20;
    self.nBlockView.text = [NSString stringWithFormat:@"全局变量区 n = %d", self.valueN];
    [CSConvenientAnimation applyAnphasizeAnimationToView:self.nBlockView scale:1.2 duration:0.4];
}

#pragma mark - Private Execution Methods

- (void)_executeMainFuncWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1], nodeThird = nodes[2];
    
    if (nodeSecond == NSNotFound) {
        [self activateScopeBlockView:self.mainScopeBlockView];
        [self pushNewStackNamed:kCSStackNameMain shouldCollapse:NO];
    }
    else if (nodeSecond == 0) {
        [self queryingValue:YES inBlockView:self.mainScopeBlockView];
        [self.consoleView appendSring:[NSString stringWithFormat:@"n=%d\n", self.valueN]];
    }
    else if (nodeSecond == 1) {
        if (nodeThird == NSNotFound) {
            [self queryingValue:YES inBlockView:self.mainScopeBlockView];
        }
        else if (nodeThird == 0) {
            if ([[CSProgram sharedProgram] isAtTheLoopBeginning])
                [self queryingValue:NO inBlockView:self.mainScopeBlockView];
            else {
                [[CSMemModel sharedMemModel] recycleStackActivatingLevel:1];
                [self activateScopeBlockView:self.mainScopeBlockView];
                [self deactivateScopeBlcokView:self.hanshuScopeBlockView];
                [self queryingValue:NO inBlockView:self.hanshuScopeBlockView];
            }
        }
        else if (nodeThird == 1) {
            [self queryingValue:YES inBlockView:self.mainScopeBlockView];
            [self.consoleView appendSring:[NSString stringWithFormat:@"n=%d\n", self.valueN]];
        }
    }
}

- (void)_executeHanshuFuncWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == NSNotFound) {
        [self pushNewStackNamed:@"hanshu" shouldCollapse:YES];
        [self activateScopeBlockView:self.hanshuScopeBlockView];
        [self deactivateScopeBlcokView:self.mainScopeBlockView];
    }
    else if (nodeSecond == 0) {
        [self queryingValue:YES inBlockView:self.hanshuScopeBlockView];
        [self makeOperationOnValue];
    }
}

#pragma mark - Public Methods

- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse
{
    [[CSMemModel sharedMemModel] openStackWithName:stackName collapseFormerVariables:shouldCollapse];
}

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [[CSProgram sharedProgram] currentIndexPath];
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2];
    
    NSUInteger nodes[3] = {nodeFirst, nodeSecond, nodeThird};
    
    if (nodeFirst == 2) {
        [self _executeHanshuFuncWithNodes:nodes];
    }
    else if (nodeFirst == 3) {
        [self _executeMainFuncWithNodes:nodes];
    }
}

- (void)tryToBeginNewScope
{
    NSIndexPath *currentIndexPath = [[CSProgram sharedProgram] currentIndexPath];
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2];
    
    NSInteger loopCount = -1;
    NSIndexPath *nextIndexPath = nil;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 2 && nodeSecond == NSNotFound) {
            loopCount = 0;
        }
        else if (nodeFirst == 3) {
            if (nodeSecond == NSNotFound) {
                loopCount = 0;
            }
            else if (nodeSecond == 1) {
                if (nodeThird == NSNotFound) {
                    loopCount = (self.valueN - 60) / 20 + 1;
                }
                else if (nodeThird == 0) {
                    nextIndexPath = [NSIndexPath indexPathWithIndex:2];
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
