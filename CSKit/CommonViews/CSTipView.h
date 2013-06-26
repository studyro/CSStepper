//
//  CSTipView.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSTipView : UIView

@property (strong, nonatomic, readonly) UILabel *textLabel;
@property (assign, nonatomic) CGFloat maxWidth; // default 433.0

- (void)showWithText:(NSString *)text atCenter:(CGPoint)centerPoint animated:(BOOL)animated;
- (void)hideAnimted:(BOOL)animated;

@end
