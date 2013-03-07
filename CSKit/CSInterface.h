//
//  CSInterface.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSInterface : NSObject

@property (nonatomic, readonly) UIView *backgroundView;

- (void)acceptBackgroundView:(UIView *)view;

- (void)buildInterface;

- (void)nextStep;

- (void)lastStep;

- (BOOL)hasNext;

@end
