//
//  CSInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSInterface.h"

@interface CSInterface ()
{
    __block BOOL _isBatching;
}

@property (strong, nonatomic, readwrite) UIView *backgroundView;
@property (strong, nonatomic, readwrite) dispatch_source_t timer;
@property (strong, nonatomic, readwrite) NSArray *scopeIndexPaths;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) UIButton *pauseButton;
@end

@implementation CSInterface

- (void)dealloc
{
    dispatch_source_cancel(self.timer);
    // from iOS 6 on, disptach objects is under ARC's control.
}

- (id)init
{
    if (self = [super init]) {
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    }
    
    return self;
}

- (void)acceptBackgroundView:(UIView *)view
{
    self.backgroundView = view;
}

- (void)setBackgroundViewGesturesEnable:(BOOL)enable
{
    [self.backgroundView.gestureRecognizers enumerateObjectsUsingBlock:^(UIGestureRecognizer *r, NSUInteger idx, BOOL *stop){
        r.enabled = enable;
    }];
}

- (void)showMaskView
{
    [self setBackgroundViewGesturesEnable:NO];
    [self.backgroundView addSubview:self.maskView];
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.hidden = NO;
        self.maskView.alpha = 0.3;
    }];
}

- (void)dismissMaskView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished){
        [self.maskView removeFromSuperview];
        [self setBackgroundViewGesturesEnable:YES];
    }];
}

- (void)construct
{
    // should be implemented by subclasses
    // implement this method to load subviews in self.backgroundView
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 1024.0, 768.0)];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.opaque = NO, self.maskView.alpha = 0.0;
    self.maskView.userInteractionEnabled = NO;
    
    self.pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.pauseButton addTarget:self action:@selector(pauseOrResumeBatch) forControlEvents:UIControlEventTouchUpInside];
    self.pauseButton.frame = CGRectMake(45.0, 700.0, 50.0, 40.0);
    self.pauseButton.hidden = YES;
    [self.backgroundView addSubview:self.pauseButton];
    
    [[CSMemModel sharedMemModel] flushData];
}

#pragma mark - Helper

- (NSArray *)stackVariableArrayWithArray:(NSArray *)valueArray name:(NSString *)name count:(NSUInteger)count
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    for (NSUInteger i = 0; i < count; i++) {
        NSString *key = [NSString stringWithFormat:@"%@[%d]", name, i];
        NSString *value = kCSVariableValueUnassigned;
        
        if (i < valueArray.count) {
            value = valueArray[i];
        }
        
        [resultArray addObject:@{key: value}];
    }
    
    return resultArray;
}

- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse
{
    // should be implemented by subclasses
}

- (void)presentPushingNewStackFromVariableName:(NSString *)fromName
                               toParameterName:(NSString *)toName
{
    [self showMaskView];
    
    CSBlockView *newBlockView = [[CSBlockView alloc] initWithFrame:CGRectMake(491.0, 320.0, 120.0, 50.0)];
    newBlockView.opaque = NO;
    newBlockView.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:newBlockView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(newBlockView.frame.origin.x, newBlockView.frame.origin.y + newBlockView.frame.size.height + 4.0, newBlockView.frame.size.width, 25.0)];
    label.text = toName;
    label.opaque = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor pomegranateColor];
    [self.backgroundView addSubview:label];
    
    CSBlockView *fromBlock = [[CSBlockView alloc] initWithFrame:CGRectMake(300.0, 320.0, 120.0, 50.0)];
    fromBlock.text = fromName;
    fromBlock.opaque = NO;
    fromBlock.backgroundColor = [UIColor whiteColor];
    [self.backgroundView addSubview:fromBlock];
    
    [self setBackgroundViewGesturesEnable:NO];
    [UIView animateWithDuration:1.5 animations:^{
        fromBlock.center = newBlockView.center;
    } completion:^(BOOL finished){
        [self dismissMaskView];
        [UIView animateWithDuration:0.5 animations:^{
            newBlockView.alpha = 0.0;
            fromBlock.alpha = 0.0;
            label.alpha = 0.0;
        } completion:^(BOOL finished){
            [newBlockView removeFromSuperview];
            [fromBlock removeFromSuperview];
            [label removeFromSuperview];
            [self setBackgroundViewGesturesEnable:YES];
        }];
    }];
}

#pragma mark - Execution Flow Control Methods

- (void)tryToBeginNewScope
{
    // should be implemented by subclasses
}

- (void)executeStep
{
    // should be implemented by subclasses
}

- (BOOL)highlightNextLine
{
    return [[CSProgram sharedProgram] nextStep];
}

- (void)nextStep
{
    [self tryToBeginNewScope];
    
    BOOL haveNextStep = [self highlightNextLine];
    
    if (haveNextStep) {
        [self executeStep];
    }
}

- (void)nextBatchStepsOfCount:(NSUInteger)stepCount
                  timeInterval:(NSTimeInterval)timeInterval
                     stepBlock:(void (^)(NSUInteger currentStep))stepBlock
              completionBlock:(void (^)(void))completionBlock
{
    __block NSUInteger batchStepsCount = 0;
    
    if (self.timer) {
        NSTimeInterval nanoInteval = timeInterval * NSEC_PER_SEC;
        dispatch_source_set_timer(self.timer, dispatch_time(DISPATCH_TIME_NOW, nanoInteval), nanoInteval, 0.3 * timeInterval * NSEC_PER_SEC);
        _isBatching = YES;
        self.pauseButton.hidden = NO;
        [self autoSetButtonTitle];
        
        __weak typeof(self) weakSelf = self;
        dispatch_source_set_event_handler(self.timer, ^{
            if (batchStepsCount++ < stepCount && stepBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    stepBlock(batchStepsCount);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock) completionBlock();
                    
                    weakSelf.pauseButton.hidden = YES;
                    dispatch_suspend(weakSelf.timer);
                    _isBatching = NO;
                });
            }
        });
        dispatch_resume(self.timer);
    }
}

- (void)autoSetButtonTitle
{
    if (_isBatching) {
        [self.pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    }
    else {
        [self.pauseButton setTitle:@"继续" forState:UIControlStateNormal];
    }
}

- (void)pauseOrResumeBatch
{
    if (_isBatching) {
        dispatch_suspend(self.timer);
    }
    else {
        dispatch_resume(self.timer);
    }
    
    _isBatching = !_isBatching;
    [self autoSetButtonTitle];
}

@end
