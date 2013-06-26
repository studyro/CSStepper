//
//  CSInterface.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSBlockView.h"
#import "CSClusteredBlockView.h"
#import "CSArrowView.h"
#import "CSProgram.h"
#import "CSMemModel.h"
#import "UIColor+FlatUI.h"

@interface CSInterface : NSObject

@property (nonatomic, strong, readonly) UIView *backgroundView;
//@property (strong, nonatomic, readonly) dispatch_source_t timer;

@property (strong, nonatomic, readonly) NSArray *scopeIndexPaths;

- (void)acceptBackgroundView:(UIView *)view;
- (void)setBackgroundViewGesturesEnable:(BOOL)enable;
- (void)showMaskView;
- (void)dismissMaskView;

#pragma mark - Helper
/*
    send a valueArray to this method and return a associated value which can be push into CSMemModel
 */
- (NSArray *)stackVariableArrayWithArray:(NSArray *)valueArray name:(NSString *)name count:(NSUInteger)count;

// write all into-stack memory model modifying operation in this overided-methods
- (void)pushNewStackNamed:(NSString *)stackName shouldCollapse:(BOOL)shouldCollapse;

- (void)presentPushingNewStackFromVariableName:(NSString *)fromName toParameterName:(NSString *)toName;

#warning not availabel yet
- (NSArray *)indexPathsToSkip;
#pragma mark - Execution Flow Control Methods
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

- (void)pauseOrResumeBatch;

@end
