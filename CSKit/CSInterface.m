//
//  CSInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSInterface.h"

@interface CSInterface ()

@property (strong, nonatomic, readwrite) UIView *backgroundView;
@property (strong, nonatomic, readwrite) dispatch_source_t timer;
@property (strong, nonatomic, readwrite) NSArray *scopeIndexPaths;
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

- (void)construct
{
    // should be implemented by subclasses
    // implement this method to load subviews in self.backgroundView
}

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
        dispatch_source_set_event_handler(self.timer, ^{
            if (batchStepsCount++ < stepCount && stepBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    stepBlock(batchStepsCount);
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock) completionBlock();
                    dispatch_suspend(self.timer);
                });
            }
        });
        dispatch_resume(self.timer);
    }
}

- (void)lastStep
{
    // should be implemented by subclasses
}

@end
