//
//  CSCommentView.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCommentView : UIView

- (instancetype)initWithFrame:(CGRect)frame comment:(NSString *)comment;

// safely
- (void)show;
- (void)dismiss;

@end
