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

#pragma mark - Execution Flow Control Methods
// this method should be called after backgroundView is accepted.
- (void)construct;
// 这个方法应该在每个例子中重写，这个方法将在例子执行每步之前被自动调用，方法中应该根据当前执行到的索引路径并对照例子代码的原文来确定beginNewScope的参数。
- (void)tryToBeginNewScope;
// 这个方法应该在每个例子中重写，这个方法将在高亮下一行代码之后执行，重写时应该针对当前执行到的索引路径实现相应的动画变化。
- (void)executeStep;
// 本方法可以本重写，重写最后要调用父类的本方法[super highlightNextLine]。
- (BOOL)highlightNextLine;

- (void)nextStep;

// a timer executor. Parameter of stepBlock starts from 1, end to {#stepCount}
- (void)nextBatchStepsOfCount:(NSUInteger)stepCount
                 timeInterval:(NSTimeInterval)timeInterval
                    stepBlock:(void (^)(NSUInteger currentStep))stepBlock
              completionBlock:(void (^)(void))completionBlock;

- (void)pauseOrResumeBatch;

@end
