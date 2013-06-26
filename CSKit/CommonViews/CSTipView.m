//
//  CSTipView.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSTipView.h"
#import "UIColor+FlatUI.h"
#import <QuartzCore/QuartzCore.h>

@interface CSTipView ()
@property (strong, nonatomic, readwrite) UILabel *textLabel;
@end

@implementation CSTipView

- (id)init
{
    if (self = [super init]) {
        self.opaque = NO;
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 4.0;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.textLabel = [[UILabel alloc] init];
        self.textLabel.font = [UIFont systemFontOfSize:18.0];
        self.textLabel.textColor = [UIColor cloudsColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        self.textLabel.backgroundColor = [UIColor midnightBlueColor];
        self.textLabel.numberOfLines = 0;
        self.textLabel.layer.cornerRadius = 4.0;
        self.textLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self addSubview:self.textLabel];
        
        self.maxWidth = 433.0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.textLabel.backgroundColor = backgroundColor;
}

- (CGRect)properBoundsWithText:(NSString *)text
{
    CGSize textSize = [text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(self.maxWidth, 1000.0) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize adaptedSize = CGSizeMake(textSize.width + 10.0, textSize.height + 10.0);
    
    return CGRectMake(0.0, 0.0, adaptedSize.width, adaptedSize.height);
}

- (void)showWithText:(NSString *)text atCenter:(CGPoint)centerPoint animated:(BOOL)animated
{
    self.textLabel.text = text;
    self.bounds = [self properBoundsWithText:text];
    self.center = centerPoint;
    self.textLabel.frame = self.bounds;
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 1.0;
    } completion:nil];
}

- (void)hideAnimted:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        }];
    }
    else {
        self.alpha = 0.0;
    }
}

@end
