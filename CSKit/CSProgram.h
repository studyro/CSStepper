//
//  CSProgram.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCodeView.h"
#import "CSUtils.h"

@interface CSProgram : NSObject

@property (nonatomic, copy) NSString *codeText;

// codeView's highlight is managed by this class, not viewControllers or other classes
@property (assign, nonatomic) CSCodeView *codeView;

@property (strong, nonatomic, readonly) NSIndexPath *currentIndexPath;

@property (strong, nonatomic, readonly) NSIndexPath *nextIndexPath;

+ (instancetype)sharedProgram;

- (void)reloadProgram:(kCSProgramCase *)aCase
                error:(NSError **)error;

- (void)beginNewScopeWithLoopCount:(NSInteger)loopCount;

- (void)beginNewScopeAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)isAtTheLoopBeginning;

// step changing is called by interface logic.
- (BOOL)nextStep;

- (void)lastStep;

- (BOOL)hasChildrenOfCodeAtIndexPath:(NSIndexPath *)indexPath;

@end
