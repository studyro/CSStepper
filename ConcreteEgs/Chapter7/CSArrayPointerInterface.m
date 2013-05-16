//
//  CSArrayPointer.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSArrayPointerInterface.h"
#import "CSInputView.h"
#import "CSConsoleView.h"
#import "NSString+Separator.h"

#define ABLOCK_START_X 216.0
#define ABLOCK_Y 225.0
#define ABLOCK_WIDTH 132.0
#define ABLOCK_HEIGHT 90.0
#define ABLOCK_PADDING 11.0

#define ALABEL_WIDTH 30.0

#define APBLOCK_WIDTH 97.0
#define APBLOCK_HEIGHT 57.0

@interface CSArrayPointerInterface ()
{
    NSInteger _countI;
    
    BOOL _isBatchExecuting;
    BOOL _isNextStepBatch;
}
@property (assign, nonatomic) NSUInteger number;
@property (strong, nonatomic) NSMutableArray *aArrayBlockViews;
@property (strong, nonatomic) NSMutableArray *aArrayLabels;
@property (strong, nonatomic) NSMutableArray *aContentArray;

@property (strong, nonatomic) CSBlockView *apBlockView;
@property (strong, nonatomic) CSArrowView *apArrowView;
@property (strong, nonatomic) UILabel *apLabel;

@property (strong, nonatomic) CSBlockView *apTempBlockView;
@property (strong, nonatomic) CSArrowView *apTempArrowView;
@property (strong, nonatomic) UILabel *apTempLabel;

@property (strong, nonatomic) CSConsoleView *consoleView;

@end

@implementation CSArrayPointerInterface

- (id)init
{
    if (self = [super init]) {
        self.aArrayBlockViews = [[NSMutableArray alloc] init];
        self.aArrayLabels = [[NSMutableArray alloc] init];
        self.aContentArray = [[NSMutableArray alloc] init];
        self.number = 4;
    }
    
    return self;
}

- (void)construct
{
    [super construct];
    
    for (NSUInteger i = 0; i < self.number; i++) {
        CSBlockView *aBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(ABLOCK_START_X + i * (ABLOCK_WIDTH + ABLOCK_PADDING), ABLOCK_Y, ABLOCK_WIDTH, ABLOCK_HEIGHT)];
        aBlockView.borderWidth = 4.0;
        aBlockView.text = @"残值";
        aBlockView.opaque = NO;
        aBlockView.alpha = 0.0;
        aBlockView.backgroundColor = [UIColor whiteColor];
        [self.aArrayBlockViews addObject:aBlockView];
        [self.backgroundView addSubview:aBlockView];
        
        UILabel *aLabel = [[UILabel alloc] initWithFrame:CGRectMake(aBlockView.center.x - 0.5 * ALABEL_WIDTH, ABLOCK_Y - 40, ALABEL_WIDTH, 40)];
        aLabel.opaque = NO;
        aLabel.alpha = 0.0;
        aLabel.text = [NSString stringWithFormat:@"a[%d]", i];
        aLabel.backgroundColor = [UIColor whiteColor];
        aLabel.font = [UIFont systemFontOfSize:18.0];
        [self.aArrayLabels addObject:aLabel];
        [self.backgroundView addSubview:aLabel];
    }
    
    CSBlockView *aBlock = self.aArrayBlockViews[0];
    
    self.apBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(0.0, 0.0, APBLOCK_WIDTH, APBLOCK_HEIGHT)];
    self.apBlockView.center = CGPointMake(aBlock.center.x, 521.0);
    self.apBlockView.opaque = NO;
    self.apBlockView.alpha = 0.0;
    self.apBlockView.borderWidth = 6.0;
    self.apBlockView.text = @"残值";
    [self.backgroundView addSubview:self.apBlockView];
    
    self.apLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 40.0)];
    self.apLabel.center = CGPointMake(self.apBlockView.center.x, 521.0 + APBLOCK_HEIGHT * 0.5 + 20.0);
    self.apLabel.opaque = NO, self.apLabel.alpha = 0.0;
    self.apLabel.text = @"ap";
    self.apLabel.textAlignment = NSTextAlignmentCenter;
    self.apLabel.font = [UIFont systemFontOfSize:18.0];
    self.apLabel.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.apLabel];
    
    self.apArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(self.apBlockView.center.x, self.apBlockView.frame.origin.y + 8.0) toPoint:CGPointMake(self.apBlockView.center.x, aBlock.frame.origin.y + aBlock.frame.size.height)];
    self.apArrowView.opaque = NO, self.apArrowView.alpha = 0.0;
    [self.backgroundView addSubview:self.apArrowView];
    
    self.consoleView = [[CSConsoleView alloc] initWithFrame:CGRectMake(310.0, 525.0, 412.0, 183.0)];
    self.consoleView.opaque = NO;
    self.consoleView.alpha = 0.0;
    [self.backgroundView addSubview:self.consoleView];
    
    self.apTempBlockView = [[CSBlockView alloc] initWithFrame:self.apBlockView.frame];
    self.apTempBlockView.center = CGPointMake(aBlock.center.x, 521.0);
    self.apTempBlockView.opaque = NO;
    self.apTempBlockView.alpha = 0.0;
    self.apTempBlockView.borderWidth = 6.0;
    self.apTempBlockView.text = @"残值";
    [self.backgroundView addSubview:self.apTempBlockView];
    
    self.apTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 80.0, 40.0)];
    self.apTempLabel.center = self.apLabel.center;
    self.apTempLabel.opaque = NO, self.apTempLabel.alpha = 0.0;
    self.apTempLabel.text = @"*ap + 0";
    self.apTempLabel.font = [UIFont systemFontOfSize:18.0];
    self.apTempLabel.textAlignment = NSTextAlignmentCenter;
    self.apTempLabel.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:self.apTempLabel];
    
    self.apTempArrowView = [[CSArrowView alloc] initFromPoint:CGPointMake(self.apBlockView.center.x, self.apBlockView.frame.origin.y + 8.0) toPoint:CGPointMake(self.apBlockView.center.x, aBlock.frame.origin.y + aBlock.frame.size.height)];
    self.apTempArrowView.opaque = NO, self.apTempArrowView.alpha = 0.0;
    [self.backgroundView addSubview:self.apTempArrowView];
}

- (void)showArrayBlocksAndLabels
{
    [UIView animateWithDuration:0.8 animations:^{
        for (NSUInteger i = 0; i < self.number; i++) {
            CSBlockView *abv = self.aArrayBlockViews[i];
            UILabel *albl = self.aArrayLabels[i];
            
            abv.alpha = 1.0;
            albl.alpha = 1.0;
        }
        
        self.apBlockView.alpha = 1.0;
        self.apLabel.alpha = 1.0;
    }];
}

- (void)showApArrow
{
    [UIView animateWithDuration:0.5 animations:^{
        self.apArrowView.alpha = 1.0;
    }];
}

- (void)moveTempPointerToIndex:(NSUInteger)index
{
    if (index < self.number - 1) {
        [UIView animateWithDuration:1.0 animations:^{
            self.apTempLabel.alpha = 1.0;
            self.apTempArrowView.alpha = 1.0;
            self.apTempBlockView.alpha = 1.0;
            
            CGFloat distanceX = ABLOCK_WIDTH + ABLOCK_PADDING;
            
            self.apTempLabel.center = CGPointMake(self.apTempLabel.center.x + distanceX, self.apTempLabel.center.y);
            self.apTempArrowView.center = CGPointMake(self.apTempArrowView.center.x + distanceX, self.apTempArrowView.center.y);
            self.apTempBlockView.center = CGPointMake(self.apTempBlockView.center.x + distanceX, self.apTempBlockView.center.y);
        }];
    }
}

- (void)refreshArrayTextAtIndex:(NSUInteger)index
{
    CSBlockView *b = self.aArrayBlockViews[index];
    b.text = self.aContentArray[index];
    
    [self moveTempPointerToIndex:index];
}

- (void)dismissATempViews
{
    [UIView animateWithDuration:0.5 animations:^{
        self.apTempLabel.alpha = 0.0;
        self.apTempArrowView.alpha = 0.0;
        self.apTempBlockView.alpha = 0.0;
    }];
}

#pragma mark - Private Excution Methods

- (void)_executeSimpleAssignmentWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeSecond = nodes[1];
    
    if (nodeSecond == 0) {
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"i"];
    }
    else if (nodeSecond == 1) {
        [[CSMemModel sharedMemModel] beginTransaction];
        [[CSMemModel sharedMemModel] pushValue:@[@{@"a[0]": kCSVariableValueUnassigned},
         @{@"a[1]": kCSVariableValueUnassigned}, @{@"a[2]": kCSVariableValueUnassigned}, @{@"a[3]": kCSVariableValueUnassigned}] named:@"a[]"];
        [[CSMemModel sharedMemModel] pushValue:kCSVariableValueUnassigned named:@"ap"];
        [[CSMemModel sharedMemModel] commitTransaction];
        
        [self showArrayBlocksAndLabels];
    }
    else if (nodeSecond == 2) {
        [[CSMemModel sharedMemModel] pushValue:@"a" named:@"ap"];
        
        [self showApArrow];
        self.apBlockView.text = @"a";
    }
}

- (void)_executeArrayInputLoopWithNodes:(NSUInteger [])nodes
{
    NSUInteger nodeThird = nodes[2];
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) _countI = -1;
        _countI++;
        
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
    }
    else {
        if (nodeThird == 0) {
            // TODO: show printf?
        }
        else if (nodeThird == 1) {
            CSInputView *inputView = [[CSInputView alloc] initWithName:[NSString stringWithFormat:@"*ap + %d", _countI]];
            [inputView setVerifyBlock:^(NSString *text){
                return [text isNumbers];
            }];
            
            __weak typeof(self) weakSelf = self;
            [inputView setDoneBlock:^(NSString *text){
                [weakSelf.aContentArray addObject:text];
                [weakSelf refreshArrayTextAtIndex:_countI];
                [weakSelf dismissMaskView];
            }];
            
            [self showMaskView];
            [inputView showInView:self.backgroundView
                         centerAt:CGPointMake(self.backgroundView.bounds.size.width * 0.5, 300)
                          animted:YES];
        }
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
        
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        [self nextBatchStepsOfCount:self.number * 2 - 1 timeInterval:1.5 stepBlock:^(NSUInteger currentStep){
            [self nextStep];
        } completionBlock:^{
            _isBatchExecuting = NO;
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }];
    }
    
    if (nodeThird == NSNotFound) {
        if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
            _countI = -1;
            [self dismissATempViews];
        }
        
        _countI++;
        [[CSMemModel sharedMemModel] setValueInStack:[NSString stringWithFormat:@"%d", _countI] named:@"i"];
    }
    else {
        [self.consoleView appendSring:[NSString stringWithFormat:@"%@\t", self.aContentArray[_countI]]];
    }
}

#pragma mark - Public Interface

- (void)executeStep
{
    NSIndexPath *currentIndexPath = [CSProgram sharedProgram].currentIndexPath;
    NSUInteger nodeFirst = [currentIndexPath indexAtPosition:0],
               nodeSecond = [currentIndexPath indexAtPosition:1],
               nodeThird = [currentIndexPath indexAtPosition:2];
    
    NSUInteger nodes[3] = {nodeFirst, nodeSecond, nodeThird};
    
    if (nodeFirst == 0) {
        if (nodeSecond == NSNotFound) {
            [[CSMemModel sharedMemModel] openStackWithName:kCSStackNameMain collapseFormerVariables:NO];
        }
        else if (nodeSecond <= 2) {
            [self _executeSimpleAssignmentWithNodes:nodes];
        }
        else if (nodeSecond == 3) {
            [self _executeArrayInputLoopWithNodes:nodes];
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
               nodeSecond = [currentIndexPath indexAtPosition:1];
    
    NSInteger loopCount = -1;
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning]) {
        if (nodeFirst == 0) {
            if (nodeSecond == NSNotFound) {
                loopCount = 0;
            }
            else if (nodeSecond == 3) {
                loopCount = self.number;
            }
            else if (nodeSecond == 4) {
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
    
    if ([[CSProgram sharedProgram] isAtTheLoopBeginning] && !_isBatchExecuting) {
        // means first time approach a loop check.
        if (nodeSecond == 4 && nodeThird == NSNotFound) {
            _isNextStepBatch = YES;
        }
    }
    
    return [super highlightNextLine];
}

@end
