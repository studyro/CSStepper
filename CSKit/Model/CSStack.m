//
//  CSStack.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-7.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStack.h"

@implementation CSStack

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        self.name = name;
        self.variables = [[NSMutableArray alloc] init];
        self.isActivated = YES;
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"name:%@ variable:%@", self.name, self.variables];
}

@end
