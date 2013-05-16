//
//  CSCommentView.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSCommentView.h"
#import <QuartzCore/QuartzCore.h>

#define RADIANS(deg) ((deg) * M_PI / 180.0f)

@interface CSCommentView()

@property (strong, nonatomic) UIView *blankView;
@property (strong, nonatomic) UILabel *commentView;

@property (assign, nonatomic) __block BOOL isShowed;

@property (strong, nonatomic) NSTimer *recoverTimer;

@end

@implementation CSCommentView

- (id)initWithFrame:(CGRect)frame comment:(NSString *)comment
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.commentView = [[UILabel alloc] initWithFrame:self.bounds];
        self.commentView.lineBreakMode = NSLineBreakByWordWrapping;
        self.commentView.font = [UIFont systemFontOfSize:15.0];
        
        CATransform3D startTransform = CATransform3DMakeRotation(RADIANS(-120.0), 1.0, 0.0, 0.0);
        startTransform.m34 = -1.0/200.0;
        self.commentView.layer.transform = startTransform;
        self.commentView.layer.doubleSided = NO;
        self.commentView.text = comment;
        
        [self addSubview:self.commentView];
        self.isShowed = NO;
    }
    return self;
}

- (void)show
{
    if (!self.isShowed) {
        [self rotateCommentView];
    }
}

- (NSTimeInterval)properTimeInterval
{
    return 6.0;
}

- (void)rotateCommentView
{
    CATransform3D endTransform;
    if (self.isShowed) {
        endTransform = CATransform3DMakeRotation(RADIANS(120.0), 1.0, 0.0, 0.0);
    }
    else {
        endTransform = CATransform3DIdentity;
    }
    
    [UIView animateWithDuration:1.0 animations:^{
        self.isShowed = !self.isShowed;
        self.commentView.layer.transform = endTransform;
    } completion:^(BOOL finished) {
        if (self.isShowed) {
            self.recoverTimer = [NSTimer scheduledTimerWithTimeInterval:[self properTimeInterval] target:self selector:@selector(rotateCommentView) userInfo:nil repeats:NO];
        }
        else {
            if (self.recoverTimer) {
                [self.recoverTimer invalidate];
                self.recoverTimer = nil;
            }
            [self removeFromSuperview];
        }
    }];
}

- (void)dismiss
{
    if (self.recoverTimer && self.isShowed) {
        [self.recoverTimer invalidate];
        self.recoverTimer = nil;
        [self rotateCommentView];
    }
}
@end
