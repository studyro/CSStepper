//
//  CSInterface.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSInterface.h"

@implementation CSInterface

- (void)dealloc
{
    [_backgroundView release];
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        // subclasses should initialize the animation queue here.
    }
    
    return self;
}

- (void)acceptBackgroundView:(UIView *)view
{
    if (_backgroundView) [_backgroundView release];
    _backgroundView = [view retain];
}

- (void)buildInterface
{
    
}

- (void)nextStep
{
    // should be implemented by subclasses
}

- (void)lastStep
{
    // should be implemented by subclasses
}

- (BOOL)hasNext
{
    // should be implemented by subclasses
    return NO;
}

@end
