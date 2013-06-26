//
//  CSConvenientAnimation.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-29.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSConvenientAnimation.h"

@implementation CSConvenientAnimation

+ (void)applyAnphasizeAnimationToView:(UIView *)view scale:(CGFloat)scale duration:(NSTimeInterval)duration
{
    NSTimeInterval halfedDuration = duration * 0.5;
    [UIView animateWithDuration:halfedDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.15, 1.15);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:halfedDuration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

@end
