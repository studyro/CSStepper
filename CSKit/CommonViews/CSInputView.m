//
//  CSInputView.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSInputView.h"

#define RADIAN(a) ((a / 360.0) * M_PI)

@interface CSInputView () <UITextFieldDelegate>

@property (strong, nonatomic, readwrite) UITextField *textField;

@property (strong, nonatomic, readwrite) UILabel *nameLabel;

@end

@implementation CSInputView

+ (CGSize)sizeOfNameLabelWithName:(NSString *)name
{
    CGSize size = [name sizeWithFont:[UIFont systemFontOfSize:19.0]];
    
    return size;
}

- (instancetype)initWithName:(NSString *)name
{
    if (self = [super init]) {
        CGSize labelSize = [[self class] sizeOfNameLabelWithName:name];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, labelSize.width + 4.0, labelSize.height + 4.0)];
        self.nameLabel.font = [UIFont systemFontOfSize:15.0];
        self.nameLabel.backgroundColor = [UIColor blackColor];
        self.nameLabel.textColor = [UIColor whiteColor];
        self.nameLabel.text = name;
        self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        [self addSubview:self.nameLabel];
        
        self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.nameLabel.frame.size.width + 2.0, 0.0, 200.0, self.nameLabel.frame.size.height)];
        self.textField.backgroundColor = [UIColor blackColor];
        self.textField.textColor = [UIColor whiteColor];
        self.textField.font = [UIFont systemFontOfSize:18.5];
        self.textField.delegate = self;
        self.textField.returnKeyType = UIReturnKeyDone;
        self.textField.clearButtonMode = UITextFieldViewModeAlways;
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self addSubview:self.textField];
        
        self.backgroundColor = [UIColor whiteColor];
        self.bounds = CGRectMake(0.0, 0.0, CGRectGetWidth(self.nameLabel.bounds) + 2.0 + CGRectGetWidth(self.textField.bounds), CGRectGetHeight(self.nameLabel.bounds));
    }
    
    return self;
}

- (void)showInView:(UIView *)view centerAt:(CGPoint)destCenter animted:(BOOL)animated
{
    CGRect superBounds = view.bounds;
    
    self.center = CGPointMake(superBounds.size.width * 0.5, superBounds.size.height + self.bounds.size.height);
    [view addSubview:self];
    
    self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -RADIAN(30.0));
    
    if (animated) {
        [UIView animateWithDuration:0.8 animations:^{
            self.center = destCenter;
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished){
            [self.textField becomeFirstResponder];
        }];
    }
    else {
        self.center = destCenter;
        self.transform = CGAffineTransformIdentity;
        [self.textField becomeFirstResponder];
    }
}

- (void)dismissWithSuccess:(BOOL)success
{
    if (self.superview) {
        CGPoint destCenter = CGPointMake(self.center.x, self.superview.superview.bounds.size.height + self.bounds.size.height);
        
        [UIView animateWithDuration:0.8 animations:^{
            self.center = destCenter;
            self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -RADIAN(30.0));
        } completion:^(BOOL finished){
            if (self.doneBlock && success) {
                self.doneBlock(self.textField.text);
            }
            [self removeFromSuperview];
        }];
    }
}

- (void)dismiss
{
    [self dismissWithSuccess:NO];
}

#pragma mark - UITextField Delgate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    BOOL shouldReutrn = YES;
    if (self.verifyBlock) {
        shouldReutrn = self.verifyBlock(textField.text);
    }
    
    if (shouldReutrn == NO) {
        textField.text = @"";
    }
    else {
        [self.textField resignFirstResponder];
        [self dismissWithSuccess:YES];
    }
    
    return shouldReutrn;
}

@end
