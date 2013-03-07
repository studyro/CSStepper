//
//  CSStepCenter.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSStepCenter : NSObject

+ (instancetype)sharedStepCenter;

- (void)loadProgramWithCodeView:(UIView *)codeView andInterfaceView:(UIView *)interfaceView;

@end
