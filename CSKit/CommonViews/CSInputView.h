//
//  CSInputView.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-5-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^CSInputVerifyBlock)(NSString *text);
typedef void (^CSInputDoneBlock)(NSString *text);

@interface CSInputView : UIView

@property (strong, nonatomic, readonly) UITextField *textField;

@property (strong, nonatomic, readonly) UILabel *nameLabel;

@property (copy, nonatomic) CSInputVerifyBlock verifyBlock;
@property (copy, nonatomic) CSInputDoneBlock doneBlock;

+ (CGSize)sizeOfNameLabelWithName:(NSString *)name;

- (instancetype)initWithName:(NSString *)name;

- (void)showInView:(UIView *)view centerAt:(CGPoint)destCenter animted:(BOOL)animated;
- (void)dismiss;

@end
