//
//  CSUtils.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSUtils.h"
#import "CSSelectionSortInterface.h"
#import "CSCharPointerArrayInterface.h"

NSString *const kCSProgramCaseSelectionSort = @"SelectionSort";
NSString *const kCSProgramCaseCharPointerArray = @"CharPointerArray";
NSString *const kCSProgramCaseStringSort = @"StringSort";
NSString *const kCSProgramCaseArrayPointer = @"ArrayPointer";
NSString *const kCSProgramCaseMultiLevelPointer = @"MultiLevelPointer";
NSString *const kCSProgramCaseDeleteNumberString = @"DeleteNumberString";
NSString *const kCSProgramCaseStructElection = @"StructElection";
NSString *const kCSProgramCaseMinValueFirst = @"MinValueFirst";
NSString *const kCSProgramCaseMaxString = @"MaxString";
NSString *const kCSProgramCaseLifeScope = @"LifeScope";

@implementation CSUtils

+ (CSInterface *)interfaceWithCase:(kCSProgramCase *)caseString
{
    NSString *className = [NSString stringWithFormat:@"CS%@Interface", caseString];
    
    Class c = NSClassFromString(className);
    
    if (c) {
        return [[c alloc] init];
    }
    else {
        return nil;
    }
}

+ (NSIndexPath *)mainIndexPathWithCase:(kCSProgramCase *)caseString
{
    if ([kCSProgramCaseMultiLevelPointer isEqualToString:caseString] ||
        [kCSProgramCaseLifeScope isEqualToString:caseString])
        return [NSIndexPath indexPathWithIndex:3];
    else if ([kCSProgramCaseStructElection isEqualToString:caseString] ||
             [kCSProgramCaseDeleteNumberString isEqualToString:caseString] ||
             [kCSProgramCaseStringSort isEqualToString:caseString] ||
             [kCSProgramCaseMaxString isEqualToString:caseString])
        return [NSIndexPath indexPathWithIndex:1];
    else {
        return [NSIndexPath indexPathWithIndex:0];
    }
}

@end
