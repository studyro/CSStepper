//
//  CSCodeView.h
//  Code
//
//  Created by Zhang Studyro on 13-2-13.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSCodeView : UIView

// need to reset the paragraphStyleSetting when font is changed
- (void)setText:(NSString *)text configureWithBlock:(void (^)(NSMutableAttributedString *mutableAttributeString))block;

- (void)highlightTextInRange:(NSRange)range;

- (CGFloat)suggestedTextHeight;

@end
