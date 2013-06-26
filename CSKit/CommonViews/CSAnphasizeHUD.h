//
//  CSAnphasizeHUD.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-17.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSAnphasizeHUD : UIView

@property (nonatomic, strong, readonly) UILabel *textLabel;

- (void)showWithDuration:(NSUInteger)duration text:(NSString *)text inView:(UIView *)view centerPoint:(CGPoint)center;
- (void)dismiss;

@end
