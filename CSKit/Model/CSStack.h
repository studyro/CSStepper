//
//  CSStack.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-7.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSStack : NSObject

@property (copy ,nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *variables;
@property (assign, nonatomic) BOOL isActivated;

- (instancetype)initWithName:(NSString *)name;

@end
