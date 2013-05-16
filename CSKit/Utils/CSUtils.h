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

@interface CSUtils : NSObject

+ (CSInterface *)interfaceWithCase:(kCSProgramCase *)caseString;

+ (NSIndexPath *)mainIndexPathWithCase:(kCSProgramCase *)caseString;

@end
