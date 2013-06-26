//
//  CSBlockView.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-18.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BVStatusNormal = 0,
    BVStatusInactive = 1,
    BVStatusActive = 2,
    BVStatusToBeActive = 3
}BVStatus;

@interface CSBlockView : UIView

// TODO : tappable
@property (nonatomic, assign) BOOL tappable;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) __block BVStatus status;

@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) UIColor *borderColor;

- (void)setStatus:(BVStatus)status animated:(BOOL)animated;

@end