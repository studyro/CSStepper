//
//  CSProgram.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSCodeView.h"

@interface CSProgram : NSObject

@property (nonatomic, assign) NSRange currentRange;
@property (nonatomic, copy) NSString *codeText;

- (instancetype)initWithCodeText:(NSString *)codeText indexPaths:(NSArray *)indexPaths;

- (void)acceptCodeView:(CSCodeView *)codeView;

- (void)nextStep;

- (void)lastStep;

- (BOOL)hasNext;

@end
