//
//  CSBlockView.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-18.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BVStatusInactive = 0,
    BVStatusActive = 1,
    BVStatusToBeActive = 2
}BVStatus;

@interface CSBlockView : UIView

// TODO : tappable
@property (nonatomic, assign) BOOL tappable;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) __block BVStatus status;

@property (nonatomic, assign) CGFloat borderWidth;

- (void)setStatus:(BVStatus)status animated:(BOOL)animated;

@end