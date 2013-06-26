//
//  CSUtils.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CSInterface;

typedef NSString kCSProgramCase;

extern NSString *const kCSProgramCaseSelectionSort;
extern NSString *const kCSProgramCaseCharPointerArray;
extern NSString *const kCSProgramCaseStringSort;
extern NSString *const kCSProgramCaseArrayPointer;
extern NSString *const kCSProgramCaseMultiLevelPointer;
extern NSString *const kCSProgramCaseDeleteNumberString;
extern NSString *const kCSProgramCaseStructElection;
extern NSString *const kCSProgramCaseMinValueFirst;
extern NSString *const kCSProgramCaseMaxString;
extern NSString *const kCSProgramCaseLifeScope;

@interface CSUtils : NSObject

+ (CSInterface *)interfaceWithCase:(kCSProgramCase *)caseString;

+ (NSIndexPath *)mainIndexPathWithCase:(kCSProgramCase *)caseString;

@end
