//
//  CSAnphasizeHUD.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-17.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSAnphasizeHUD.h"
#import <QuartzCore/QuartzCore.h>

#define MAX_WIDTH 200.0

@interface CSAnphasizeHUD ()

@property (nonatomic, strong) NSTimer *displayTimer;
@property (nonatomic, strong, readwrite) UILabel *textLabel;

@end

@implementation CSAnphasizeHUD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        self.opaque = NO;
        self.alpha = 0.0;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 4.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.0, 6.0);
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [[self class] labelFont];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:self.textLabel];
    }
    return self;
}

+ (UIFont *)labelFont
{
    return [UIFont systemFontOfSize:18.0];
}

+ (CGSize)sizeOfString:(NSString *)text
{
    return [text sizeWithFont:[[self class] labelFont] constrainedToSize:CGSizeMake(MAX_WIDTH, 1000.0) lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)invalidateTimer
{
    [self.displayTimer invalidate];
    self.displayTimer = nil;
}

- (void)showWithDuration:(NSUInteger)duration text:(NSString *)text inView:(UIView *)view centerPoint:(CGPoint)center
{
    [view addSubview:self];
    self.textLabel.text = text;
    CGSize textSize = [[self class] sizeOfString:text];
    CGSize hudSize = CGSizeMake(textSize.width + 16.0, textSize.height + 24.0);
    self.bounds = CGRectMake(0.0, 0.0, hudSize.width, hudSize.height);
    self.center = center;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished){
                self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
            }];
        }];
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
        self.alpha = 0.0;
    } completion:^(BOOL finished){
        [self invalidateTimer];
        [self removeFromSuperview];
    }];
}

@end
