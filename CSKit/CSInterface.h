//
//  CSInterface.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSProgram.h"
#import "CSMemModel.h"

@interface CSInterface : NSObject

@property (nonatomic, strong, readonly) UIView *backgroundView;
//@property (strong, nonatomic, readonly) dispatch_source_t timer;

@property (strong, nonatomic, readonly) NSArray *scopeIndexPaths;

- (void)acceptBackgroundView:(UIView *)view;

// this method should be called after backgroundView is accepted.
- (void)construct;

- (void)tryToBeginNewScope;

- (void)executeStep;

- (BOOL)highlightNextLine;

- (void)nextStep;

// parameter of stepBlock starts from 1, end to {#stepCount}
- (void)nextBatchStepsOfCount:(NSUInteger)stepCount
                 timeInterval:(NSTimeInterval)timeInterval
                    stepBlock:(void (^)(NSUInteger currentStep))stepBlock
              completionBlock:(void (^)(void))completionBlock;

- (void)lastStep;

@end
