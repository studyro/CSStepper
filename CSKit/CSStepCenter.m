//
//  CSStepCenter.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStepCenter.h"
#import "CSProgram.h"
#import "CSInterface.h"

static CSStepCenter *instance = nil;

@interface CSStepCenter()

@property (nonatomic, retain) CSProgram *currentProgram;
@property (nonatomic, retain) CSInterface *currentInterface;

@end

@implementation CSStepCenter

+ (instancetype)sharedStepCenter
{
    static dispatch_once_t once;
    dispatch_once(&once, ^ { instance = [[[self class] alloc] init]; });
    return instance;
}

@end